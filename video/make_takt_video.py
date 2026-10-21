#!/usr/bin/env python3
"""Build the Takt product film from real app screenshots + Edge neural TTS.

Outputs:
  build/slide_01.png ... slide_08.png
  build/vo_01.mp3 ... vo_08.mp3
  takt-demo.mp4

Run:
  python make_takt_video.py --images-only
  python make_takt_video.py
"""

from __future__ import annotations

import argparse
import asyncio
import math
import os
import subprocess
import sys
from pathlib import Path

import edge_tts
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent
ASSETS = PROJECT / "docs" / "assets"
FONTS = PROJECT / "takt_flutter" / "assets" / "google_fonts"
BUILD = ROOT / "build"
BUILD.mkdir(parents=True, exist_ok=True)

W, H = 1920, 1080
PAPER = (242, 240, 233, 255)
CARD = (250, 248, 242, 255)
INK = (31, 30, 28, 255)
INK_SOFT = (103, 99, 93, 255)
INK_FAINT = (143, 138, 130, 255)
RULE = (216, 211, 200, 255)
GRID = (235, 231, 222, 255)
TEAL = (15, 107, 98, 255)
TEAL_BRIGHT = (35, 156, 142, 255)
OXIDE = (185, 74, 56, 255)
AMBER = (190, 132, 36, 255)
WHITE = (255, 255, 255, 255)
DARK = (30, 29, 27, 255)
DARK_CARD = (40, 38, 35, 255)
DARK_RULE = (64, 60, 54, 255)
DARK_GRID = (38, 36, 33, 255)
DARK_TEXT = (244, 241, 232, 255)
DARK_MUTED = (166, 160, 150, 255)

VOICE = "en-NG-AbeoNeural"
RATE = "+12%"
PITCH = "-1Hz"


# --------------------------------------------------------------------------
# Fonts and text helpers
# --------------------------------------------------------------------------

FONT_FILES = {
    "bold": "SpaceGrotesk-Bold.ttf",
    "semi": "SpaceGrotesk-SemiBold.ttf",
    "medium": "SpaceGrotesk-Medium.ttf",
    "regular": "SpaceGrotesk-Regular.ttf",
    "mono": "IBMPlexMono-Regular.ttf",
    "mono_semi": "IBMPlexMono-SemiBold.ttf",
}


def font(kind: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONTS / FONT_FILES[kind]), size)


def ink_top(draw: ImageDraw.ImageDraw, xy, text, fnt, fill):
    """Draw text aligned by the top of its actual ink, not font ascent."""
    bbox = fnt.getbbox(text)
    draw.text((xy[0], xy[1] - bbox[1]), text, font=fnt, fill=fill)


def text_width(draw: ImageDraw.ImageDraw, text: str, fnt) -> float:
    return draw.textlength(text, font=fnt)


def tracked_width(draw, text: str, fnt, tracking: float) -> float:
    if not text:
        return 0
    return sum(draw.textlength(ch, font=fnt) for ch in text) + tracking * (len(text) - 1)


def draw_tracked(draw, xy, text, fnt, fill, tracking=2.0):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += draw.textlength(ch, font=fnt) + tracking


def draw_tracked_right(draw, xy, text, fnt, fill, tracking=2.0):
    x, y = xy
    draw_tracked(draw, (x - tracked_width(draw, text, fnt, tracking), y), text, fnt, fill, tracking)


def wrap_lines(draw, text: str, fnt, max_width: float):
    out = []
    for paragraph in text.split("\n"):
        words = paragraph.split()
        if not words:
            out.append("")
            continue
        line = words[0]
        for word in words[1:]:
            trial = line + " " + word
            if draw.textlength(trial, font=fnt) <= max_width:
                line = trial
            else:
                out.append(line)
                line = word
        out.append(line)
    return out


def draw_paragraph(draw, xy, text, fnt, fill, max_width, line_height=None):
    x, y = xy
    if line_height is None:
        line_height = int(fnt.size * 1.45)
    for line in wrap_lines(draw, text, fnt, max_width):
        draw.text((x, y), line, font=fnt, fill=fill)
        y += line_height
    return y


# --------------------------------------------------------------------------
# Chrome
# --------------------------------------------------------------------------


