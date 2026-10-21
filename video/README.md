# Takt product film

A 90-second explainer for Takt, the finite-capacity scheduler that tells you
why you're late. Every screen in the film is a real capture of the running app.
The voice is synthesized with Microsoft Edge TTS (`en-US-AndrewNeural`).

| File | What it is |
|------|------------|
| `takt-demo.mp4` | 16:9 clean, 1920×1080, 1:29.9, AAC mono 48 kHz |
| `takt-demo-captioned.mp4` | 16:9 with burned-in captions, 1920×1080 |
| `takt-demo-vertical.mp4` | 9:16 with burned-in captions, 1080×1920 |
| `takt-demo-vertical-clean.mp4` | 9:16 clean, 1080×1920 |
| `takt-demo.srt` | Caption track for the 16:9 clean cut, 8 cues |
| `takt-demo-vertical.srt` | Same cue track for the vertical clean cut |
| `TRANSCRIPT.md` | Full narration + on-screen proof |
| `takt-demo-poster.png` | 16:9 title-card thumbnail |
| `takt-demo-vertical-poster.png` | 9:16 title-card thumbnail |

The vertical cut is a native 1080×1920 reflow, not a crop of the landscape
slides. The guest-key callout, metrics, screenshots, and caption rail all move
into the portrait safe area.

## Regenerate

```powershell
pip install edge-tts moviepy pillow

# Everything: landscape, vertical, captions, SRT, transcript
python make_takt_video.py

# Or run the stages explicitly
python make_takt_video.py --images-only   # 16:9 slides
python make_takt_video.py --tts-only      # voice (needs network)
python make_vertical_video.py             # 9:16 slides + caption overlays
python assemble_formats.py                # all four MP4 cuts
python make_srt.py                        # SRT + transcript
```

`make_takt_video.py` reuses `build/vo_*.mp3` if they already exist; delete a
voice file to regenerate it after changing the script.

## Notes

- Source screenshots: `../docs/assets/`
- Brand fonts: `../takt_flutter/assets/google_fonts/`
- Slides: `build/slide_01.png` … `build/slide_08.png`
- Vertical slides: `build/vslide_01.png` … `build/vslide_08.png`
- Voice tracks: `build/vo_01.mp3` … `build/vo_08.mp3`
- Caption overlays: `build/cap_land_*.png`, `build/cap_vert_*.png`
- Encoded segments: `build/segments_*/seg_*.mp4`
- The render is deterministic: the same slides, voice files, and ffmpeg
  settings produce the same cut.
