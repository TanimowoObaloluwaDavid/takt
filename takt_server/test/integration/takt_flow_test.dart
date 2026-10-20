import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a Takt workspace', (sessionBuilder, endpoints) {
    // Serverpod rolls each test back, so every test builds its own workspace.
    Future<String> prepare() async {
      final shop = await endpoints.shop.create(
        sessionBuilder,
        'Integration Shop',
        'USD',
      );
      expect(shop.accessKey.length, greaterThanOrEqualTo(20));
      final loaded = await endpoints.shop.loadDemo(
        sessionBuilder,
        shop.accessKey,
      );
      expect(loaded, 14);
      return shop.accessKey;
    }

    test(
      'sample data arrives through the same endpoints as user data',
      () async {
        final key = await prepare();
        final centers = await endpoints.workCenter.list(sessionBuilder, key);
        final jobs = await endpoints.job.list(sessionBuilder, key);

        expect(centers, hasLength(7));
        expect(jobs, hasLength(14));
        expect(jobs.expand((bundle) => bundle.operations), hasLength(41));
        expect(centers.map((center) => center.code), contains('CNC-02'));
        expect(jobs.every((bundle) => bundle.operations.isNotEmpty), isTrue);
      },
    );

    test('every operation is placed and every late job is explained', () async {
      final key = await prepare();
      final jobs = await endpoints.job.list(sessionBuilder, key);
      final operationCount = jobs.fold<int>(
        0,
        (sum, bundle) => sum + bundle.operations.length,
      );

      final snapshot = await endpoints.schedule.solve(
        sessionBuilder,
        key,
        seed: 1234,
      );

      expect(snapshot.scheduledOps, hasLength(operationCount));
      expect(snapshot.diagnosis.jobs, hasLength(jobs.length));
      expect(
        snapshot.scheduledOps.every(
          (operation) => operation.endMinute > operation.startMinute,
        ),
        isTrue,
      );

      final late = snapshot.diagnosis.jobs
          .where((verdict) => verdict.isTardy)
          .toList();
      expect(
        late,
        isNotEmpty,
        reason: 'the demo data is deliberately overloaded',
      );
      for (final verdict in late) {
        expect(verdict.tardinessMinutes, greaterThan(0));
        expect(verdict.bindingWorkCenterName, isNotEmpty);
        expect(verdict.bindingQueueMinutes, greaterThanOrEqualTo(0));
        expect(verdict.explanation, isNotEmpty);
        expect(verdict.chain, isNotEmpty);
      }

      expect(snapshot.diagnosis.bottleneckWorkCenterName, 'CNC Mill 2');
      expect(snapshot.diagnosis.bottleneckUtilization, greaterThan(0));
    });

    test('the same seed reproduces the same schedule', () async {
      final key = await prepare();
      final first = await endpoints.schedule.solve(
        sessionBuilder,
        key,
        seed: 4242,
      );
      final second = await endpoints.schedule.solve(
        sessionBuilder,
        key,
        seed: 4242,
      );

      expect(second.run.makespanMinutes, first.run.makespanMinutes);
      expect(
        second.diagnosis.totalTardinessMinutes,
        first.diagnosis.totalTardinessMinutes,
      );

      final firstFingerprint = first.scheduledOps
          .map(
            (operation) =>
                '${operation.operationId}:${operation.machineIndex}:'
                '${operation.startMinute}',
          )
          .join('|');
      final secondFingerprint = second.scheduledOps
          .map(
            (operation) =>
                '${operation.operationId}:${operation.machineIndex}:'
                '${operation.startMinute}',
          )
          .join('|');

      expect(secondFingerprint, firstFingerprint);
    });

    test('what-if isolates a capacity change with a shared seed', () async {
      final key = await prepare();
      final baseline = await endpoints.schedule.solve(
        sessionBuilder,
        key,
        seed: 90210,
      );
      final result = await endpoints.schedule.whatIf(
        sessionBuilder,
        key,
        workCenterId: baseline.diagnosis.bottleneckWorkCenterId,
        extraMachines: 1,
      );

      expect(
        result.workCenterName,
        baseline.diagnosis.bottleneckWorkCenterName,
      );
      expect(result.extraMachines, 1);
      expect(
        result.baselineTardinessMinutes,
        baseline.diagnosis.totalTardinessMinutes,
      );
      expect(
        result.scenarioTardinessMinutes,
        lessThanOrEqualTo(result.baselineTardinessMinutes),
      );
      expect(
        result.savedTardinessMinutes,
        result.baselineTardinessMinutes - result.scenarioTardinessMinutes,
      );
    });

    test('a wrong workspace key cannot reach the shop', () async {
      final key = await prepare();
      expect(key, isNotEmpty);
      expect(
        () => endpoints.job.list(sessionBuilder, 'not-a-real-workspace-key'),
        throwsA(anything),
      );
    });
  });
}