def draw_mark(draw, x, y, scale=1.0, dark=False):
    bar = PAPER if dark else INK
    accent = OXIDE if dark else OXIDE
    w = 26 * scale
    h = 4.5 * scale
    for i in range(3):
        draw.rectangle([x, y + i * 9 * scale, x + w, y + i * 9 * scale + h], fill=bar)
    draw.rectangle([x + w + 3 * scale, y + 9 * scale, x + w + 13 * scale, y + 22.5 * scale], fill=accent)


def draw_chrome(img, draw, idx: int, dark=False, top_right="FLUTTER × SERVERPOD"):
    fg = DARK_TEXT if dark else INK
    muted = DARK_MUTED if dark else INK_FAINT
    rule = DARK_RULE if dark else RULE

    draw_mark(draw, 100, 57, 1.0, dark)
    draw_tracked(draw, (148, 54), "TAKT", font("bold", 28), fg, 3.2)
    draw_tracked_right(draw, (1820, 65), top_right, font("mono", 15), muted, 1.5)
    draw.line([(100, 112), (1820, 112)], fill=rule, width=1)

    # footer index + progress ticks
    draw_tracked(draw, (100, 1020), "TAKT / FINITE-CAPACITY SCHEDULER", font("mono", 14), muted, 1.0)
    draw_tracked_right(draw, (1820, 1020), f"{idx:02d} / 08", font("mono", 15), fg, 1.6)

    gap = 8
    total_w = 1820 - 100
    seg_w = (total_w - gap * 7) / 8
    for i in range(8):
        x = 100 + i * (seg_w + gap)
        color = fg if i == idx - 1 else (TEAL if i < idx - 1 else (DARK_RULE if dark else RULE))
        draw.rectangle([x, 1048, x + seg_w, 1051], fill=color)


def paper_bg() -> Image.Image:
    img = Image.new("RGBA", (W, H), PAPER)
    d = ImageDraw.Draw(img)
    for x in range(0, W, 80):
        d.line([(x, 0), (x, H)], fill=GRID, width=1)
    for y in range(0, H, 80):
        d.line([(0, y), (W, y)], fill=GRID, width=1)
    # drafting corner ticks
    for x in (40, W - 40):
        for y in (40, H - 40):
            d.line([(x - 7, y), (x + 7, y)], fill=(203, 197, 185, 255), width=1)
            d.line([(x, y - 7), (x, y + 7)], fill=(203, 197, 185, 255), width=1)
    return img


def dark_bg() -> Image.Image:
    img = Image.new("RGBA", (W, H), DARK)
    d = ImageDraw.Draw(img)
    for x in range(0, W, 80):
        d.line([(x, 0), (x, H)], fill=DARK_GRID, width=1)
    for y in range(0, H, 80):
        d.line([(0, y), (W, y)], fill=DARK_GRID, width=1)
    for x in (40, W - 40):
        for y in (40, H - 40):
            d.line([(x - 7, y), (x + 7, y)], fill=(78, 73, 65, 255), width=1)
            d.line([(x, y - 7), (x, y + 7)], fill=(78, 73, 65, 255), width=1)
    return img


# --------------------------------------------------------------------------
# Cards and screenshots
# --------------------------------------------------------------------------


