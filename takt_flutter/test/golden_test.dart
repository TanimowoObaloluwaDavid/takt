import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takt_client/takt_client.dart';
import 'package:takt_flutter/screens/auth_screen.dart';
import 'package:takt_flutter/screens/shell.dart';
import 'package:takt_flutter/screens/workspace_picker_screen.dart';
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

/// Find the Flutter SDK without relying on a machine-specific path.
String _flutterRoot() {
  final fromEnv = Platform.environment['FLUTTER_ROOT'];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;

  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 6; i++) {
    final icon = File(
      '${dir.path}/bin/cache/artifacts/material_fonts/'
      'MaterialIcons-Regular.otf',
    );
    if (icon.existsSync()) return dir.path;
    dir = dir.parent;
  }
  return r'C:\flutter';
}

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

  // Material Icons live in the SDK, not the app bundle. Without this the
  // golden images render every icon as a missing-glyph box.
  final root = _flutterRoot();
  final iconFile = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (iconFile.existsSync()) {
    final bytes = await iconFile.readAsBytes();
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }
}

T _read<T>(String name, T Function(Object? json) parse) {
  final file = File('test/fixtures/$name.json');
  return parse(jsonDecode(file.readAsStringSync()));
}

AppState _state() {
  final shopId = _shop.id ?? 6;
  final state = AppState(Client('http://127.0.0.1:9/'))
    ..shop = _shop
    ..workCenters = _centers
    ..bundles = _jobs
    ..snapshot = _snapshot
    ..history = _history
    ..booting = false
    ..user = AuthUser(
      id: 1,
      email: 'alex@harbor.test',
      displayName: 'Alex Chen',
      createdAt: DateTime(2026, 10, 1),
    )
    ..sessionToken = 'fixture-session-token'
    ..workspaces = [
      WorkspaceAccess(
        shopId: shopId,
        name: _shop.name,
        currency: _shop.currency,
        role: 'owner',
        accessKey: _shop.accessKey,
        createdAt: _shop.createdAt,
      ),
    ]
    ..members = [
      MemberInfo(
        userId: 1,
        email: 'alex@harbor.test',
        displayName: 'Alex Chen',
        role: 'owner',
        accessKey: _shop.accessKey,
        createdAt: DateTime(2026, 10, 1),
      ),
      MemberInfo(
        userId: 2,
        email: 'sam@harbor.test',
        displayName: 'Sam Rivera',
        role: 'editor',
        accessKey: '4PCCF-QF6QC-3H82K-VGY8R',
        createdAt: DateTime(2026, 10, 2),
      ),
      MemberInfo(
        userId: 3,
        email: 'mira@harbor.test',
        displayName: 'Mira Patel',
        role: 'viewer',
        accessKey: '2VJ8M-7QK4D-9WX3A-5HNTB',
        createdAt: DateTime(2026, 10, 3),
      ),
    ];
  return state;
}

Future<AppState> _pump(
  WidgetTester tester, {
  Size size = const Size(1440, 960),
  String role = 'owner',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final state = _state()..role = role;
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
  await _goldenOf(tester, find.byType(AppShell), name);
}

Future<void> _goldenOf(
  WidgetTester tester,
  Finder finder,
  String name,
) async {
  await expectLater(finder, matchesGoldenFile('goldens/$name.png'));
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(1440, 960),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(theme: taktTheme(), home: child));
  await GoogleFonts.pendingFonts();
  await tester.pumpAndSettle();
}

AppState _accountState() {
  final state = AppState(Client('http://127.0.0.1:9/'))
    ..booting = false
    ..user = AuthUser(
      id: 1,
      email: 'alex@harbor.test',
      displayName: 'Alex Chen',
      createdAt: DateTime(2026, 10, 1),
    )
    ..sessionToken = 'fixture-session-token'
    ..workspaces = [
      WorkspaceAccess(
        shopId: _shop.id ?? 6,
        name: _shop.name,
        currency: _shop.currency,
        role: 'owner',
        accessKey: _shop.accessKey,
        createdAt: _shop.createdAt,
      ),
      WorkspaceAccess(
        shopId: 12,
        name: 'Calder Precision',
        currency: 'USD',
        role: 'viewer',
        accessKey: '8KQ2M-4WX7P-6HNTB-3VJDA',
        createdAt: DateTime(2026, 9, 18),
      ),
    ];
  return state;
}

/// Allows sub-pixel rasterization differences between Windows runners while
/// still rejecting meaningful visual changes.
class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testFile, {required this.tolerance});

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    final passed = result.passed || result.diffPercent <= tolerance;
    if (passed) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

void main() {
  goldenFileComparator = _TolerantGoldenFileComparator(
    Uri.parse('test/golden_test.dart'),
    tolerance: 0.001,
  );

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

  testWidgets('viewer board is visibly read-only', (tester) async {
    await _pump(tester, role: 'viewer');
    expect(find.textContaining('View-only access'), findsOneWidget);
    await _golden(tester, 'board-viewer');
  });

  testWidgets('job search narrows the visible list', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.list_alt_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Meridian');
    await tester.pumpAndSettle();
    expect(find.text('J-1051'), findsOneWidget);
    expect(find.text('J-1047'), findsNothing);
  });

  testWidgets('auth at desktop width', (tester) async {
    final state = AppState(Client('http://127.0.0.1:9/'));
    addTearDown(state.dispose);
    await _pumpScreen(tester, AuthScreen(state: state));
    expect(tester.takeException(), isNull);
    await _goldenOf(tester, find.byType(AuthScreen), 'auth-wide');
  });

  testWidgets('auth at phone width', (tester) async {
    final state = AppState(Client('http://127.0.0.1:9/'));
    addTearDown(state.dispose);
    await _pumpScreen(
      tester,
      AuthScreen(state: state),
      size: const Size(390, 844),
    );
    expect(tester.takeException(), isNull);
    await _goldenOf(tester, find.byType(AuthScreen), 'auth-phone');
  });

  testWidgets('workspace picker at desktop width', (tester) async {
    final state = _accountState();
    addTearDown(state.dispose);
    await _pumpScreen(tester, WorkspacePickerScreen(state: state));
    expect(tester.takeException(), isNull);
    expect(find.text('Calder Precision'), findsOneWidget);
    await _goldenOf(tester, find.byType(WorkspacePickerScreen), 'picker-wide');
  });

  testWidgets('offline banner keeps the plan readable and offers retry', (
    tester,
  ) async {
    final state = await _pump(tester);
    state.offline = true;
    await tester.pumpWidget(
      MaterialApp(
        theme: taktTheme(),
        home: AppShell(state: state),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('No network connection'), findsOneWidget);
    expect(find.textContaining('last loaded plan'), findsOneWidget);
    expect(find.text('RETRY'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
