#!/usr/bin/env python3
"""Render the native 9:16 Takt film and burned-in caption overlays.

The landscape slides are composed for 16:9. Cropping them to 9:16 would cut
off the diagnosis, so this module reflows the same content into a 1080x1920
frame with a caption-safe area at the bottom.

Outputs:
  build/vslide_01.png ... vslide_08.png
  build/cap_land_01.png ... cap_land_08.png
  build/cap_vert_01.png ... cap_vert_08.png
"""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

from captions import CAPTIONS
from make_takt_video import (
    ASSETS,
    BUILD,
    CARD,
    DARK,
    DARK_CARD,
    DARK_GRID,
    DARK_MUTED,
    DARK_RULE,
    DARK_TEXT,
    GRID,
    INK,
    INK_FAINT,
    INK_SOFT,
    OXIDE,
    PAPER,
    RULE,
    SCENES,
    TEAL,
    TEAL_BRIGHT,
    WHITE,
    chip,
    draw_arrow,
    draw_mark,
    draw_tracked,
    draw_tracked_right,
    font,
    ink_top,
    paste_screenshot,
    rounded,
    text_width,
    wrap_lines,
)

VW, VH = 1080, 1920
M = 64
RIGHT = 1016
CAP_TOP = 1524
CAP_H = 236
FOOTER_Y = 1824

ROOT = Path(__file__).resolve().parent
VBUILD = ROOT / "build"


# --------------------------------------------------------------------------
# Vertical chrome
# --------------------------------------------------------------------------


def vpaper_bg() -> Image.Image:
    img = Image.new("RGBA", (VW, VH), PAPER)
    d = ImageDraw.Draw(img)
    for x in range(0, VW, 80):
        d.line([(x, 0), (x, VH)], fill=GRID, width=1)
    for y in range(0, VH, 80):
        d.line([(0, y), (VW, y)], fill=GRID, width=1)
    for x in (32, VW - 32):
        for y in (32, VH - 32):
            d.line([(x - 7, y), (x + 7, y)], fill=(203, 197, 185, 255), width=1)
            d.line([(x, y - 7), (x, y + 7)], fill=(203, 197, 185, 255), width=1)
    return img


def vdark_bg() -> Image.Image:
    img = Image.new("RGBA", (VW, VH), DARK)
    d = ImageDraw.Draw(img)
    for x in range(0, VW, 80):
        d.line([(x, 0), (x, VH)], fill=DARK_GRID, width=1)
    for y in range(0, VH, 80):
        d.line([(0, y), (VW, y)], fill=DARK_GRID, width=1)
    for x in (32, VW - 32):
        for y in (32, VH - 32):
            d.line([(x - 7, y), (x + 7, y)], fill=(78, 73, 65, 255), width=1)
            d.line([(x, y - 7), (x, y + 7)], fill=(78, 73, 65, 255), width=1)
    return img


def draw_vchrome(draw, idx: int, dark=False, top_right="FLUTTER × SERVERPOD"):
    fg = DARK_TEXT if dark else INK
    muted = DARK_MUTED if dark else INK_FAINT
    rule = DARK_RULE if dark else RULE

    draw_mark(draw, M, 52, 1.18, dark)
    draw_tracked(draw, (M + 54, 48), "TAKT", font("bold", 28), fg, 3.2)
    draw_tracked_right(draw, (RIGHT, 60), top_right, font("mono", 16), muted, 1.4)
    draw.line([(M, 108), (RIGHT, 108)], fill=rule, width=1)

    draw_tracked(draw, (M, FOOTER_Y), "TAKT / FINITE-CAPACITY SCHEDULER", font("mono", 13), muted, 1.0)
    draw_tracked_right(draw, (RIGHT, FOOTER_Y), f"{idx:02d} / 08", font("mono", 14), fg, 1.5)

    gap = 6
    total_w = RIGHT - M
    seg_w = (total_w - gap * 7) / 8
    for i in range(8):
        x = M + i * (seg_w + gap)
        color = fg if i == idx - 1 else (TEAL if i < idx - 1 else (DARK_RULE if dark else RULE))
        draw.rectangle([x, 1860, x + seg_w, 1863], fill=color)


def vlabel(draw, y, text):
    draw_tracked(draw, (M, y), text, font("mono_semi", 19), TEAL, 2.4)