def rounded(draw, box, radius, fill=None, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def chip(draw, xy, text, fnt, fg, bg, border=None, pad_x=16, pad_y=9, radius=8):
    x, y = xy
    w = draw.textlength(text, font=fnt) + pad_x * 2
    h = fnt.size + pad_y * 2
    rounded(draw, (x, y, x + w, y + h), radius, fill=bg, outline=border, width=1)
    draw.text((x + pad_x, y + pad_y - 2), text, font=fnt, fill=fg)
    return w, h


def paste_screenshot(base, name, x, y, w, h, radius=12):
    source = Image.open(ASSETS / name).convert("RGB")
    inner_w, inner_h = w - 20, h - 20
    source = source.resize((inner_w, inner_h), Image.LANCZOS)

    shadow = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((x + 8, y + 24, x + w + 10, y + h + 24), radius=radius + 8, fill=(17, 15, 12, 80))
    shadow = shadow.filter(ImageFilter.GaussianBlur(24))
    base.alpha_composite(shadow)

    d = ImageDraw.Draw(base)
    rounded(d, (x, y, x + w, y + h), radius + 8, fill=WHITE)
    mask = Image.new("L", (inner_w, inner_h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, inner_w - 1, inner_h - 1), radius=radius, fill=255)
    base.paste(source, (x + 10, y + 10), mask)
    rounded(d, (x, y, x + w, y + h), radius + 8, outline=(211, 206, 195, 255), width=1)


def draw_arrow(draw, x1, y, x2, color, width=3, head=11):
    draw.line([(x1, y), (x2, y)], fill=color, width=width)
    draw.line([(x2 - head, y - head), (x2, y), (x2 - head, y + head)], fill=color, width=width)


# --------------------------------------------------------------------------
# Scenes
# --------------------------------------------------------------------------


def scene_title(s) -> Image.Image:
    img = dark_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 1, dark=True)

    draw_tracked(d, (100, 205), "FINITE-CAPACITY SCHEDULING / PRODUCT FILM", font("mono", 17), TEAL_BRIGHT, 2.0)

    head = font("bold", 238)
    ink_top(d, (86, 245), "Takt", head, DARK_TEXT)

    tag1 = font("semi", 55)
    tag2 = font("semi", 55)
    d.text((100, 590), "The scheduler that tells you", font=tag1, fill=DARK_TEXT)
    d.text((100, 664), "why you're late.", font=tag2, fill=TEAL_BRIGHT)

    d.line([(100, 770), (820, 770)], fill=DARK_RULE, width=1)
    draw_tracked(d, (100, 796), "AJAO PRECISION WORKS / LAGOS, NIGERIA / NGN", font("mono", 15), DARK_MUTED, 1.2)

    # Product-shaped diagram: a miniature schedule with one late bar crossing its due line.
    px, py, pw, ph = 1010, 196, 810, 700
    rounded(d, (px, py, px + pw, py + ph), 24, fill=DARK_CARD, outline=(62, 58, 52, 255), width=1)
    draw_tracked(d, (px + 38, py + 34), "SCHEDULE / SEED 90210", font("mono", 14), DARK_MUTED, 1.4)
    d.text((px + 38, py + 62), "The schedule is a claim.", font=font("semi", 28), fill=DARK_TEXT)
    d.line([(px + 38, py + 108), (px + pw - 38, py + 108)], fill=DARK_RULE, width=1)

    rows = [
        ("CNC-02", [(0, 118, "J-1045"), (124, 72, "J-1054"), (202, 108, "J-1042"), (316, 200, "J-1051")]),
        ("LATHE", [(0, 96, "J-1053"), (102, 84, "J-1049"), (192, 64, "J-1043"), (262, 86, "J-1046")]),
        ("PAINT", [(118, 96, "J-1045"), (220, 80, "J-1054"), (370, 72, "J-1048")]),
        ("INSP", [(62, 54, ""), (154, 58, ""), (268, 92, "J-1052"), (380, 44, "")]),
        ("DEBURR", [(48, 50, ""), (136, 44, ""), (244, 58, ""), (404, 48, "")]),
        ("ASSY", [(166, 116, "J-1042"), (338, 82, "J-1048")]),
    ]
    timeline_x = px + 160
    timeline_w = 590
    top = py + 150
    row_h = 72
    due_x = timeline_x + 470

    for day in range(4):
        dx = timeline_x + day * (timeline_w / 4)
        d.line([(dx, top - 18), (dx, top + row_h * 6 - 14)], fill=(51, 48, 43, 255), width=1)
        draw_tracked(d, (dx + 6, top - 34), f"DAY {day + 1}", font("mono", 11), (120, 114, 104, 255), 1.0)

    for i, (label, bars) in enumerate(rows):
        y = top + i * row_h
        if i:
            d.line([(px + 38, y - 12), (px + pw - 38, y - 12)], fill=(51, 48, 43, 255), width=1)
        d.text((px + 38, y + 7), label, font=font("mono_semi", 15), fill=DARK_TEXT)
        for offset, length, name in bars:
            bx = timeline_x + offset
            late = name == "J-1051"
            color = OXIDE if late else TEAL
            rounded(d, (bx, y + 2, bx + length, y + 30), 4, fill=color)
            if name:
                d.text((bx + 6, y + 6), name, font=font("mono_semi", 12), fill=(248, 245, 237, 255))

    # due line
    for yy in range(top - 4, top + row_h * 6 - 18, 12):
        d.line([(due_x, yy), (due_x, yy + 6)], fill=(222, 183, 96, 255), width=2)
    draw_tracked(d, (due_x + 8, top + row_h * 6 - 2), "DUE", font("mono", 11), (222, 183, 96, 255), 1.0)

    # Late callout lives in the panel header so it never covers a schedule bar.
    draw_tracked_right(d, (px + pw - 38, py + 34), "J-1051 / +26h 40m", font("mono_semi", 12), (225, 118, 94, 255), 0.8)

    draw_tracked(d, (px + 38, py + ph - 42), "14 JOBS / 7 WORK CENTERS / 41 OPS", font("mono", 12), DARK_MUTED, 1.1)
    return img


