import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:takt_client/takt_client.dart';

import 'screens/auth_screen.dart';
import 'screens/shell.dart';
import 'screens/workspace_picker_screen.dart';
import 'state/app_state.dart';
import 'theme/takt_theme.dart';
import 'widgets/common.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The typefaces ship with the app; never wait on fonts.googleapis.com.
  GoogleFonts.config.allowRuntimeFetching = false;

  final serverUrl = await getServerUrl();
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const TaktApp());
}

class TaktApp extends StatefulWidget {
  const TaktApp({super.key});

  @override
  State<TaktApp> createState() => _TaktAppState();
}

class _TaktAppState extends State<TaktApp> {
  late final AppState _state = AppState(client)..boot();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takt',
      debugShowCheckedModeBanner: false,
      theme: taktTheme(),
      home: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          if (_state.booting) return const _BootScreen();
          if (_state.hasWorkspace) return AppShell(state: _state);
          if (_state.isSignedIn) {
            return WorkspacePickerScreen(state: _state);
          }
          return AuthScreen(state: _state);
        },
      ),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Wordmark(size: 34),
            const SizedBox(height: 20),
            SizedBox(
              width: 132,
              child: LinearProgressIndicator(
                minHeight: 1.5,
                color: TaktColors.ink,
                backgroundColor: TaktColors.line,
              ),
            ),
            const SizedBox(height: 12),
            Text('CHECKING ACCESS', style: TaktType.label),
          ],
        ),
      ),
    );
  }
}
