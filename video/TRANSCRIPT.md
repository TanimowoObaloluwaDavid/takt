# Takt — product film transcript

- **Runtime:** 1:35.7
- **Voice:** `en-NG-AbeoNeural` via Edge TTS, +12% rate
- **Demo workspace:** Ajao Precision Works, Lagos, Nigeria; NGN, WAT; Tunde Ajao (owner), Ngozi Eze (editor), Amina Bello (viewer)
- **Cuts:** `takt-demo.mp4` (16:9 clean) · `takt-demo-captioned.mp4` (16:9 captions) · `takt-demo-vertical.mp4` (9:16 captions) · `takt-demo-vertical-clean.mp4` (9:16 clean)
- **Captions:** `takt-demo.srt` / `takt-demo-vertical.srt`

| Time | Scene | Voiceover |
|------|-------|-----------|
| 00:00–00:09 | Title | Most shop tools show a red bar. A red bar is not a reason. At Ajao Precision Works in Lagos, Takt tells you why you're late, and what would fix it. |
| 00:10–00:19 | Problem | High-mix shops in Lagos don't lose dates because one operation is slow. Jobs wait behind a constrained work center, and that queue is where the promise disappears. |
| 00:19–00:36 | Diagnosis | Takt opens on the diagnosis board. Lekki Fluid's adapter plate, J-1051, is 26h 40m late. Every minute traces to queue time at CNC-02, running at 91% load. Named. Measured. Causal. |
| 00:37–00:49 | What-if | Before Tunde buys another machine, test the fix. Add one machine at CNC-02. Same seed, one capacity change. The late job clears, and all 1,600 lost minutes come back. |
| 00:50–01:01 | Jobs | The floor is real, too. Search the job book, filter by status, copy the rows as CSV. No fake export buttons. No dead controls. |
| 01:01–01:10 | Access | Accounts are optional. A guest key opens the shop instantly. Sign in, and every workspace stays separate, with its own people and data. |
| 01:10–01:24 | Authority | Authority is enforced on the Serverpod API, not the interface. Tunde owns. Ngozi edits. Amina reads, and the server rejects every write. Hiding a button is UX. Rejecting the write is security. |
| 01:25–01:34 | Outro | Takt is Flutter and Serverpod, with real auth, real Postgres, 30 server tests, and 17 Flutter tests. The scheduler that tells you why you're late. |

## On-screen proof

- Diagnosis board: J-1051 is late 26h 40m; 100% of the delay is queue time at CNC-02 / CNC Mill 2, running at 91% load.
- What-if: +1 machine at CNC-02; late jobs 1 → 0; lost time 26h 40m → 0; +1,600 minutes recovered.
- Jobs: real search, status filters, and Copy CSV.
- Access: guest workspace key, account sign-in, Argon2id passwords, 30-day hashed sessions.
- Authority: owner / editor / viewer roles enforced by the Serverpod API; viewer writes rejected with HTTP 400.
- Stack: Flutter, Serverpod, PostgreSQL; 30 server tests and 17 Flutter tests.
- Local context: the demo shop is Ajao Precision Works in Lagos, with NGN and Nigerian customer names; the solver and roles are unchanged.

The narration is synthesized. All product screens are rendered from the real Flutter app against captured demo data; the workspace, people, and customers are fictional.