def scene_manifesto(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 2)

    draw_tracked(d, (100, 165), "THE PROBLEM", font("mono_semi", 16), TEAL, 2.6)
    d.rectangle([72, 225, 78, 548], fill=OXIDE)

    ink_top(d, (104, 218), "A red bar", font("bold", 132), INK)
    ink_top(d, (104, 356), "isn't a reason.", font("bold", 132), INK)

    body = font("regular", 33)
    d.text((106, 548), "Most tools stop at the symptom. Takt starts with the cause.", font=body, fill=INK_SOFT)

    cards = [
        ("01 / WHERE", "Which work center\nis binding?", "The resource that sets\nthe date."),
        ("02 / HOW MUCH", "How many minutes\nare queue?", "Waiting time, measured,\nnot guessed."),
        ("03 / WHAT IF", "What change\nclears it?", "Test capacity before\nyou spend."),
    ]
    card_x = [100, 690, 1280]
    for x, (label, question, support) in zip(card_x, cards):
        rounded(d, (x, 690, x + 540, 918), 18, fill=CARD, outline=RULE, width=1)
        draw_tracked(d, (x + 32, 716), label, font("mono_semi", 14), TEAL, 2.0)
        d.multiline_text((x + 32, 752), question, font=font("semi", 29), fill=INK, spacing=7)
        d.multiline_text((x + 32, 844), support, font=font("regular", 18), fill=INK_SOFT, spacing=5)
    return img


def scene_board(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 3)

    draw_tracked(d, (100, 156), "01 / DIAGNOSIS", font("mono_semi", 16), TEAL, 2.6)
    ink_top(d, (100, 194), "The board names", font("bold", 68), INK)
    ink_top(d, (100, 270), "the constraint.", font("bold", 68), INK)
    draw_paragraph(d, (100, 378), "J-1051 is late. Takt traces every minute of the delay to queue time at one work center.", font("regular", 25), INK_SOFT, 630, 38)

    d.line([(100, 512), (730, 512)], fill=RULE, width=1)
    metrics = [
        ("26h 40m", "LATE / J-1051"),
        ("100%", "OF DELAY IS QUEUE"),
        ("CNC-02", "BINDING WORK CENTER / 91% LOAD"),
    ]
    y = 548
    for value, label in metrics:
        d.line([(100, y - 14), (730, y - 14)], fill=RULE, width=1)
        ink_top(d, (100, y), value, font("semi", 40), INK)
        draw_tracked(d, (100, y + 50), label, font("mono", 13), INK_FAINT, 1.2)
        y += 100

    draw_tracked(d, (100, 868), "NAMED. MEASURED. CAUSAL.", font("mono_semi", 15), TEAL, 2.2)

    draw_tracked(d, (800, 138), "DIAGNOSIS BOARD / AJAO PRECISION WORKS / LAGOS", font("mono", 13), INK_FAINT, 1.4)
    paste_screenshot(img, "board-wide.png", 800, 174, 1020, 680)
    return img


def scene_whatif(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 4)

    draw_tracked(d, (100, 156), "02 / DECISION", font("mono_semi", 16), TEAL, 2.6)
    ink_top(d, (100, 194), "Test the fix", font("bold", 68), INK)
    ink_top(d, (100, 270), "before you buy it.", font("bold", 68), TEAL)
    draw_paragraph(d, (100, 378), "One machine at CNC-02. Same seed, same demand, one capacity change.", font("regular", 25), INK_SOFT, 630, 38)

    rows = [
        ("LATE JOBS", "1", "0"),
        ("LOST TIME", "26h 40m", "0m"),
        ("RECOVERED", "1,600", None),
    ]
    y = 530
    for label, before, after in rows:
        d.line([(100, y - 14), (730, y - 14)], fill=RULE, width=1)
        draw_tracked(d, (100, y), label, font("mono_semi", 13), INK_FAINT, 1.3)
        ink_top(d, (100, y + 26), before, font("semi", 38), INK)
        bw = text_width(d, before, font("semi", 38))
        if after is not None:
            draw_arrow(d, 100 + bw + 18, y + 50, 100 + bw + 64, TEAL, 3, 9)
            ink_top(d, (100 + bw + 80, y + 26), after, font("semi", 38), TEAL)
        else:
            d.text((100 + bw + 16, y + 44), "min", font=font("semi", 25), fill=TEAL)
        y += 98

    chip_x, chip_y = 100, 862
    f = font("mono_semi", 13)
    chip(d, (chip_x, chip_y), "ISOLATED WHAT-IF / SEED 90210", f, TEAL, (223, 236, 231, 255), (168, 204, 194, 255))

    draw_tracked(d, (800, 138), "SCHEDULE / SAME RUN, EXTRA CAPACITY", font("mono", 13), INK_FAINT, 1.4)
    paste_screenshot(img, "schedule-wide.png", 800, 174, 1020, 680)
    return img