def screenshot_label(draw, y, text):
    draw_tracked(draw, (M, y), text, font("mono", 15), INK_FAINT, 1.4)


# --------------------------------------------------------------------------
# Vertical scenes
# --------------------------------------------------------------------------


def scene_title_v(s) -> Image.Image:
    img = vdark_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 1, dark=True)

    draw_tracked(d, (M, 176), "FINITE-CAPACITY SCHEDULING / PRODUCT FILM", font("mono", 18), TEAL_BRIGHT, 1.8)
    ink_top(d, (54, 208), "Takt", font("bold", 258), DARK_TEXT)

    d.text((M, 552), "The scheduler that tells you", font=font("semi", 52), fill=DARK_TEXT)
    d.text((M, 616), "why you're late.", font=font("semi", 52), fill=TEAL_BRIGHT)
    d.line([(M, 716), (824, 716)], fill=DARK_RULE, width=1)
    draw_tracked(d, (M, 742), "AJAO PRECISION WORKS / LAGOS, NIGERIA / WAT / NGN", font("mono", 16), DARK_MUTED, 1.0)

    # Miniature schedule, reflowed for portrait.
    px, py, pw, ph = M, 830, 952, 650
    rounded(d, (px, py, px + pw, py + ph), 22, fill=DARK_CARD, outline=(62, 58, 52, 255), width=1)
    draw_tracked(d, (px + 34, py + 28), "SCHEDULE / SEED 90210", font("mono", 14), DARK_MUTED, 1.4)
    draw_tracked_right(d, (px + pw - 34, py + 28), "J-1051 / +26h 40m", font("mono_semi", 13), (225, 118, 94, 255), 0.7)
    d.text((px + 34, py + 54), "The schedule is a claim.", font=font("semi", 30), fill=DARK_TEXT)
    d.line([(px + 34, py + 104), (px + pw - 34, py + 104)], fill=DARK_RULE, width=1)

    rows = [
        ("CNC-02", [(0, 140, "J-1045"), (146, 86, "J-1054"), (238, 128, "J-1042"), (372, 235, "J-1051")]),
        ("LATHE", [(0, 115, "J-1053"), (122, 100, "J-1049"), (230, 76, "J-1043"), (314, 102, "J-1046")]),
        ("PAINT", [(140, 115, "J-1045"), (262, 96, "J-1054"), (434, 86, "J-1048")]),
        ("INSP", [(74, 64, ""), (184, 70, ""), (318, 110, "J-1052"), (448, 52, "")]),
        ("ASSY", [(198, 138, "J-1042"), (402, 98, "J-1048")]),
    ]
    timeline_x = px + 190
    timeline_w = 690
    top = py + 150
    row_h = 76
    due_x = timeline_x + 540

    for day in range(4):
        dx = timeline_x + day * (timeline_w / 4)
        d.line([(dx, top - 16), (dx, top + row_h * 5 - 12)], fill=(51, 48, 43, 255), width=1)
        draw_tracked(d, (dx + 6, top - 33), f"DAY {day + 1}", font("mono", 11), (120, 114, 104, 255), 1.0)

    for i, (label, bars) in enumerate(rows):
        y = top + i * row_h
        if i:
            d.line([(px + 34, y - 12), (px + pw - 34, y - 12)], fill=(51, 48, 43, 255), width=1)
        d.text((px + 34, y + 7), label, font=font("mono_semi", 15), fill=DARK_TEXT)
        for offset, length, name in bars:
            bx = timeline_x + offset
            late = name == "J-1051"
            color = OXIDE if late else TEAL
            rounded(d, (bx, y + 2, bx + length, y + 32), 4, fill=color)
            if name:
                d.text((bx + 6, y + 7), name, font=font("mono_semi", 12), fill=(248, 245, 237, 255))

    for yy in range(top - 3, top + row_h * 5 - 16, 12):
        d.line([(due_x, yy), (due_x, yy + 6)], fill=(222, 183, 96, 255), width=2)
    draw_tracked(d, (due_x + 8, top + row_h * 5 - 1), "DUE", font("mono", 11), (222, 183, 96, 255), 1.0)

    draw_tracked(d, (px + 34, py + ph - 42), "14 JOBS / 7 WORK CENTERS / 41 OPS", font("mono", 12), DARK_MUTED, 1.0)
    return img


