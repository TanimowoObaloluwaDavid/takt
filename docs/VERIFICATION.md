# Verification record

**Build:** Takt, auth and collaboration release
**Date:** 20 October 2026
**Environment:** Windows, Flutter 3.41.6, Dart 3.11.4, Serverpod 4.0.0-beta.4,
embedded PostgreSQL managed by Serverpod.

Only results actually produced in this environment are listed. “Not verified”
means not run, not a claim of failure.

## 1. Static checks

| Check | Command | Result |
| --- | --- | --- |
| Server analysis | `dart analyze --fatal-infos` in `takt_server` | **Clean** — no issues |
| Server formatting | `dart format --output=none --set-exit-if-changed lib test` | **Clean** |
| Flutter analysis | `flutter analyze --no-pub` in `takt_flutter` | **Clean** — no issues |
| Flutter formatting | `dart format --output=none --set-exit-if-changed lib test` | **Clean** |

## 2. Automated tests

### Server — 30 passed

Command:

```bash
cd takt_server
dart test --reporter expanded
```

Result: **30 / 30 passed**, including the original solver/flow suite and eight
new auth integration tests:

1. Registration, login, session identity, and logout.
2. Duplicate email and wrong password return readable `TaktException` errors.
3. An account owns a workspace and sees the real seven-center / fourteen-job
   sample.
4. Viewer keys read but cannot write; keys are redacted from other members;
   viewers cannot invite.
5. Role changes and removal take effect immediately on the same scoped key.
6. A legacy full-access key can be claimed by an account without losing access.
7. A routing cannot reference another shop's work center, and the rejected
   job is not persisted.
8. Password change revokes other sessions only; old password stops working and
   the new password works.

The tests run against Serverpod’s ephemeral embedded PostgreSQL and exercise the
real endpoints, not mocked services.

### Flutter — 17 passed

Command:

```bash
cd takt_flutter
flutter test --no-pub
```

Result: **17 / 17 passed**.

- 6 widget tests in `test/widget_test.dart` (auth front door, validation,
  create-account and key modes, phone layout, and shared verdict formatting).
- 11 fixture-driven tests in `test/golden_test.dart`:
  - board, schedule, jobs, setup at desktop width;
  - board at phone width;
  - viewer board with the read-only banner;
  - job search narrowing the visible list;
  - auth at desktop width;
  - auth at phone width;
  - workspace picker at desktop width;
  - offline banner with the last plan still readable and a Retry action.

Ten of these write visual goldens; the offline banner test asserts behavior
without producing an image.

Material Icons are loaded from the Flutter SDK in the golden harness so the
images render real glyphs rather than missing-font boxes.

## 3. Build

```bash
cd takt_flutter
flutter build web --release
```

Result: **success**. The final release bundle is served from `build/web` on
`http://127.0.0.1:8090` by a local static server. The served `index.html` was
last modified after the latest UI build, and the compiled `main.dart.js`
contains the auth, team, offline/retry, CSV, read-only, and picker UI strings.

## 4. Live API smoke checks

Against the running development server on `http://localhost:8080`:

| Check | Result |
| --- | --- |
| `shop.fetch` with the development guest workspace key | HTTP 200; returned the existing `Harbor Machine Co.` shop record |
| `auth.login` with the development test owner account | HTTP 200; returned `AuthResult` with a token and the owner’s workspace |
| Missing required query parameter | HTTP 400 with a readable parameter error |
| Auth migration applied to development database | Tables, unique indexes, and migration registry entry present |

The broader auth behavior was verified during the implementation against the
live development API before the final build:

- Registration creates an account and session.
- Login, `me`, workspace listing, and logout work.
- Workspace creation with sample data produces seven centers and fourteen jobs.
- Claiming an owner-key workspace attaches it to the account.
- Inviting an existing account as viewer creates a scoped key.
- Viewer writes are rejected with
  `This key is view-only. Ask the owner for editor access.`
- Promoting the viewer to editor allows writes with the same scoped key.
- Owner member listing shows keys; viewer member listing returns blank keys.
- A viewer cannot invite people.
- Removing a member makes the member key fail with
  `That workspace key does not exist.`
- Revoked sessions fail `me` with a readable expired-session error.

## 5. Visual artifacts

Generated goldens are under `takt_flutter/test/goldens/` and copied into
`docs/assets/` for the README:

- `auth-wide.png`, `auth-phone.png`
- `picker-wide.png`
- `board-wide.png`, `board-phone.png`, `board-viewer.png`
- `jobs-wide.png`
- `schedule-wide.png`
- `setup-wide.png`

The screenshots are rendered from the real Flutter widgets with captured demo
fixtures. They are not stitched mockups.

## 6. Not verified

The following were not run and must not be implied by this record:

- Serverpod Cloud deployment; it requires the user’s cloud login and project.
- Android, iOS, macOS, Windows, or Linux native builds.
- A scripted browser end-to-end click-through of the release bundle. The bundle
  was built and served, and the API flows were exercised directly; headless
  Chrome did not complete a screenshot of the Flutter canvas in this
  environment.
- Screen-reader testing (NVDA, VoiceOver, TalkBack) or a formal WCAG audit.
  Focus order, contrast, and semantic labels were considered in the UI but not
  certified.
- Load, concurrency, soak, or penetration testing.
- Email verification, password reset, email delivery, billing, backup/restore,
  key rotation, or ownership transfer.
- Cross-browser visual regression beyond the golden renders.
- A real customer trial or benchmark.

## 7. Reproduce

```bash
# server
cd takt_server
dart pub get
dart analyze --fatal-infos
dart test

# client
cd ../takt_flutter
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter build web --release
```

The development database must already have the auth migration applied (it does
in this workspace) and `config/passwords.yaml` must exist. Tests do not need
Docker.