def scene_jobs(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 5)

    draw_tracked(d, (100, 156), "03 / WORK", font("mono_semi", 16), TEAL, 2.6)
    ink_top(d, (100, 194), "The work on", font("bold", 68), INK)
    ink_top(d, (100, 270), "the floor.", font("bold", 68), INK)
    draw_paragraph(d, (100, 378), "A scheduler is only as good as its job book. Every row is editable, searchable, and exportable.", font("regular", 25), INK_SOFT, 630, 38)

    checks = [
        ("SEARCH", "Code, title, or customer"),
        ("FILTER", "All / Late / On time / Not run"),
        ("EXPORT", "Copy the real rows as CSV"),
        ("EDIT", "Tap a job to change its routing"),
    ]
    y = 528
    for label, text in checks:
        d.line([(100, y - 14), (730, y - 14)], fill=RULE, width=1)
        rounded(d, (100, y + 4, 124, y + 28), 5, fill=TEAL)
        d.line([(107, y + 16), (112, y + 21), (119, y + 11)], fill=WHITE, width=3)
        draw_tracked(d, (146, y), label, font("mono_semi", 13), INK_FAINT, 1.3)
        d.text((146, y + 22), text, font=font("regular", 23), fill=INK)
        y += 82

    draw_tracked(d, (800, 138), "JOBS / 14 JOBS / 7 WORK CENTERS", font("mono", 13), INK_FAINT, 1.4)
    paste_screenshot(img, "jobs-wide.png", 800, 174, 1020, 680)
    return img


def scene_access(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 6)

    draw_tracked(d, (100, 156), "04 / ACCESS", font("mono_semi", 16), TEAL, 2.6)
    ink_top(d, (100, 194), "Accounts are optional.", font("bold", 58), INK)
    ink_top(d, (100, 260), "Authority is not.", font("bold", 58), TEAL)
    draw_paragraph(d, (100, 350), "A guest key opens a shop instantly. An account keeps every workspace separate.", font("regular", 25), INK_SOFT, 630, 38)

    rows = [
        ("GUEST", "Workspace key, no email"),
        ("MEMBER", "Owner, editor, or viewer"),
        ("SESSION", "30-day hashed bearer token"),
        ("PASSWORDS", "Argon2id, never plaintext"),
    ]
    y = 480
    for label, text in rows:
        d.line([(100, y - 14), (730, y - 14)], fill=RULE, width=1)
        draw_tracked(d, (100, y), label, font("mono_semi", 13), INK_FAINT, 1.3)
        d.text((250, y - 3), text, font=font("regular", 23), fill=INK)
        y += 78

    chip(d, (100, 820), "GUEST KEY / INSTANT WORKSPACE", font("mono_semi", 13), TEAL, (223, 236, 231, 255), (168, 204, 194, 255))

    draw_tracked(d, (800, 138), "AUTH / SIGN IN OR OPEN WITH A KEY", font("mono", 13), INK_FAINT, 1.4)
    paste_screenshot(img, "auth-wide.png", 800, 174, 1020, 680)

    # Point to the guest-key button in the real screenshot.
    bx, by, bw, bh = 1385, 486, 314, 34
    rounded(d, (bx, by, bx + bw, by + bh), 7, outline=TEAL, width=3)
    draw_tracked(d, (bx + 2, by - 24), "GUEST KEY", font("mono_semi", 11), TEAL, 1.6)
    return img


