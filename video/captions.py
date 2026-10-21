"""Readable caption copy shared by the SRT and the burned-in cuts.

The narration strings in make_takt_video.py use phonetic spellings for TTS
("J ten fifty-one", "CNC zero two"). Captions use the real notation instead.
"""

CAPTIONS = [
    "Most shop tools show a red bar. A red bar is not a reason. Takt tells you why you're late, and what would fix it.",
    "High-mix shops don't lose dates because one operation is slow. Jobs wait behind a constrained work center, and that queue is where the promise disappears.",
    "Takt opens on the diagnosis board. Job J-1051 is 26h 40m late. Every minute traces to queue time at CNC-02, running at 91% load. Named. Measured. Causal.",
    "Test the fix before you spend. Add one machine at CNC-02. Same seed, one capacity change. The late job clears, and all 1,600 lost minutes come back.",
    "The floor is real, too. Search the job book, filter by status, copy the rows as CSV. No fake export buttons. No dead controls.",
    "Accounts are optional. A guest key opens the shop instantly. Sign in, and every workspace stays separate, with its own people and data.",
    "Authority is enforced on the Serverpod API, not the interface. Owner, editor, viewer. A viewer reads the board; the server rejects every write. Hiding a button is UX. Rejecting the write is security.",
    "Takt is Flutter and Serverpod, with real auth, real Postgres, 30 server tests, and 17 Flutter tests. The scheduler that tells you why you're late.",
]
