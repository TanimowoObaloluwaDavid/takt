# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.

## The app

**Takt** is an explainable finite-capacity scheduler for high-mix, low-volume
job shops: “The scheduler that tells you why you’re late.”

- `takt_flutter/` — Flutter client. Auth front door, workspace picker, shell,
  diagnosis board, Gantt schedule, searchable jobs, setup/people.
- `takt_server/` — Serverpod API. Pure solver/diagnosis in `lib/src/solver/`,
  persistence in `lib/src/services/`, auth in `lib/src/auth/`, scoped-key role
  enforcement in `lib/src/access/`.
- `takt_client/` — generated protocol client. Never edit by hand.

### Auth and authority

- Email/password accounts with Argon2id; sessions are 30-day hashed bearer
  tokens. Workspace keys are separate scoped credentials for data calls.
- Roles are `owner`, `editor`, `viewer`, enforced server-side in
  `requireShop(..., write: true)`.
- The shop's original `Shop.accessKey` is the owner's full-access key. It
  bypasses roles. Member keys live in `WorkspaceMember.accessKey` and carry
  their role. Never return the owner key to a member: use `visibleShop`.
- Accounts are optional for guest viewing. Accounts are required to manage
  workspaces and people.
- Table migration for `TaktUser`, `UserSession`, and `WorkspaceMember`:
  `migrations/20261020101119388/` (already applied to development).
- User-facing validation/permission/auth failures are serialized
  `TaktException`s (HTTP 400), not generic 500s.

### Scheduler

Jobs are operation chains on work centers with parallel identical machines and
flat changeovers. The solver runs EDD/priority/SPT/slack list-scheduling rules,
then seeded simulated annealing over dispatch order. The same seed and inputs
produce an identical schedule. Diagnosis attributes late minutes to queue time
at the binding work center; what-if reuses the latest seed and changes only
extra machines.

### Verification

```bash
cd takt_server && dart analyze --fatal-infos && dart format --output=none --set-exit-if-changed lib test && dart test
cd ../takt_flutter && flutter analyze --no-pub && dart format --output=none --set-exit-if-changed lib test && flutter test --no-pub
flutter build web --release
```

Goldens are fixture-driven in `takt_flutter/test/golden_test.dart`. Load
Material Icons from the Flutter SDK in the harness; otherwise icons render as
missing-glyph boxes. See `docs/VERIFICATION.md` for the current record.

---

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `takt_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `takt_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

The app opens on the auth screen. Guest workspace keys still open a shop
directly; signed-in users get the workspace picker, switcher, People panel, and
role-aware controls.