def scene_roles(s) -> Image.Image:
    img = paper_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 7)

    draw_tracked(d, (100, 156), "05 / AUTHORITY", font("mono_semi", 16), TEAL, 2.6)
    ink_top(d, (100, 194), "Roles are enforced", font("bold", 62), INK)
    ink_top(d, (100, 266), "by the server.", font("bold", 62), TEAL)
    draw_paragraph(d, (100, 360), "The interface hides what you can't do. The API rejects what you mustn't.", font("regular", 25), INK_SOFT, 630, 38)

    roles = [
        ("OWNER", "Full access"),
        ("EDITOR", "Read and write"),
        ("VIEWER", "Read only"),
    ]
    y = 500
    for label, text in roles:
        d.line([(100, y - 14), (730, y - 14)], fill=RULE, width=1)
        draw_tracked(d, (100, y), label, font("mono_semi", 14), INK, 1.6)
        d.text((270, y - 3), text, font=font("regular", 24), fill=INK_SOFT)
        y += 76

    # amber proof strip
    rounded(d, (100, 748, 730, 884), 16, fill=(247, 237, 218, 255), outline=(219, 190, 135, 255), width=1)
    draw_tracked(d, (128, 772), "VIEWER WRITE REJECTED / HTTP 400", font("mono_semi", 15), (138, 89, 22, 255), 0.7)
    d.text((128, 806), "The server rejects the edit with a readable error.", font=font("regular", 20), fill=(110, 83, 44, 255))
    d.text((128, 838), "Hiding a button is UX. Rejecting the write is security.", font=font("regular", 20), fill=(110, 83, 44, 255))

    draw_tracked(d, (800, 138), "SETUP / PEOPLE AND ROLES", font("mono", 13), INK_FAINT, 1.4)
    paste_screenshot(img, "setup-wide.png", 800, 174, 1020, 680)
    return img


def scene_outro(s) -> Image.Image:
    img = dark_bg()
    d = ImageDraw.Draw(img)
    draw_chrome(img, d, 8, dark=True, top_right="FLUTTER × SERVERPOD / 2026")

    draw_tracked(d, (100, 198), "WHY LATE? TAKT KNOWS. / LAGOS, NIGERIA", font("mono_semi", 16), TEAL_BRIGHT, 2.4)
    ink_top(d, (86, 236), "Takt", font("bold", 196), DARK_TEXT)
    d.text((100, 486), "The scheduler that tells you", font=font("semi", 48), fill=DARK_TEXT)
    d.text((100, 548), "why you're late.", font=font("semi", 48), fill=TEAL_BRIGHT)

    chips = ["FLUTTER", "SERVERPOD", "POSTGRES", "LAGOS / NGN", "30 + 17 TESTS"]
    x = 100
    for text in chips:
        w, h = chip(d, (x, 648), text, font("mono_semi", 13), DARK_TEXT, (44, 42, 38, 255), (74, 69, 61, 255), 14, 9, 7)
        x += w + 10

    d.line([(100, 760), (820, 760)], fill=DARK_RULE, width=1)
    draw_tracked(d, (100, 786), "AJAO PRECISION WORKS / LAGOS, NIGERIA / NGN", font("mono", 14), DARK_MUTED, 1.2)

    # Outcome card
    px, py, pw, ph = 1030, 200, 790, 650
    rounded(d, (px, py, px + pw, py + ph), 24, fill=DARK_CARD, outline=(62, 58, 52, 255), width=1)
    draw_tracked(d, (px + 44, py + 38), "WHAT-IF RESULT / CNC-02 +1", font("mono", 14), DARK_MUTED, 1.4)
    d.line([(px + 44, py + 78), (px + pw - 44, py + 78)], fill=DARK_RULE, width=1)

    ink_top(d, (px + 44, py + 112), "1", font("bold", 96), DARK_TEXT)
    draw_arrow(d, px + 116, py + 176, px + 176, TEAL_BRIGHT, 5, 15)
    ink_top(d, (px + 198, py + 112), "0", font("bold", 96), TEAL_BRIGHT)
    draw_tracked(d, (px + 44, py + 218), "LATE JOBS", font("mono", 13), DARK_MUTED, 1.4)

    d.line([(px + 44, py + 274), (px + pw - 44, py + 274)], fill=DARK_RULE, width=1)
    ink_top(d, (px + 44, py + 304), "26h 40m", font("semi", 58), DARK_TEXT)
    draw_arrow(d, px + 334, py + 354, px + 400, TEAL_BRIGHT, 4, 12)
    ink_top(d, (px + 422, py + 316), "0m", font("semi", 58), TEAL_BRIGHT)
    draw_tracked(d, (px + 44, py + 382), "LOST TIME", font("mono", 13), DARK_MUTED, 1.4)

    d.line([(px + 44, py + 438), (px + pw - 44, py + 438)], fill=DARK_RULE, width=1)
    d.text((px + 44, py + 470), "+1,600 min recovered", font=font("semi", 32), fill=TEAL_BRIGHT)
    draw_tracked(d, (px + 44, py + 522), "SAME SEED / ONE CAPACITY CHANGE", font("mono", 12), DARK_MUTED, 1.2)
    draw_tracked(d, (px + 44, py + ph - 46), "REAL AUTH / REAL POSTGRES / REAL TESTS", font("mono", 12), (126, 120, 110, 255), 1.0)
    return img