def scene_manifesto_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 2)

    vlabel(d, 158, "THE PROBLEM")
    d.rectangle([36, 216, 42, 604], fill=OXIDE)
    ink_top(d, (76, 206), "A red bar", font("bold", 112), INK)
    ink_top(d, (76, 330), "isn't a reason.", font("bold", 112), INK)

    d.text((78, 498), "Most tools stop at the symptom.", font=font("regular", 30), fill=INK_SOFT)
    d.text((78, 544), "Takt starts with the cause.", font=font("regular", 30), fill=INK_SOFT)

    cards = [
        ("01 / WHERE", "Which work center\nis binding?", "The resource that sets\nthe date."),
        ("02 / HOW MUCH", "How many minutes\nare queue?", "Waiting time, measured,\nnot guessed."),
        ("03 / WHAT IF", "What change\nclears it?", "Test capacity before\nyou spend."),
    ]
    y = 620
    for label, question, support in cards:
        rounded(d, (M, y, RIGHT, y + 240), 18, fill=CARD, outline=RULE, width=1)
        draw_tracked(d, (M + 30, y + 26), label, font("mono_semi", 15), TEAL, 2.0)
        d.multiline_text((M + 30, y + 66), question, font=font("semi", 33), fill=INK, spacing=7)
        d.multiline_text((M + 30, y + 164), support, font=font("regular", 23), fill=INK_SOFT, spacing=5)
        y += 270
    return img


def scene_board_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 3)

    vlabel(d, 154, "01 / DIAGNOSIS")
    ink_top(d, (M, 190), "The board names", font("bold", 66), INK)
    ink_top(d, (M, 260), "the constraint.", font("bold", 66), INK)
    d.text((M, 352), "J-1051 is late. Takt traces every minute of the delay", font=font("regular", 28), fill=INK_SOFT)
    d.text((M, 392), "to queue time at one work center.", font=font("regular", 28), fill=INK_SOFT)

    screenshot_label(d, 476, "DIAGNOSIS BOARD / AJAO PRECISION WORKS / LAGOS")
    paste_screenshot(img, "board-wide.png", M, 506, 952, 620)

    d.line([(M, 1166), (RIGHT, 1166)], fill=RULE, width=1)
    metrics = [
        ("26h 40m", "LATE / J-1051"),
        ("100%", "OF DELAY IS QUEUE"),
        ("CNC-02", "BINDING / 91% LOAD"),
    ]
    for i, (value, label) in enumerate(metrics):
        x = M + i * 316
        if i:
            d.line([(x - 22, 1178), (x - 22, 1290)], fill=RULE, width=1)
        ink_top(d, (x, 1186), value, font("semi", 46), INK)
        draw_tracked(d, (x, 1256), label, font("mono", 13), INK_FAINT, 1.1)

    draw_tracked(d, (M, 1350), "NAMED. MEASURED. CAUSAL.", font("mono_semi", 18), TEAL, 2.2)
    return img


def scene_whatif_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 4)

    vlabel(d, 154, "02 / DECISION")
    ink_top(d, (M, 190), "Test the fix", font("bold", 74), INK)
    ink_top(d, (M, 272), "before you buy it.", font("bold", 74), TEAL)
    d.text((M, 380), "One machine at CNC-02. Same seed, same demand,", font=font("regular", 28), fill=INK_SOFT)
    d.text((M, 420), "one capacity change.", font=font("regular", 28), fill=INK_SOFT)

    rows = [
        ("LATE JOBS", "1", "0", False),
        ("LOST TIME", "26h 40m", "0m", False),
        ("RECOVERED", "+1,600", "min", True),
    ]
    y = 512
    for label, before, after, recovered in rows:
        d.line([(M, y - 12), (RIGHT, y - 12)], fill=RULE, width=1)
        draw_tracked(d, (M, y + 10), label, font("mono_semi", 14), INK_FAINT, 1.2)
        ink_top(d, (330, y + 18), before, font("semi", 46), TEAL if recovered else INK)
        bw = text_width(d, before, font("semi", 46))
        if recovered:
            d.text((330 + bw + 12, y + 34), "min", font=font("semi", 26), fill=TEAL)
        else:
            draw_arrow(d, 330 + bw + 20, y + 48, 330 + bw + 70, TEAL, 3, 10)
            ink_top(d, (330 + bw + 88, y + 18), after, font("semi", 46), TEAL)
        y += 92

    screenshot_label(d, 820, "SCHEDULE / SAME RUN, EXTRA CAPACITY")
    paste_screenshot(img, "schedule-wide.png", M, 850, 952, 600)
    chip(d, (M, 1460), "ISOLATED WHAT-IF / SEED 90210", font("mono_semi", 14), TEAL, (223, 236, 231, 255), (168, 204, 194, 255))
    return img


