# Verification record

**Build:** Takt, Nigeria demo and collaboration release
**Date:** 21 October 2026
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
3. An account owns an NGN workspace and sees the real seven-center /
   fourteen-job Nigerian sample, including the fictional customer mix.
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

Result: **success**. The release bundle is in `takt_flutter/build/web`; the
compiled `main.dart.js` was rebuilt after the Nigerian demo changes. The
development app served by Serverpod at `http://127.0.0.1:8082` returned HTTP
200. The separate static preview server on port 8090 was not left running.

## 4. Live API smoke checks

Against the running development server on `http://localhost:8080`:

| Check | Result |
| --- | --- |
| `shop.fetch` with the demo guest viewer key | HTTP 200; returned `Ajao Precision Works` with currency `NGN` |
| `workspace.access` with the demo guest viewer key | Resolved to role `viewer` |
| Viewer write through the demo guest key | Rejected: `This key is view-only. Ask the owner for editor access.` |
| `auth.login` with the demo owner account | HTTP 200; returned Tunde Ajao and the Ajao workspace |
| Missing required query parameter | HTTP 400 with a readable parameter error |
| Auth migration applied to development database | Tables, unique indexes, and migration registry entry present |

The live demo workspace is **Ajao Precision Works**, a fictional Lagos shop
seeded through the real workspace and demo endpoints. Its people and customers
are fictional; the credentials are in the README's “Try the demo” section.

The broader auth behavior was verified during the implementation against the
live development API before the final build:

- Registration creates an account and session.
- Login, `me`, workspace listing, and logout work.
- Workspace creation with sample data produces seven centers, fourteen jobs, and
  the NGN/Nigerian customer fixture used by the demo.
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
fixtures. They are not stitched mockups. The current set shows **Ajao Precision
Works**, NGN, Tunde Ajao as owner, Ngozi Eze as editor, Amina Bello as viewer,
and the fictional Nigerian customer mix.

## 5.1 Product film

All four cuts were re-rendered with the Nigerian workspace and a Nigerian
English voice:

| Check | Result |
| --- | --- |
| Landscape clean / captioned | 1920×1080, 1:35.8, H.264 + AAC mono, decode clean |
| Vertical clean / captioned | 1080×1920, 1:35.8, H.264 + AAC mono, decode clean |
| Voice | `en-NG-AbeoNeural` via Edge TTS, +12% rate |
| Captions | SRT tracks and burned-in overlays generated from the same copy |
| Audio level | mean −22.5 dB, peak −4.0 dB; no clipping detected |
| Scene boundaries | ~1.5 s of silence between scenes; voice and slide changes aligned |
| Narration coverage | 8 scenes, 1:35.7 runtime; transcript in `video/TRANSCRIPT.md` |

The film uses real Flutter golden renders against captured demo data, not a live
screen recording. The workspace, people, and customers are fictional. The
voiceover was checked for duration, levels, and transcript alignment but was not
auditioned by a human for Nigerian-English pronunciation.

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
- A human audition of the synthetic Nigerian-English voice, especially the
  pronunciation of Ajao, Lekki, Nnewi, and Aba.
- A real customer trial, Nigerian design partner, pilot, logo, testimonial,
  revenue, or market-size claim. The demo workspace is fictional.

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

# film
cd ../video
python make_takt_video.py --images-only
python make_vertical_video.py
python make_takt_video.py --tts-only   # needs Edge TTS network access
python assemble_formats.py
python make_srt.py
```

The development database must already have the auth migration applied (it does
in this workspace) and `config/passwords.yaml` must exist. Tests do not need
Docker. The film's TTS stage needs network access; the encode step uses the
bundled ffmpeg from `imageio-ffmpeg`.