SCENES = [
    {
        "id": "01",
        "type": "title",
        "name": "Title",
        "vo": "Most shop tools show a red bar. A red bar is not a reason. At Ajao Precision Works in Lagos, Takt tells you why you're late, and what would fix it.",
        "pad": 0.8,
    },
    {
        "id": "02",
        "type": "manifesto",
        "name": "Problem",
        "vo": "High-mix shops in Lagos don't lose dates because one operation is slow. Jobs wait behind a constrained work center, and that queue is where the promise disappears.",
        "pad": 0.5,
    },
    {
        "id": "03",
        "type": "board",
        "name": "Diagnosis",
        "vo": "Takt opens on the diagnosis board. Lekki Fluid's adapter plate, J ten fifty-one, is twenty-six hours and forty minutes late. Every minute traces to queue time at CNC zero two, running at ninety-one percent load. Named. Measured. Causal.",
        "pad": 0.5,
    },
    {
        "id": "04",
        "type": "whatif",
        "name": "What-if",
        "vo": "Before Tunde buys another machine, test the fix. Add one machine at CNC zero two. Same seed, one capacity change. The late job clears, and all sixteen hundred lost minutes come back.",
        "pad": 0.5,
    },
    {
        "id": "05",
        "type": "jobs",
        "name": "Jobs",
        "vo": "The floor is real, too. Search the job book, filter by status, copy the rows as CSV. No fake export buttons. No dead controls.",
        "pad": 0.5,
    },
    {
        "id": "06",
        "type": "access",
        "name": "Access",
        "vo": "Accounts are optional. A guest key opens the shop instantly. Sign in, and every workspace stays separate, with its own people and data.",
        "pad": 0.5,
    },
    {
        "id": "07",
        "type": "roles",
        "name": "Authority",
        "vo": "Authority is enforced on the Serverpod API, not the interface. Tunde owns. Ngozi edits. Amina reads, and the server rejects every write. Hiding a button is UX. Rejecting the write is security.",
        "pad": 0.5,
    },
    {
        "id": "08",
        "type": "outro",
        "name": "Outro",
        "vo": "Takt is Flutter and Serverpod, with real auth, real Postgres, thirty server tests, and seventeen Flutter tests. The scheduler that tells you why you're late.",
        "pad": 1.2,
    },
]

RENDERERS = {
    "title": scene_title,
    "manifesto": scene_manifesto,
    "board": scene_board,
    "whatif": scene_whatif,
    "jobs": scene_jobs,
    "access": scene_access,
    "roles": scene_roles,
    "outro": scene_outro,
}


def render_slides():
    paths = []
    for s in SCENES:
        img = RENDERERS[s["type"]](s)
        path = BUILD / f"slide_{s['id']}.png"
        img.convert("RGB").save(path, "PNG")
        paths.append(path)
        print(f"  slide {s['id']}  {s['name']}  -> {path.name}")
    return paths