def scene_jobs_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 5)

    vlabel(d, 154, "03 / WORK")
    ink_top(d, (M, 190), "The work on", font("bold", 70), INK)
    ink_top(d, (M, 268), "the floor.", font("bold", 70), INK)
    d.text((M, 362), "A scheduler is only as good as its job book. Every row", font=font("regular", 28), fill=INK_SOFT)
    d.text((M, 402), "is editable, searchable, and exportable.", font=font("regular", 28), fill=INK_SOFT)

    checks = [
        ("SEARCH", "Code, title, or customer"),
        ("FILTER", "All / Late / On time / Not run"),
        ("EXPORT", "Copy the real rows as CSV"),
        ("EDIT", "Tap a job to change its routing"),
    ]
    for i, (label, text) in enumerate(checks):
        x = M + (i % 2) * 488
        y = 506 + (i // 2) * 116
        rounded(d, (x, y + 2, x + 32, y + 34), 6, fill=TEAL)
        d.line([(x + 9, y + 18), (x + 14, y + 23), (x + 23, y + 12)], fill=WHITE, width=3)
        draw_tracked(d, (x + 48, y), label, font("mono_semi", 14), INK_FAINT, 1.2)
        d.text((x + 48, y + 25), text, font=font("regular", 23), fill=INK)

    screenshot_label(d, 744, "JOBS / 14 JOBS / 7 WORK CENTERS")
    paste_screenshot(img, "jobs-wide.png", M, 774, 952, 635)
    draw_tracked(d, (M, 1440), "NO FAKE EXPORT BUTTONS.", font("mono_semi", 15), TEAL, 2.0)
    return img


def scene_access_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 6)

    vlabel(d, 154, "04 / ACCESS")
    ink_top(d, (M, 190), "Accounts are optional.", font("bold", 54), INK)
    ink_top(d, (M, 252), "Authority is not.", font("bold", 54), TEAL)
    d.text((M, 334), "A guest key opens a shop instantly. An account keeps", font=font("regular", 27), fill=INK_SOFT)
    d.text((M, 373), "every workspace separate.", font=font("regular", 27), fill=INK_SOFT)

    screenshot_label(d, 436, "AUTH / SIGN IN OR OPEN WITH A KEY")
    paste_screenshot(img, "auth-wide.png", M, 466, 952, 620)

    # Point at the real "Open with a workspace key" button.
    bx, by, bw, bh = 611, 748, 290, 30
    rounded(d, (bx, by, bx + bw, by + bh), 7, outline=TEAL, width=3)

    rows = [
        ("GUEST", "Workspace key, no email"),
        ("MEMBER", "Owner, editor, or viewer"),
        ("SESSION", "30-day hashed bearer token"),
        ("PASSWORDS", "Argon2id, never plaintext"),
    ]
    y = 1120
    for label, text in rows:
        d.line([(M, y - 12), (RIGHT, y - 12)], fill=RULE, width=1)
        draw_tracked(d, (M, y), label, font("mono_semi", 14), INK_FAINT, 1.2)
        d.text((246, y - 3), text, font=font("regular", 23), fill=INK)
        y += 72

    chip(d, (M, 1410), "GUEST KEY / INSTANT WORKSPACE", font("mono_semi", 14), TEAL, (223, 236, 231, 255), (168, 204, 194, 255))
    return img


