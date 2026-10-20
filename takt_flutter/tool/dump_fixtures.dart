import 'dart:convert';
import 'dart:io';

import 'package:takt_client/takt_client.dart';

/// Dumps a real workspace into JSON fixtures for the golden-screen tests.
///
/// Usage, with the dev server running:
///
///   dart run tool/dump_fixtures.dart ACCESS_KEY ["Shop name"]
///
/// The access key in the fixture is replaced with a clearly fake value so a
/// live workspace credential never lands in source control.
Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln(
      'usage: dart run tool/dump_fixtures.dart <accessKey> [shopName]',
    );
    exitCode = 64;
    return;
  }

  final client = Client('http://127.0.0.1:8080/');
  var accessKey = args.first;

  if (args.length > 1) {
    final renamed = await client.shop.rename(accessKey, args[1]);
    accessKey = renamed.accessKey;
    stdout.writeln('renamed workspace to "${renamed.name}"');
  }

  final shop = await client.shop.fetch(accessKey);
  final workCenters = await client.workCenter.list(accessKey);
  final jobs = await client.job.list(accessKey);
  final snapshot = await client.schedule.solve(accessKey, seed: 90210);
  final history = await client.schedule.history(accessKey);

  final directory = Directory('test/fixtures')..createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');

  void write(String name, Object value) {
    File('${directory.path}/$name.json').writeAsStringSync(
      encoder.convert(value),
    );
  }

  write('shop', shop.copyWith(accessKey: 'DEMO0-00000-00000-00000').toJson());
  write('work_centers', workCenters.map((center) => center.toJson()).toList());
  write('jobs', jobs.map((bundle) => bundle.toJson()).toList());
  write('snapshot', snapshot.toJson());
  write('history', history.map((run) => run.toJson()).toList());

  stdout.writeln(
    'wrote test/fixtures: ${workCenters.length} centers, '
    '${jobs.length} jobs, ${history.length} runs',
  );
}
