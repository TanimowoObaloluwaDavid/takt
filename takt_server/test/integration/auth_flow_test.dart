import 'package:takt_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Takt accounts', (sessionBuilder, endpoints) {
    const ownerPassword = 'Correct horse battery 42';
    const memberPassword = 'Member battery horse 42';

    Future<AuthResult> register(
      String email,
      String name, [
      String password = memberPassword,
    ]) {
      return endpoints.auth.register(
        sessionBuilder,
        email,
        password,
        name,
      );
    }

    test('registration, login, session identity, and logout', () async {
      final owner = await register(
        'owner@auth.test',
        'Tunde Ajao',
        ownerPassword,
      );
      expect(owner.user.email, 'owner@auth.test');
      expect(owner.user.displayName, 'Tunde Ajao');
      expect(owner.token, isNotEmpty);
      expect(owner.workspaces, isEmpty);

      final login = await endpoints.auth.login(
        sessionBuilder,
        'OWNER@auth.test',
        ownerPassword,
      );
      expect(login.user.id, owner.user.id);
      expect(login.token, isNot(owner.token));

      final me = await endpoints.auth.me(sessionBuilder, login.token);
      expect(me.user.id, owner.user.id);

      expect(await endpoints.auth.logout(sessionBuilder, login.token), isTrue);
      await expectLater(
        endpoints.auth.me(sessionBuilder, login.token),
        throwsA(isA<TaktException>()),
      );

      // The first session is independent and still valid.
      final stillThere = await endpoints.auth.me(sessionBuilder, owner.token);
      expect(stillThere.user.id, owner.user.id);
    });

    test(
      'duplicate email and wrong password fail with readable errors',
      () async {
        await register('duplicate@auth.test', 'First Person', ownerPassword);

        try {
          await register('DUPLICATE@auth.test', 'Second Person', ownerPassword);
          fail('duplicate registration should fail');
        } on TaktException catch (error) {
          expect(error.message, contains('already exists'));
        }

        try {
          await endpoints.auth.login(
            sessionBuilder,
            'duplicate@auth.test',
            'this is the wrong password',
          );
          fail('wrong password should fail');
        } on TaktException catch (error) {
          expect(error.message, 'Email or password is incorrect.');
        }
      },
    );

    test('an account owns a workspace and sees its real sample data', () async {
      final owner = await register(
        'shop-owner@auth.test',
        'Shop Owner',
        ownerPassword,
      );
      final workspace = await endpoints.workspace.create(
        sessionBuilder,
        owner.token,
        'Auth Shop',
        'NGN',
        true,
      );

      expect(workspace.role, 'owner');
      expect(workspace.currency, 'NGN');
      expect(workspace.accessKey, isNotEmpty);

      final centers = await endpoints.workCenter.list(
        sessionBuilder,
        workspace.accessKey,
      );
      final jobs = await endpoints.job.list(
        sessionBuilder,
        workspace.accessKey,
      );
      expect(centers, hasLength(7));
      expect(jobs, hasLength(14));
      expect(
        jobs.map((bundle) => bundle.job.customer),
        contains('Eko Marine Services'),
      );

      final me = await endpoints.auth.me(sessionBuilder, owner.token);
      expect(me.workspaces, hasLength(1));
      expect(me.workspaces.single.shopId, workspace.shopId);
      expect(me.workspaces.single.accessKey, workspace.accessKey);
    });

    test('viewer keys read but cannot write, and are redacted', () async {
      final owner = await register(
        'role-owner@auth.test',
        'Role Owner',
        ownerPassword,
      );
      final member = await register('viewer@auth.test', 'Sam Viewer');
      final workspace = await endpoints.workspace.create(
        sessionBuilder,
        owner.token,
        'Role Shop',
        'USD',
        false,
      );

      final invitation = await endpoints.workspace.invite(
        sessionBuilder,
        owner.token,
        workspace.shopId,
        member.user.email,
        'viewer',
      );
      expect(invitation.role, 'viewer');
      expect(invitation.accessKey, isNotEmpty);

      final fetched = await endpoints.shop.fetch(
        sessionBuilder,
        invitation.accessKey,
      );
      expect(fetched.name, 'Role Shop');
      expect(fetched.accessKey, isEmpty);

      final access = await endpoints.workspace.access(
        sessionBuilder,
        invitation.accessKey,
      );
      expect(access.role, 'viewer');

      final center = WorkCenter(
        shopId: workspace.shopId,
        name: 'Viewer Attempt',
        code: 'VW1',
        machines: 1,
        changeoverMinutes: 0,
        notes: '',
      );
      try {
        await endpoints.workCenter.save(
          sessionBuilder,
          invitation.accessKey,
          center,
        );
        fail('a viewer write must be rejected by the server');
      } on TaktException catch (error) {
        expect(error.message, contains('view-only'));
      }

      final ownerMembers = await endpoints.workspace.members(
        sessionBuilder,
        owner.token,
        workspace.shopId,
      );
      expect(ownerMembers, hasLength(2));
      expect(
        ownerMembers.every((person) => person.accessKey.isNotEmpty),
        isTrue,
      );

      final viewerMembers = await endpoints.workspace.members(
        sessionBuilder,
        member.token,
        workspace.shopId,
      );
      expect(viewerMembers, hasLength(2));
      expect(
        viewerMembers.every((person) => person.accessKey.isEmpty),
        isTrue,
      );

      await expectLater(
        endpoints.workspace.invite(
          sessionBuilder,
          member.token,
          workspace.shopId,
          'nobody@auth.test',
          'viewer',
        ),
        throwsA(isA<TaktException>()),
      );
    });

    test(
      'role changes and removal take effect on the same scoped key',
      () async {
        final owner = await register(
          'editor-owner@auth.test',
          'Editor Owner',
          ownerPassword,
        );
        final member = await register('editor@auth.test', 'Ed Editor');
        final workspace = await endpoints.workspace.create(
          sessionBuilder,
          owner.token,
          'Editor Shop',
          'USD',
          false,
        );
        final invitation = await endpoints.workspace.invite(
          sessionBuilder,
          owner.token,
          workspace.shopId,
          member.user.email,
          'viewer',
        );

        final updated = await endpoints.workspace.setRole(
          sessionBuilder,
          owner.token,
          workspace.shopId,
          member.user.id,
          'editor',
        );
        expect(updated.role, 'editor');

        final saved = await endpoints.workCenter.save(
          sessionBuilder,
          invitation.accessKey,
          WorkCenter(
            shopId: workspace.shopId,
            name: 'Editor Center',
            code: 'ED1',
            machines: 2,
            changeoverMinutes: 5,
            notes: 'written with the same key',
          ),
        );
        expect(saved.id, isNotNull);

        expect(
          await endpoints.workspace.removeMember(
            sessionBuilder,
            owner.token,
            workspace.shopId,
            member.user.id,
          ),
          isTrue,
        );

        await expectLater(
          endpoints.workCenter.list(sessionBuilder, invitation.accessKey),
          throwsA(isA<TaktException>()),
        );
      },
    );

    test(
      'a legacy full-access key can be claimed without losing access',
      () async {
        final shop = await endpoints.shop.create(
          sessionBuilder,
          'Legacy Shop',
          'USD',
        );
        final owner = await register(
          'legacy-owner@auth.test',
          'Legacy Owner',
          ownerPassword,
        );

        final claimed = await endpoints.workspace.claim(
          sessionBuilder,
          owner.token,
          shop.accessKey,
        );
        expect(claimed.shopId, shop.id);
        expect(claimed.role, 'owner');
        expect(claimed.accessKey, shop.accessKey);

        final list = await endpoints.workspace.list(
          sessionBuilder,
          owner.token,
        );
        expect(list.map((workspace) => workspace.shopId), contains(shop.id));

        // The original key remains the owner key and keeps working.
        final access = await endpoints.workspace.access(
          sessionBuilder,
          shop.accessKey,
        );
        expect(access.role, 'owner');
        final fetched = await endpoints.shop.fetch(
          sessionBuilder,
          shop.accessKey,
        );
        expect(fetched.accessKey, shop.accessKey);
      },
    );

    test('a routing cannot borrow another shop\'s work center', () async {
      final owner = await register(
        'tenant-owner@auth.test',
        'Tenant Owner',
        ownerPassword,
      );
      final other = await register(
        'tenant-other@auth.test',
        'Other Owner',
        ownerPassword,
      );
      final first = await endpoints.workspace.create(
        sessionBuilder,
        owner.token,
        'First Tenant',
        'USD',
        false,
      );
      final second = await endpoints.workspace.create(
        sessionBuilder,
        other.token,
        'Second Tenant',
        'USD',
        false,
      );
      final foreignCenter = await endpoints.workCenter.save(
        sessionBuilder,
        second.accessKey,
        WorkCenter(
          shopId: second.shopId,
          name: 'Foreign Cell',
          code: 'FOR-1',
          machines: 1,
          changeoverMinutes: 0,
          notes: '',
        ),
      );

      await expectLater(
        endpoints.job.save(
          sessionBuilder,
          first.accessKey,
          JobBundle(
            job: Job(
              shopId: first.shopId,
              code: 'CROSS-1',
              title: 'Cross-tenant reference',
              customer: '',
              quantity: 1,
              dueAt: DateTime.now().add(const Duration(days: 2)),
              releaseAt: DateTime.now(),
              priority: 1,
              notes: '',
            ),
            operations: [
              Operation(
                jobId: 0,
                sequence: 10,
                workCenterId: foreignCenter.id!,
                setupMinutes: 0,
                unitRunMinutes: 1,
                description: 'Should be rejected',
              ),
            ],
          ),
        ),
        throwsA(
          isA<TaktException>().having(
            (error) => error.message,
            'message',
            contains('from this shop'),
          ),
        ),
      );

      expect(
        await endpoints.job.list(sessionBuilder, first.accessKey),
        isEmpty,
      );
    });

    test('password change revokes other sessions only', () async {
      final owner = await register(
        'password@auth.test',
        'Password Owner',
        ownerPassword,
      );
      final second = await endpoints.auth.login(
        sessionBuilder,
        'password@auth.test',
        ownerPassword,
      );

      expect(
        await endpoints.auth.changePassword(
          sessionBuilder,
          owner.token,
          ownerPassword,
          'A newer correct battery 42',
        ),
        isTrue,
      );

      await expectLater(
        endpoints.auth.me(sessionBuilder, second.token),
        throwsA(isA<TaktException>()),
      );
      final current = await endpoints.auth.me(sessionBuilder, owner.token);
      expect(current.user.id, owner.user.id);

      await expectLater(
        endpoints.auth.login(
          sessionBuilder,
          'password@auth.test',
          ownerPassword,
        ),
        throwsA(isA<TaktException>()),
      );
      final login = await endpoints.auth.login(
        sessionBuilder,
        'password@auth.test',
        'A newer correct battery 42',
      );
      expect(login.user.id, owner.user.id);
    });
  });
}