def make_contact_sheet(paths):
    thumb_w, thumb_h = 480, 270
    sheet = Image.new("RGB", (thumb_w * 2, (thumb_h + 34) * 4), (242, 240, 233))
    d = ImageDraw.Draw(sheet)
    label_font = font("mono", 16)
    for i, path in enumerate(paths):
        img = Image.open(path).convert("RGB").resize((thumb_w, thumb_h), Image.LANCZOS)
        x = (i % 2) * thumb_w
        y = (i // 2) * (thumb_h + 34)
        sheet.paste(img, (x, y))
        d.text((x + 10, y + thumb_h + 8), f"{i + 1:02d}  {SCENES[i]['name']}", font=label_font, fill=(31, 30, 28))
    out = BUILD / "contact-sheet.png"
    sheet.save(out)
    print(f"  contact sheet -> {out}")


# --------------------------------------------------------------------------
# Voiceover
# --------------------------------------------------------------------------


async def synth_one(text: str, out: Path):
    last_err = None
    for attempt in range(1, 5):
        try:
            communicate = edge_tts.Communicate(text, VOICE, rate=RATE, volume="+0%", pitch=PITCH)
            await communicate.save(str(out))
            if out.exists() and out.stat().st_size > 2000:
                return
            raise RuntimeError("audio file too small")
        except Exception as exc:  # network hiccup / service throttle
            last_err = exc
            print(f"    TTS attempt {attempt} failed: {exc}")
            await asyncio.sleep(1.5 * attempt)
    raise RuntimeError(f"TTS failed for {out.name}: {last_err}")


async def synth_all():
    for s in SCENES:
        out = BUILD / f"vo_{s['id']}.mp3"
        if out.exists() and out.stat().st_size > 2000:
            print(f"  voice {s['id']}  reuse {out.name}")
            continue
        print(f"  voice {s['id']}  {s['name']} ...")
        await synth_one(s["vo"], out)
        print(f"    {out.stat().st_size / 1024:.0f} KB")


# --------------------------------------------------------------------------
# Video
# --------------------------------------------------------------------------


def build_video(slide_paths):
    from moviepy import AudioFileClip, CompositeAudioClip, CompositeVideoClip, ImageClip, vfx

    transition = 0.35
    audio_clips = []
    durations = []
    starts = []
    t = 0.0
    for s in SCENES:
        audio = AudioFileClip(str(BUILD / f"vo_{s['id']}.mp3"))
        duration = float(audio.duration) + float(s["pad"])
        starts.append(t)
        durations.append(duration)
        audio_clips.append(audio)
        t += duration - transition
        print(f"  {s['id']}  audio {audio.duration:5.1f}s  scene {duration:5.1f}s  start {starts[-1]:5.1f}s")

    total = starts[-1] + durations[-1]
    video_clips = []
    for i, (png, duration, start) in enumerate(zip(slide_paths, durations, starts)):
        clip = ImageClip(str(png)).with_duration(duration)
        effects = []
        if i == 0:
            effects.append(vfx.FadeIn(0.5))
        else:
            effects.append(vfx.CrossFadeIn(transition))
        if i == len(slide_paths) - 1:
            effects.append(vfx.FadeOut(0.7))
        clip = clip.with_effects(effects).with_start(start)
        video_clips.append(clip)

    final = CompositeVideoClip(video_clips, size=(W, H)).with_duration(total)
    final = final.with_audio(CompositeAudioClip([a.with_start(starts[i]) for i, a in enumerate(audio_clips)]))

    out = ROOT / "takt-demo.mp4"
    print(f"\n  total runtime: {total:.1f}s")
    print(f"  encoding -> {out}")
    final.write_videofile(
        str(out),
        fps=30,
        codec="libx264",
        audio_codec="aac",
        audio_fps=48000,
        bitrate="7M",
        preset="medium",
        threads=4,
        ffmpeg_params=["-pix_fmt", "yuv420p", "-movflags", "+faststart"],
    )
    final.close()
    for clip in video_clips:
        try:
            clip.close()
        except Exception:
            pass
    for clip in audio_clips:
        try:
            clip.close()
        except Exception:
            pass
    print(f"  done: {out}  ({out.stat().st_size / 1024 / 1024:.1f} MB)")
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--images-only", action="store_true")
    parser.add_argument("--tts-only", action="store_true")
    parser.add_argument("--skip-tts", action="store_true")
    args = parser.parse_args()

    print("Rendering slides...")
    slide_paths = render_slides()
    make_contact_sheet(slide_paths)

    if args.images_only:
        print("\nSlides only. Inspect build/contact-sheet.png")
        return

    if not args.skip_tts:
        print("\nGenerating voiceover with Edge TTS...")
        asyncio.run(synth_all())

    if args.tts_only:
        print("\nVoiceover only.")
        return

    print("\nRendering the vertical layouts and captions...")
    subprocess.run([sys.executable, str(ROOT / "make_vertical_video.py")], check=True)

    print("\nBuilding all four cuts...")
    subprocess.run([sys.executable, str(ROOT / "assemble_formats.py")], check=True)
    subprocess.run([sys.executable, str(ROOT / "make_srt.py")], check=True)


if __name__ == "__main__":
    main()
