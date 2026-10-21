#!/usr/bin/env python3
"""Fast, reliable assembly of the Takt film with ffmpeg.

The previous MoviePy compositor was spending minutes per frame on full-frame
crossfades. Each scene is a still image, so we encode eight short segments
directly and concatenate them losslessly. Clean cuts, same 1080p output.
"""

from pathlib import Path
import subprocess
import sys

import imageio_ffmpeg
from moviepy import AudioFileClip

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / "build"
SEGMENTS = BUILD / "segments"
SEGMENTS.mkdir(parents=True, exist_ok=True)

PADS = [0.8, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.2]
FFMPEG = imageio_ffmpeg.get_ffmpeg_exe()


def run(args):
    process = subprocess.run(
        [FFMPEG, "-hide_banner", "-loglevel", "error", "-y", *args],
        capture_output=True,
        text=True,
    )
    if process.returncode != 0:
        print(process.stdout)
        print(process.stderr)
        raise RuntimeError(f"ffmpeg failed with code {process.returncode}")


def main():
    durations = []
    for i in range(1, 9):
        audio = AudioFileClip(str(BUILD / f"vo_{i:02d}.mp3"))
        duration = float(audio.duration) + PADS[i - 1]
        durations.append(duration)
        audio.close()
        print(f"scene {i:02d}: {duration:5.2f}s")

    segment_paths = []
    for i, duration in enumerate(durations, start=1):
        png = BUILD / f"slide_{i:02d}.png"
        mp3 = BUILD / f"vo_{i:02d}.mp3"
        out = SEGMENTS / f"seg_{i:02d}.mp4"
        print(f"encoding segment {i:02d} -> {out.name}")
        run([
            "-loop", "1",
            "-framerate", "30",
            "-i", str(png),
            "-i", str(mp3),
            "-filter_complex", f"[1:a]apad=whole_dur={duration:.6f}[a]",
            "-map", "0:v:0",
            "-map", "[a]",
            "-t", f"{duration:.6f}",
            "-r", "30",
            "-c:v", "libx264",
            "-preset", "veryfast",
            "-crf", "18",
            "-tune", "stillimage",
            "-pix_fmt", "yuv420p",
            "-c:a", "aac",
            "-b:a", "192k",
            "-ar", "48000",
            "-movflags", "+faststart",
            str(out),
        ])
        segment_paths.append(out)

    concat_file = BUILD / "concat.txt"
    concat_file.write_text(
        "\n".join(f"file '{p.as_posix()}'" for p in segment_paths),
        encoding="utf-8",
    )

    out = ROOT / "takt-demo.mp4"
    print("concatenating segments...")
    run([
        "-f", "concat",
        "-safe", "0",
        "-i", str(concat_file),
        "-c", "copy",
        "-movflags", "+faststart",
        str(out),
    ])

    print(f"wrote {out} ({out.stat().st_size / 1024 / 1024:.1f} MB)")
    print(f"runtime {sum(durations):.1f}s")


if __name__ == "__main__":
    main()
