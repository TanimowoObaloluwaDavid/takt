import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takt_client/takt_client.dart';
import 'package:takt_flutter/screens/entry_screen.dart';
import 'package:takt_flutter/state/app_state.dart';
import 'package:takt_flutter/theme/takt_theme.dart';
import 'package:takt_flutter/widgets/common.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget entry(AppState state) {
    return MaterialApp(
      theme: taktTheme(),
      home: EntryScreen(state: state),
    );
  }

  Future<AppState> pumpEntry(
    WidgetTester tester, {
    Size size = const Size(1280, 900),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = AppState(Client('http://127.0.0.1:9/'));
    addTearDown(state.dispose);
    await tester.pumpWidget(entry(state));
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('entry screen states the product promise', (tester) async {
    await pumpEntry(tester);

    expect(find.textContaining('promising more'), findsOneWidget);
    expect(find.text('Create workspace'), findsOneWidget);
    expect(find.text('Load a realistic sample shop'), findsOneWidget);
    expect(find.text('Finite capacity'), findsOneWidget);
    expect(find.text('Causal verdicts'), findsOneWidget);
    expect(find.text('Capacity experiments'), findsOneWidget);
  });

  testWidgets('empty workspace name is caught before any network call', (
    tester,
  ) async {
    await pumpEntry(tester);

    await tester.tap(find.text('Create workspace'));
    await tester.pumpAndSettle();

    expect(find.text('Give the workspace a name.'), findsOneWidget);
  });

  testWidgets('open-with-key mode swaps the form', (tester) async {
    await pumpEntry(tester);

    final tab = find.ancestor(
      of: find.text('Open with key'),
      matching: find.byType(InkWell),
    );
    expect(tab, findsOneWidget);
    await tester.tap(tab);
    await tester.pumpAndSettle();

    expect(find.text('WORKSPACE KEY'), findsOneWidget);
    expect(find.text('Open workspace'), findsOneWidget);
    expect(find.text('Load a realistic sample shop'), findsNothing);
  });

  testWidgets('narrow phones lay out without overflow', (tester) async {
    await pumpEntry(tester, size: const Size(390, 844));

    expect(tester.takeException(), isNull);
    expect(find.textContaining('promising more'), findsOneWidget);
    expect(find.text('Create workspace'), findsOneWidget);
  });

  test('formatMinutes matches the server verdict language', () {
    expect(formatMinutes(0), '0m');
    expect(formatMinutes(45), '45m');
    expect(formatMinutes(60), '1h');
    expect(formatMinutes(130), '2h 10m');
    expect(formatMinutes(-90), '-1h 30m');
  });
}
