# Takt — product film transcript

**Runtime:** 1:29.9  
**Voice:** `en-US-AndrewNeural` via Edge TTS  
**Cuts:** `takt-demo.mp4` (16:9 clean) · `takt-demo-captioned.mp4` (16:9 captions) · `takt-demo-vertical.mp4` (9:16 captions) · `takt-demo-vertical-clean.mp4` (9:16 clean)  
**Captions:** `takt-demo.srt` / `takt-demo-vertical.srt`

| Time | Scene | Voiceover |
|------|-------|-----------|
| 00:00–00:06 | Title | Most shop tools show a red bar. A red bar is not a reason. Takt tells you why you're late, and what would fix it. |
| 00:07–00:16 | Problem | High-mix shops don't lose dates because one operation is slow. Jobs wait behind a constrained work center, and that queue is where the promise disappears. |
| 00:17–00:32 | Diagnosis | Takt opens on the diagnosis board. Job J-1051 is 26h 40m late. Every minute traces to queue time at CNC-02, running at 91% load. Named. Measured. Causal. |
| 00:32–00:44 | What-if | Test the fix before you spend. Add one machine at CNC-02. Same seed, one capacity change. The late job clears, and all 1,600 lost minutes come back. |
| 00:44–00:54 | Jobs | The floor is real, too. Search the job book, filter by status, copy the rows as CSV. No fake export buttons. No dead controls. |
| 00:54–01:03 | Access | Accounts are optional. A guest key opens the shop instantly. Sign in, and every workspace stays separate, with its own people and data. |
| 01:04–01:18 | Authority | Authority is enforced on the Serverpod API, not the interface. Owner, editor, viewer. A viewer reads the board; the server rejects every write. Hiding a button is UX. Rejecting the write is security. |
| 01:18–01:28 | Outro | Takt is Flutter and Serverpod, with real auth, real Postgres, 30 server tests, and 17 Flutter tests. The scheduler that tells you why you're late. |

## On-screen proof

- Diagnosis board: J-1051 is late 26h 40m; 100% of the delay is queue time at CNC-02 / CNC Mill 2, running at 91% load.
- What-if: +1 machine at CNC-02; late jobs 1 → 0; lost time 26h 40m → 0; +1,600 minutes recovered.
- Jobs: real search, status filters, and Copy CSV.
- Access: guest workspace key, account sign-in, Argon2id passwords, 30-day hashed sessions.
- Authority: owner / editor / viewer roles enforced by the Serverpod API; viewer writes rejected with HTTP 400.
- Stack: Flutter, Serverpod, PostgreSQL; 30 server tests and 17 Flutter tests.

The narration is synthesized. All product screenshots are real captures of the running Takt app.
