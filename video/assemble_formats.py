#!/usr/bin/env python3
"""Encode the landscape and vertical Takt films, with optional burned captions."""

from pathlib import Path
import subprocess

from moviepy import AudioFileClip

from assemble_video import FFMPEG, PADS
from make_takt_video import BUILD

ROOT = Path(__file__).resolve().parent
SEGMENTS = BUILD / "segments"

VARIANTS = [
    {
        "name": "16:9 clean",
        "slide": "slide",
        "caption": None,
        "out": "takt-demo.mp4",
        "dir": "segments_16x9",
    },
    {
        "name": "16:9 captions",
        "slide": "slide",
        "caption": "cap_land",
        "out": "takt-demo-captioned.mp4",
        "dir": "segments_16x9_cc",
    },
    {
        "name": "9:16 clean",
        "slide": "vslide",
        "caption": None,
        "out": "takt-demo-vertical-clean.mp4",
        "dir": "segments_9x16",
    },
    {
        "name": "9:16 captions",
        "slide": "vslide",
        "caption": "cap_vert",
        "out": "takt-demo-vertical.mp4",
        "dir": "segments_9x16_cc",
    },
]


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


def durations():
    result = []
    for i in range(1, 9):
        audio = AudioFileClip(str(BUILD / f"vo_{i:02d}.mp3"))
        result.append(float(audio.duration) + PADS[i - 1])
        audio.close()
    return result


def encode_variant(variant, scene_durations):
    segment_dir = SEGMENTS / variant["dir"]
    segment_dir.mkdir(parents=True, exist_ok=True)
    paths = []

    for i, duration in enumerate(scene_durations, start=1):
        slide = BUILD / f"{variant['slide']}_{i:02d}.png"
        mp3 = BUILD / f"vo_{i:02d}.mp3"
        out = segment_dir / f"seg_{i:02d}.mp4"
        print(f"  {variant['name']} / scene {i:02d}")

        args = [
            "-loop", "1",
            "-framerate", "30",
            "-i", str(slide),
        ]
        if variant["caption"]:
            args += [
                "-loop", "1",
                "-framerate", "30",
                "-i", str(BUILD / f"{variant['caption']}_{i:02d}.png"),
            ]
        args += ["-i", str(mp3)]

        if variant["caption"]:
            filter_graph = (
                f"[0:v][1:v]overlay=0:0:format=auto,format=yuv420p[v];"
                f"[2:a]apad=whole_dur={duration:.6f}[a]"
            )
            video_map = "[v]"
        else:
            filter_graph = f"[1:a]apad=whole_dur={duration:.6f}[a]"
            video_map = "0:v:0"

        args += [
            "-filter_complex", filter_graph,
            "-map", video_map,
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
        ]
        run(args)
        paths.append(out)

    concat_file = segment_dir / "concat.txt"
    concat_file.write_text(
        "\n".join(f"file '{p.as_posix()}'" for p in paths),
        encoding="utf-8",
    )
    final = ROOT / variant["out"]
    print(f"  concatenating -> {final.name}")
    run([
        "-f", "concat",
        "-safe", "0",
        "-i", str(concat_file),
        "-c", "copy",
        "-movflags", "+faststart",
        str(final),
    ])
    print(f"  wrote {final.name} ({final.stat().st_size / 1024 / 1024:.1f} MB, {sum(scene_durations):.1f}s)")


def main():
    scene_durations = durations()
    print("Durations:", ", ".join(f"{d:.2f}s" for d in scene_durations))
    for variant in VARIANTS:
        print(f"\nEncoding {variant['name']}...")
        encode_variant(variant, scene_durations)


if __name__ == "__main__":
    main()
