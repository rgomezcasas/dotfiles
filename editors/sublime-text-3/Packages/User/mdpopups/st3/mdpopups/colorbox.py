"""
Sublime tooltip color box.

Licensed under MIT
Copyright (c) 2015 - 2016 Isaac Muse <isaacmuse@gmail.com>
"""
from .png import Writer
from .rgba import RGBA
import base64
import io

CHECK_LIGHT = "#FFFFFF"
CHECK_DARK = "#CCCCCC"

LIGHT = 0
DARK = 1

TOP = 1
RIGHT = 2
BOTTOM = 4
LEFT = 8

X = 0
Y = 1

__all__ = ('color_box',)


def to_list(rgb, alpha=False):
    """
    Break rgb channel itno a list.

    Take a color of the format #RRGGBBAA (alpha optional and will be stripped)
    and convert to a list with format [r, g, b].
    """
    if alpha:
        return [
            int(rgb[1:3], 16),
            int(rgb[3:5], 16),
            int(rgb[5:7], 16),
            int(rgb[7:9], 16) if len(rgb) > 7 else 255
        ]
    else:
        return [
            int(rgb[1:3], 16),
            int(rgb[3:5], 16),
            int(rgb[5:7], 16)
        ]


def checkered_color(color, background):
    """Mix color with the checkered color."""

    checkered = RGBA(color)
    checkered.apply_alpha(background)
    return checkered.get_rgb()


def get_border_size(direction, border_map):
    """Get size of border map."""

    size = 0
    if direction == X:
        if border_map & LEFT:
            size += 1
        if border_map & RIGHT:
            size += 1
    elif direction == Y:
        if border_map & TOP:
            size += 1
        if border_map & BOTTOM:
            size += 1
    return size


def color_box_raw(
    colors, border="#000000", border2=None, height=32, width=32,
    border_size=1, check_size=4, max_colors=5, alpha=False, border_map=0xF
):
    """
    Generate palette preview.

    Create a color box with the specified RGBA color(s)
    and RGB(A) border (alpha will be stripped out of border color).
    Colors is a list of colors, but only up to 5
    Border can be up to 2 colors (double border).

    Hight, width and border thickness can all be defined.

    If using a transparent color, you can define the checkerboard pattern size that shows through.
    If using multiple colors, you can control the max colors to display.  Colors currently are done
    horizontally only.

    Define size of swatch, border width,  and size of checkerboard squares.
    """

    assert height - (border_size * 2) >= 0, "Border size too big!"
    assert width - (border_size * 2) >= 0, "Border size too big!"

    # Gather preview colors
    preview_colors = []
    count = max_colors if len(colors) >= max_colors else len(colors)

    border = to_list(border, False)
    if border2 is not None:
        border2 = to_list(border2, False)

    border1_size = border2_size = int(border_size / 2)
    border1_size += border_size % 2
    if border2 is None:
        border1_size += border2_size
        border2_size = 0

    if count:
        for c in range(0, count):
            if alpha:
                preview_colors.append(
                    (
                        to_list(colors[c], True),
                        to_list(colors[c], True)
                    )
                )
            else:
                preview_colors.append(
                    (
                        to_list(checkered_color(colors[c], CHECK_LIGHT)),
                        to_list(checkered_color(colors[c], CHECK_DARK))
                    )
                )
    else:
        if alpha:
            preview_colors.append(
                (to_list('#00000000'), to_list('#00000000'))
            )
        else:
            preview_colors.append(
                (to_list(CHECK_LIGHT), to_list(CHECK_DARK))
            )

    color_height = height - (border_size * get_border_size(Y, border_map))
    color_width = width - (border_size * get_border_size(X, border_map))

    if count:
        dividers = int(color_width / count)
        if color_width % count:
            dividers += 1
    else:
        dividers = 0

    color_size_x = color_width

    p = []

    # Top Border
    if border_map & TOP:
        for x in range(0, border1_size):
            row = list(border * width)
            p.append(row)
        for x in range(0, border2_size):
            row = []
            if border_map & LEFT and border_map & RIGHT:
                row += list(border * border1_size)
                row += list(border2 * border2_size)
                row += list(border2 * color_width)
                row += list(border2 * border2_size)
                row += list(border * border1_size)
            elif border_map & RIGHT:
                row += list(border2 * color_width)
                row += list(border2 * border2_size)
                row += list(border * border1_size)
            elif border_map & LEFT:
                row += list(border * border1_size)
                row += list(border2 * border2_size)
                row += list(border2 * color_width)
            else:
                row += list(border2 * color_width)
            p.append(row)

    check_color_y = DARK
    for y in range(0, color_height):
        index = 0
        if y % check_size == 0:
            check_color_y = DARK if check_color_y == LIGHT else LIGHT

        # Left border
        row = []
        if border_map & LEFT:
            row += list(border * border1_size)
            if border2:
                row += list(border2 * border2_size)

        check_color_x = check_color_y
        for x in range(0, color_size_x):
            if x != 0 and dividers != 0 and x % dividers == 0:
                index += 1
            if x % check_size == 0:
                check_color_x = DARK if check_color_x == LIGHT else LIGHT
            row += (preview_colors[index][1] if check_color_x == DARK else preview_colors[index][0])

        if border_map & RIGHT:
            # Right border
            if border2:
                row += list(border2 * border2_size)
            row += list(border * border1_size)

        p.append(row)

    if border_map & BOTTOM:
        # Bottom border
        for x in range(0, border2_size):
            row = []
            if border_map & LEFT and border_map & RIGHT:
                row += list(border * border1_size)
                row += list(border2 * border2_size)
                row += list(border2 * color_width)
                row += list(border2 * border2_size)
                row += list(border * border1_size)
            elif border_map & LEFT:
                row += list(border * border1_size)
                row += list(border2 * border2_size)
                row += list(border2 * color_width)
            elif border_map & RIGHT:
                row += list(border2 * color_width)
                row += list(border2 * border2_size)
                row += list(border * border1_size)
            else:
                row += list(border2 * color_width)
            p.append(row)
        for x in range(0, border1_size):
            row = list(border * width)
            p.append(row)

    # Create bytes buffer for png
    with io.BytesIO() as f:

        # Write out png
        img = Writer(width, height, alpha=alpha)
        img.write(f, p)

        # Read out png bytes and base64 encode
        f.seek(0)

        return f.read()


def color_box(*args, **kwargs):
    """Generate palette preview and base64 encode it."""

    return "<img src=\"data:image/png;base64,%s\">" % (
        base64.b64encode(color_box_raw(*args, **kwargs)).decode('ascii')
    )
