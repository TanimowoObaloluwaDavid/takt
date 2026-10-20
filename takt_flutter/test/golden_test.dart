import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takt_client/takt_client.dart';
import 'package:takt_flutter/screens/shell.dart';
import 'package:takt_flutter/state/app_state.dart';
import 'package:takt_flutter/theme/takt_theme.dart';

/// Renders the real screens from a captured demo workspace.
///
/// Regenerate fixtures with the dev server running:
///   dart run tool/dump_fixtures.dart ACCESS_KEY "Harbor Machine Co."
///
/// Render the goldens with:
///   flutter test --update-goldens test/golden_test.dart
late Shop _shop;
late List<WorkCenter> _centers;
late List<JobBundle> _jobs;
late ScheduleSnapshot _snapshot;
late List<ScheduleRun> _history;

Future<void> _loadFonts() async {
  Future<void> load(String family, String file) async {
    final loader = FontLoader(family)
      ..addFont(rootBundle.load('assets/google_fonts/$file'));
    await loader.load();
  }

  // GoogleFonts registers one family per variant, e.g. SpaceGrotesk_600.
  await load('SpaceGrotesk_regular', 'SpaceGrotesk-Regular.ttf');
  await load('SpaceGrotesk_500', 'SpaceGrotesk-Medium.ttf');
  await load('SpaceGrotesk_600', 'SpaceGrotesk-SemiBold.ttf');
  await load('SpaceGrotesk_700', 'SpaceGrotesk-Bold.ttf');
  await load('IBMPlexMono_regular', 'IBMPlexMono-Regular.ttf');
  await load('IBMPlexMono_500', 'IBMPlexMono-Medium.ttf');
  await load('IBMPlexMono_600', 'IBMPlexMono-SemiBold.ttf');

  // Also register the plain families for any style that falls back.
  await load('SpaceGrotesk', 'SpaceGrotesk-Regular.ttf');
  await load('IBMPlexMono', 'IBMPlexMono-Regular.ttf');
}

T _read<T>(String name, T Function(Object? json) parse) {
  final file = File('test/fixtures/$name.json');
  return parse(jsonDecode(file.readAsStringSync()));
}

AppState _state() {
  final state = AppState(Client('http://127.0.0.1:9/'))
    ..shop = _shop
    ..workCenters = _centers
    ..bundles = _jobs
    ..snapshot = _snapshot
    ..history = _history
    ..booting = false;
  return state;
}

Future<AppState> _pump(
  WidgetTester tester, {
  Size size = const Size(1440, 960),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final state = _state();
  addTearDown(state.dispose);

  await tester.pumpWidget(
    MaterialApp(
      theme: taktTheme(),
      home: AppShell(state: state),
    ),
  );
  // GoogleFonts registers a family per weight (SpaceGrotesk_600, ...). Wait for
  // those assets to load before the frame is captured.
  await GoogleFonts.pendingFonts();
  await tester.pumpAndSettle();
  return state;
}

Future<void> _golden(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(AppShell),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadFonts();

    _shop = _read(
      'shop',
      (json) => Shop.fromJson(json as Map<String, dynamic>),
    );
    _centers = _read(
      'work_centers',
      (json) => (json as List<dynamic>)
          .map((item) => WorkCenter.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    _jobs = _read(
      'jobs',
      (json) => (json as List<dynamic>)
          .map((item) => JobBundle.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    _snapshot = _read(
      'snapshot',
      (json) => ScheduleSnapshot.fromJson(json as Map<String, dynamic>),
    );
    _history = _read(
      'history',
      (json) => (json as List<dynamic>)
          .map((item) => ScheduleRun.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  });

  testWidgets('board at desktop width', (tester) async {
    await _pump(tester);
    expect(find.text('Harbor Machine Co.'), findsWidgets);
    await _golden(tester, 'board-wide');
  });

  testWidgets('schedule at desktop width', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.view_timeline_outlined));
    await tester.pumpAndSettle();
    await _golden(tester, 'schedule-wide');
  });

  testWidgets('jobs at desktop width', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.list_alt_outlined));
    await tester.pumpAndSettle();
    await _golden(tester, 'jobs-wide');
  });

  testWidgets('setup at desktop width', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await _golden(tester, 'setup-wide');
  });

  testWidgets('board at phone width', (tester) async {
    await _pump(tester, size: const Size(390, 844));
    expect(tester.takeException(), isNull);
    await _golden(tester, 'board-phone');
  });
}