def scene_roles_v(s) -> Image.Image:
    img = vpaper_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 7)

    vlabel(d, 154, "05 / AUTHORITY")
    ink_top(d, (M, 190), "Roles are enforced", font("bold", 60), INK)
    ink_top(d, (M, 256), "by the server.", font("bold", 60), TEAL)
    d.text((M, 342), "The interface hides what you can't do.", font=font("regular", 27), fill=INK_SOFT)
    d.text((M, 381), "The API rejects what you mustn't.", font=font("regular", 27), fill=INK_SOFT)

    roles = [
        ("OWNER", "Full access"),
        ("EDITOR", "Read and write"),
        ("VIEWER", "Read only"),
    ]
    y = 462
    for label, text in roles:
        d.line([(M, y - 12), (RIGHT, y - 12)], fill=RULE, width=1)
        draw_tracked(d, (M, y), label, font("mono_semi", 15), INK, 1.5)
        d.text((260, y - 3), text, font=font("regular", 24), fill=INK_SOFT)
        y += 68

    screenshot_label(d, 668, "SETUP / PEOPLE AND ROLES")
    paste_screenshot(img, "setup-wide.png", M, 698, 952, 620)

    rounded(d, (M, 1348, RIGHT, 1502), 16, fill=(247, 237, 218, 255), outline=(219, 190, 135, 255), width=1)
    draw_tracked(d, (M + 28, 1370), "VIEWER WRITE REJECTED / HTTP 400", font("mono_semi", 15), (138, 89, 22, 255), 0.6)
    d.text((M + 28, 1404), "The server rejects the edit with a readable error.", font=font("regular", 21), fill=(110, 83, 44, 255))
    d.text((M + 28, 1436), "Hiding a button is UX. Rejecting the write is security.", font=font("regular", 21), fill=(110, 83, 44, 255))
    return img


def scene_outro_v(s) -> Image.Image:
    img = vdark_bg()
    d = ImageDraw.Draw(img)
    draw_vchrome(d, 8, dark=True, top_right="FLUTTER × SERVERPOD / 2026")

    draw_tracked(d, (M, 176), "WHY LATE? TAKT KNOWS. / LAGOS, NIGERIA / WAT", font("mono_semi", 18), TEAL_BRIGHT, 2.0)
    ink_top(d, (54, 208), "Takt", font("bold", 204), DARK_TEXT)
    d.text((M, 470), "The scheduler that tells you", font=font("semi", 50), fill=DARK_TEXT)
    d.text((M, 532), "why you're late.", font=font("semi", 50), fill=TEAL_BRIGHT)

    chips = ["FLUTTER", "SERVERPOD", "POSTGRES", "LAGOS / WAT / NGN", "30 + 17 TESTS"]
    x = M
    for text in chips:
        w, _ = chip(d, (x, 622), text, font("mono_semi", 14), DARK_TEXT, (44, 42, 38, 255), (74, 69, 61, 255), 14, 9, 7)
        x += w + 9

    d.line([(M, 716), (RIGHT, 716)], fill=DARK_RULE, width=1)
    draw_tracked(d, (M, 742), "AJAO PRECISION WORKS / LAGOS, NIGERIA / WAT / NGN", font("mono", 14), DARK_MUTED, 1.1)

    px, py, pw, ph = M, 800, 952, 510
    rounded(d, (px, py, px + pw, py + ph), 22, fill=DARK_CARD, outline=(62, 58, 52, 255), width=1)
    draw_tracked(d, (px + 38, py + 30), "WHAT-IF RESULT / CNC-02 +1", font("mono", 14), DARK_MUTED, 1.4)
    d.line([(px + 38, py + 70), (px + pw - 38, py + 70)], fill=DARK_RULE, width=1)

    ink_top(d, (px + 48, py + 96), "1", font("bold", 94), DARK_TEXT)
    draw_arrow(d, px + 118, py + 164, px + 182, TEAL_BRIGHT, 5, 14)
    ink_top(d, (px + 204, py + 96), "0", font("bold", 94), TEAL_BRIGHT)
    draw_tracked(d, (px + 48, py + 204), "LATE JOBS", font("mono", 13), DARK_MUTED, 1.3)

    d.line([(px + 38, py + 252), (px + pw - 38, py + 252)], fill=DARK_RULE, width=1)
    ink_top(d, (px + 48, py + 274), "26h 40m", font("semi", 54), DARK_TEXT)
    draw_arrow(d, px + 310, py + 318, px + 372, TEAL_BRIGHT, 4, 12)
    ink_top(d, (px + 394, py + 282), "0m", font("semi", 54), TEAL_BRIGHT)
    draw_tracked(d, (px + 48, py + 344), "LOST TIME", font("mono", 13), DARK_MUTED, 1.3)

    d.line([(px + 38, py + 388), (px + pw - 38, py + 388)], fill=DARK_RULE, width=1)
    d.text((px + 48, py + 410), "+1,600 min recovered", font=font("semi", 34), fill=TEAL_BRIGHT)
    draw_tracked(d, (px + 48, py + 458), "SAME SEED / ONE CAPACITY CHANGE", font("mono", 12), DARK_MUTED, 1.1)

    draw_tracked(d, (M, 1360), "REAL AUTH / REAL POSTGRES / REAL TESTS", font("mono", 13), (126, 120, 110, 255), 1.0)
    return img


