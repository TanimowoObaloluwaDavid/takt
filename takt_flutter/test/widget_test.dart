import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takt_client/takt_client.dart';
import 'package:takt_flutter/screens/auth_screen.dart';
import 'package:takt_flutter/state/app_state.dart';
import 'package:takt_flutter/theme/takt_theme.dart';
import 'package:takt_flutter/widgets/common.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<AppState> pumpAuth(
    WidgetTester tester, {
    Size size = const Size(1280, 900),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = AppState(Client('http://127.0.0.1:9/'));
    addTearDown(state.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: taktTheme(),
        home: AuthScreen(state: state),
      ),
    );
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('auth screen states the product promise', (tester) async {
    await pumpAuth(tester);

    expect(
      find.text('The schedule is a claim.\nTakt shows the evidence.'),
      findsOneWidget,
    );
    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Open with a workspace key'), findsOneWidget);
  });

  testWidgets('empty email is caught before any network call', (tester) async {
    await pumpAuth(tester);

    await tester.tap(find.text('Sign in').last);
    await tester.pumpAndSettle();

    expect(find.text('Enter the email you signed up with.'), findsOneWidget);
  });

  testWidgets('create-account mode reveals the confirmation field', (
    tester,
  ) async {
    await pumpAuth(tester);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR NAME'), findsOneWidget);
    expect(find.text('CONFIRM PASSWORD'), findsOneWidget);
    expect(find.text('Create account'), findsWidgets);
  });

  testWidgets('open-with-key mode swaps the form', (tester) async {
    await pumpAuth(tester);

    await tester.tap(find.text('Open with a workspace key'));
    await tester.pumpAndSettle();

    expect(find.text('WORKSPACE KEY'), findsOneWidget);
    expect(find.text('Open workspace'), findsOneWidget);
    expect(find.text('CONFIRM PASSWORD'), findsNothing);
  });

  testWidgets('narrow phones lay out without overflow', (tester) async {
    await pumpAuth(tester, size: const Size(390, 844));

    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Takt shows the evidence'),
      findsOneWidget,
    );
    expect(find.text('Sign in'), findsWidgets);
  });

  test('formatMinutes matches the server verdict language', () {
    expect(formatMinutes(0), '0m');
    expect(formatMinutes(45), '45m');
    expect(formatMinutes(60), '1h');
    expect(formatMinutes(130), '2h 10m');
    expect(formatMinutes(-90), '-1h 30m');
  });
}
