// Seeds the fictional Ajao Precision Works demo into a running Takt server.
//
// Usage:
//   dart run tool/seed_cloud.dart [host]
//
// The default host is the Serverpod Cloud deployment. The script is
// idempotent: existing accounts are signed in, an existing workspace is
// reused, and existing members are left alone.

import 'dart:convert';
import 'dart:io';

import 'package:takt_client/takt_client.dart';

const _defaultHost = 'https://takt-demo.api.serverpod.space/';
const _password = 'Lagos.2026!';

Future<void> main(List<String> args) async {
  final host = args.isEmpty ? _defaultHost : args.first;
  final client = Client(host);

  try {
    final tunde = await _ensureAccount(
      client,
      email: 'tunde@ajaoprecision.ng',
      displayName: 'Tunde Ajao',
    );
    final ngozi = await _ensureAccount(
      client,
      email: 'ngozi@ajaoprecision.ng',
      displayName: 'Ngozi Eze',
    );
    final amina = await _ensureAccount(
      client,
      email: 'amina@lekkifluid.ng',
      displayName: 'Amina Bello',
    );

    var ajao = await _findWorkspace(client, tunde);
    if (ajao == null) {
      ajao = await client.workspace.create(
        tunde.token,
        'Ajao Precision Works',
        'NGN',
        true,
      );
      stdout.writeln('Created workspace ${ajao.shopId}.');
    } else {
      stdout.writeln('Reusing workspace ${ajao.shopId}.');
    }

    await _invite(client, tunde, ajao.shopId, ngozi.user.email, 'editor');
    await _invite(client, tunde, ajao.shopId, amina.user.email, 'viewer');

    final members = await client.workspace.members(
      tunde.token,
      ajao.shopId,
    );
    final keys = {
      for (final member in members) member.email: member.accessKey,
    };

    final viewerKey = keys[amina.user.email]!;
    final editorKey = keys[ngozi.user.email]!;

    final shop = await client.shop.fetch(viewerKey);
    final access = await client.workspace.access(viewerKey);
    final jobs = await client.job.list(viewerKey);

    var viewerWrite = 'allowed (unexpected)';
    try {
      await client.job.remove(viewerKey, jobs.first.job.id!);
    } on TaktException catch (error) {
      viewerWrite = error.message;
    }

    var editorPeople = 'allowed (unexpected)';
    try {
      await client.workspace.invite(
        editorKey,
        ajao.shopId,
        'nobody@example.com',
        'viewer',
      );
    } on TaktException catch (error) {
      editorPeople = error.message;
    }

    stdout.writeln(
      const JsonEncoder.withIndent('  ').convert({
        'host': host,
        'shopId': ajao.shopId,
        'shop': shop.name,
        'currency': shop.currency,
        'jobs': jobs.length,
        'viewerRole': access.role,
        'viewerWrite': viewerWrite,
        'editorManagePeople': editorPeople,
        'ownerKey': ajao.accessKey,
        'editorKey': editorKey,
        'viewerKey': viewerKey,
        'members': [
          for (final member in members)
            {
              'email': member.email,
              'name': member.displayName,
              'role': member.role,
            },
        ],
      }),
    );
  } finally {
    client.close();
  }
}

Future<AuthResult> _ensureAccount(
  Client client, {
  required String email,
  required String displayName,
}) async {
  try {
    return await client.auth.register(email, _password, displayName);
  } on TaktException catch (error) {
    if (!error.message.contains('already exists')) rethrow;
    return client.auth.login(email, _password);
  }
}

Future<WorkspaceAccess?> _findWorkspace(
  Client client,
  AuthResult account,
) async {
  final workspaces = await client.workspace.list(account.token);
  for (final workspace in workspaces) {
    if (workspace.name == 'Ajao Precision Works') return workspace;
  }
  return null;
}

Future<void> _invite(
  Client client,
  AuthResult owner,
  int shopId,
  String email,
  String role,
) async {
  try {
    await client.workspace.invite(owner.token, shopId, email, role);
    stdout.writeln('Invited $email as $role.');
  } on TaktException catch (error) {
    if (!error.message.contains('already in this workspace')) rethrow;
    stdout.writeln('$email is already a member.');
  }
}