VRENDERERS = {
    "title": scene_title_v,
    "manifesto": scene_manifesto_v,
    "board": scene_board_v,
    "whatif": scene_whatif_v,
    "jobs": scene_jobs_v,
    "access": scene_access_v,
    "roles": scene_roles_v,
    "outro": scene_outro_v,
}


# --------------------------------------------------------------------------
# Caption overlays
# --------------------------------------------------------------------------


def make_caption(text, canvas_w, canvas_h, box, start_size, min_size, max_width):
    """Return a transparent full-frame RGBA image with one fitted caption bar."""
    overlay = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)
    x, y, w, h = box

    chosen = None
    for size in range(start_size, min_size - 1, -1):
        fnt = font("medium", size)
        lines = wrap_lines(d, text, fnt, max_width)
        line_h = int(size * 1.33)
        if len(lines) * line_h + 44 <= h:
            chosen = (fnt, lines, line_h)
            break
    if chosen is None:
        fnt = font("medium", min_size)
        lines = wrap_lines(d, text, fnt, max_width)
        chosen = (fnt, lines, int(min_size * 1.33))

    fnt, lines, line_h = chosen
    block_h = len(lines) * line_h
    text_y = y + (h - block_h) // 2 - 3

    rounded(d, (x, y, x + w, y + h), 12, fill=(24, 23, 21, 255), outline=(76, 71, 64, 255), width=1)
    d.rectangle([x + 18, y + 26, x + 22, y + h - 26], fill=TEAL_BRIGHT)
    for line in lines:
        d.text((x + 36, text_y), line, font=fnt, fill=DARK_TEXT)
        text_y += line_h
    return overlay


def make_captions():
    for i, text in enumerate(CAPTIONS, start=1):
        land = make_caption(
            text,
            1920,
            1080,
            box=(100, 918, 1720, 138),
            start_size=28,
            min_size=20,
            max_width=1620,
        )
        land.save(VBUILD / f"cap_land_{i:02d}.png")

        vert = make_caption(
            text,
            1080,
            1920,
            box=(64, CAP_TOP, 952, CAP_H),
            start_size=34,
            min_size=22,
            max_width=872,
        )
        vert.save(VBUILD / f"cap_vert_{i:02d}.png")
        print(f"  captions {i:02d}")


# --------------------------------------------------------------------------
# Render + preview
# --------------------------------------------------------------------------


def render_slides():
    paths = []
    for s in SCENES:
        img = VRENDERERS[s["type"]](s)
        path = VBUILD / f"vslide_{s['id']}.png"
        img.convert("RGB").save(path, "PNG")
        paths.append(path)
        print(f"  vertical slide {s['id']}  {s['name']}  -> {path.name}")
    return paths


def contact_sheet(paths):
    thumb_w, thumb_h = 252, 448
    sheet = Image.new("RGB", (thumb_w * 4, (thumb_h + 36) * 2), (242, 240, 233))
    d = ImageDraw.Draw(sheet)
    label = font("mono", 14)
    for i, path in enumerate(paths):
        img = Image.open(path).convert("RGB").resize((thumb_w, thumb_h), Image.LANCZOS)
        x = (i % 4) * thumb_w
        y = (i // 4) * (thumb_h + 36)
        sheet.paste(img, (x, y))
        d.text((x + 8, y + thumb_h + 8), f"{i + 1:02d}  {SCENES[i]['name']}", font=label, fill=INK)
    out = VBUILD / "vertical-contact-sheet.png"
    sheet.save(out)
    print(f"  vertical contact sheet -> {out}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--captions-only", action="store_true")
    args = parser.parse_args()

    if not args.captions_only:
        print("Rendering vertical slides...")
        paths = render_slides()
        contact_sheet(paths)

    print("Rendering caption overlays...")
    make_captions()


if __name__ == "__main__":
    main()
