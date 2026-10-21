#!/usr/bin/env python3
"""Generate the SRT caption track and transcript for the Takt film."""

from pathlib import Path
import textwrap

from moviepy import AudioFileClip

from captions import CAPTIONS
from make_takt_video import SCENES, BUILD, ROOT

PADS = [0.8, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.2]


def stamp(seconds: float) -> str:
    milliseconds = int(round(seconds * 1000))
    hours, milliseconds = divmod(milliseconds, 3_600_000)
    minutes, milliseconds = divmod(milliseconds, 60_000)
    secs, milliseconds = divmod(milliseconds, 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{milliseconds:03d}"


def main():
    starts = []
    cursor = 0.0
    for i, scene in enumerate(SCENES):
        starts.append(cursor)
        audio = AudioFileClip(str(BUILD / f"vo_{scene['id']}.mp3"))
        cursor += float(audio.duration) + PADS[i]
        audio.close()

    minutes = int(cursor // 60)
    seconds = cursor - minutes * 60
    runtime = f"{minutes}:{seconds:04.1f}"

    blocks = []
    rows = []
    for i, (scene, start) in enumerate(zip(SCENES, starts), start=1):
        audio = AudioFileClip(str(BUILD / f"vo_{scene['id']}.mp3"))
        end = min(start + float(audio.duration) + 0.12, starts[i] - 0.08 if i < len(starts) else 1e9)
        audio.close()
        caption = CAPTIONS[i - 1]
        lines = textwrap.wrap(caption, width=68)
        text = "\n".join(lines)
        blocks.append(f"{i}\n{stamp(start)} --> {stamp(end)}\n{text}\n")
        rows.append(
            f"| {stamp(start)[3:8]}–{stamp(end)[3:8]} | {scene['name']} | {caption} |"
        )

    srt = "\n".join(blocks)
    (ROOT / "takt-demo.srt").write_text(srt, encoding="utf-8")
    (ROOT / "takt-demo-vertical.srt").write_text(srt, encoding="utf-8")

    transcript = [
        "# Takt — product film transcript",
        "",
        f"- **Runtime:** {runtime}",
        "- **Voice:** `en-NG-AbeoNeural` via Edge TTS, +12% rate",
        "- **Demo workspace:** Ajao Precision Works, Lagos, Nigeria; NGN, WAT; "
        "Tunde Ajao (owner), Ngozi Eze (editor), Amina Bello (viewer)",
        "- **Cuts:** `takt-demo.mp4` (16:9 clean) · "
        "`takt-demo-captioned.mp4` (16:9 captions) · "
        "`takt-demo-vertical.mp4` (9:16 captions) · "
        "`takt-demo-vertical-clean.mp4` (9:16 clean)",
        "- **Captions:** `takt-demo.srt` / `takt-demo-vertical.srt`",
        "",
        "| Time | Scene | Voiceover |",
        "|------|-------|-----------|",
        *rows,
        "",
        "## On-screen proof",
        "",
        "- Diagnosis board: J-1051 is late 26h 40m; 100% of the delay is queue time at CNC-02 / CNC Mill 2, running at 91% load.",
        "- What-if: +1 machine at CNC-02; late jobs 1 → 0; lost time 26h 40m → 0; +1,600 minutes recovered.",
        "- Jobs: real search, status filters, and Copy CSV.",
        "- Access: guest workspace key, account sign-in, Argon2id passwords, 30-day hashed sessions.",
        "- Authority: owner / editor / viewer roles enforced by the Serverpod API; viewer writes rejected with HTTP 400.",
        "- Stack: Flutter, Serverpod, PostgreSQL; 30 server tests and 17 Flutter tests.",
        "- Local context: the demo shop is Ajao Precision Works in Lagos, with NGN and Nigerian customer names; the solver and roles are unchanged.",
        "",
        "The narration is synthesized. All product screens are rendered from the real Flutter app against captured demo data; the workspace, people, and customers are fictional.",
        "",
    ]
    (ROOT / "TRANSCRIPT.md").write_text("\n".join(transcript), encoding="utf-8")
    print("wrote takt-demo.srt, takt-demo-vertical.srt, and TRANSCRIPT.md")


if __name__ == "__main__":
    main()
