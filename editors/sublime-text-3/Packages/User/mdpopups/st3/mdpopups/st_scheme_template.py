"""
Sublime Text Scheme template.

Converts scheme to css provides templating for
additonal so that they can access the colors.

Licensed under MIT
Copyright (c) 2015 - 2016 Isaac Muse <isaacmuse@gmail.com>

----------------------

TextMate theme to CSS.

https://manual.macromates.com/en/language_grammars#naming_conventions
"""
import sublime
import re
from . import version as ver
from .rgba import RGBA
from .st_color_scheme_matcher import ColorSchemeMatcher
import jinja2
from pygments.formatters import HtmlFormatter
from collections import OrderedDict
from .st_clean_css import clean_css
import copy
import decimal

NEW_SCHEMES = int(sublime.version()) >= 3150

INVALID = -1
POPUP = 0
PHANTOM = 1
LUM_MIDPOINT = 127

re_float_trim = re.compile(r'^(?P<keep>\d+)(?P<trash>\.0+|(?P<keep2>\.\d*[1-9])0+)$')
re_valid_custom_scopes = re.compile(r'[a-zA-Z\d]+[a-zA-Z\d._\-]*')
re_missing_semi_colon = re.compile(r'(?<!;) \}')

re_base_colors = re.compile(r'^\s*\.(?:dummy)\s*\{([^}]+)\}', re.MULTILINE)
re_color = re.compile(r'(?<!-)(color\s*:\s*#[A-Fa-z\d]{6})')
re_bgcolor = re.compile(r'(?<!-)(background(?:-color)?\s*:\s*#[A-Fa-z\d]{6})')
re_pygments_selectors = re.compile(r'\.dummy (\.[a-zA-Z\d]+) ')
CODE_BLOCKS = '.mdpopups .highlight, .mdpopups .inline-highlight { %s; %s; }'


def fmt_float(f, p=0):
    """Set float precision and trim precision zeros."""

    string = str(
        decimal.Decimal(f).quantize(decimal.Decimal('0.' + ('0' * p) if p > 0 else '0'), decimal.ROUND_HALF_UP)
    )

    m = re_float_trim.match(string)
    if m:
        string = m.group('keep')
        if m.group('keep2'):
            string += m.group('keep2')
    return string


class SchemeTemplate(object):
    """Determine color scheme colors and style for text in a Sublime view buffer."""

    def __init__(self, scheme_file):
        """Initialize."""

        self.scheme_file = scheme_file
        self.css_type = INVALID
        self.variable = {}
        self.view = None
        self.setup()

    def guess_style(self, view, scope, selected=False, explicit_background=False):
        """Guess color."""

        # Remove leading '.' to account for old style CSS class scopes.
        if not NEW_SCHEMES:
            return self.csm.guess_color(scope.lstrip('.'), selected, explicit_background)
        else:
            scope_style = view.style_for_scope(scope.lstrip('.'))
            style = {}
            style['foreground'] = scope_style['foreground']
            style['background'] = scope_style.get('background')
            style['bold'] = scope_style['bold']
            style['italic'] = scope_style['italic']

            defaults = view.style()
            if not explicit_background and not style.get('background'):
                style['background'] = defaults.get('background', '#FFFFFF')
            if selected:
                sfg = scope_style.get('selection_forground', defaults.get('selection_forground'))
                if sfg:
                    style['foreground'] = sfg
                style['background'] = scope_style.get('selection', '#0000FF')
            return style

    def legacy_parse_global(self):
        """
        Parse global settings.

        LEGACY.
        """

        self.csm = ColorSchemeMatcher(self.scheme_file)

        # Get general theme colors from color scheme file
        self.bground = self.csm.special_colors['background']['color_simulated']
        rgba = RGBA(self.bground)
        self.lums = rgba.get_true_luminance()
        is_dark = self.lums <= LUM_MIDPOINT
        self._variables = {
            "is_dark": is_dark,
            "is_light": not is_dark,
            "sublime_version": int(sublime.version()),
            "mdpopups_version": ver.version(),
            "color_scheme": self.scheme_file,
            "use_pygments": self.use_pygments,
            "default_style": self.default_style
        }
        self.html_border = rgba.get_rgb()
        self.fground = self.csm.special_colors['foreground']['color_simulated']

    def get_variables(self):
        """Get variables."""

        if NEW_SCHEMES:
            is_dark = self.is_dark()
            return {
                "is_dark": is_dark,
                "is_light": not is_dark,
                "sublime_version": int(sublime.version()),
                "mdpopups_version": ver.version(),
                "color_scheme": self.scheme_file,
                "use_pygments": self.use_pygments,
                "default_style": self.default_style
            }
        else:
            return self._variables

    def get_html_border(self):
        """Get html border."""

        return self.get_bg() if NEW_SCHEMES else self.html_border

    def is_dark(self):
        """Check if scheme is dark."""

        return self.get_lums() <= LUM_MIDPOINT

    def get_lums(self):
        """Get luminance."""

        if NEW_SCHEMES:
            bg = self.get_bg()
            rgba = RGBA(bg)
            return rgba.get_true_luminance()
        else:
            return self.lums

    def get_fg(self):
        """Get foreground."""

        return self.view.style().get('foreground', '#000000') if NEW_SCHEMES else self.fground

    def get_bg(self):
        """Get backtround."""

        return self.view.style().get('background', '#FFFFFF') if NEW_SCHEMES else self.bground

    def setup(self):
        """Setup the template environment."""

        settings = sublime.load_settings("Preferences.sublime-settings")
        self.use_pygments = not settings.get('mdpopups.use_sublime_highlighter', True)
        self.default_style = settings.get('mdpopups.default_style', True)

        if not NEW_SCHEMES:
            self.legacy_parse_global()

        # Create Jinja template
        self.env = jinja2.Environment()
        self.env.filters['css'] = self.retrieve_selector
        self.env.filters['pygments'] = self.pygments
        self.env.filters['foreground'] = self.to_fg
        self.env.filters['background'] = self.to_bg
        self.env.filters['brightness'] = self.brightness
        self.env.filters['colorize'] = self.colorize
        self.env.filters['hue'] = self.hue
        self.env.filters['invert'] = self.invert
        self.env.filters['saturation'] = self.saturation
        self.env.filters['contrast'] = self.contrast
        self.env.filters['grayscale'] = self.grayscale
        self.env.filters['sepia'] = self.sepia
        self.env.filters['fade'] = self.fade
        self.env.filters['getcss'] = self.read_css

    def read_css(self, css):
        """Read the CSS file."""

        try:
            var = copy.copy(self.variables)
            var.update(
                {
                    'is_phantom': self.css_type == PHANTOM,
                    'is_popup': self.css_type == POPUP
                }
            )

            return self.env.from_string(
                clean_css(sublime.load_resource(css))
            ).render(var=var, plugin=self.plugin_vars)
        except Exception:
            return ''

    def fade(self, css, factor):
        """
        Apply a fake transparency to color.

        Fake transparency is preformed on top of the background color.
        """
        try:
            parts = [c.strip('; ') for c in css.split(':')]
            if len(parts) == 2 and parts[0] in ('background-color', 'color'):
                rgba = RGBA(parts[1] + "%02f" % int(255.0 * max(min(float(factor), 1.0), 0.0)))
                rgba.apply_alpha(self.get_bg())
                return '%s: %s; ' % (parts[0], rgba.get_rgb())
        except Exception:
            pass
        return css

    def colorize(self, css, degree):
        """Colorize to the given hue."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.colorize(degree)
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def hue(self, css, degree):
        """Shift hue."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.hue(degree)
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def invert(self, css):
        """Invert color."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.invert()
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def contrast(self, css, factor):
        """Apply contrast filter."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.contrast(factor)
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def saturation(self, css, factor):
        """Apply saturation filter."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.saturation(factor)
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def grayscale(self, css):
        """Apply grayscale filter."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.grayscale()
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def sepia(self, css):
        """Apply sepia filter."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.sepia()
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def brightness(self, css, factor):
        """Adjust brightness."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] in ('background-color', 'color'):
            rgba = RGBA(parts[1])
            rgba.brightness(factor)
            parts[1] = "%s; " % rgba.get_rgb()
            return '%s: %s ' % (parts[0], parts[1])
        return css

    def to_fg(self, css):
        """Rename a CSS key value pair."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] == 'background-color':
            parts[0] = 'color'
            return '%s: %s; ' % (parts[0], parts[1])
        return css

    def to_bg(self, css):
        """Rename a CSS key value pair."""

        parts = [c.strip('; ') for c in css.split(':')]
        if len(parts) == 2 and parts[0] == 'color':
            parts[0] = 'background-color'
            return '%s: %s; ' % (parts[0], parts[1])
        return css

    def pygments(self, style):
        """Get pygments style."""

        return get_pygments(style)

    def retrieve_selector(self, selector, key=None, explicit_background=True):
        """Get the CSS key, value pairs for a rule."""

        if NEW_SCHEMES:
            general = self.view.style()
            fg = general.get('foreground', '#000000')
            bg = general.get('background', '#ffffff')
            scope = self.view.style_for_scope(selector)
            style = []
            if scope['bold']:
                style.append('bold')
            if scope['italic']:
                style.append('italic')
            color = scope.get('foreground', fg)
            bgcolor = scope.get('background', (None if explicit_background else bg))
        else:
            scope = self.guess_style(self.view, selector, explicit_background=explicit_background)
            color = scope.fg_simulated
            bgcolor = scope.bg_simulated
            style = scope.style.split(' ')

        css = []
        if color and (key is None or key == 'color'):
            css.append('color: %s' % color)
        if bgcolor and (key is None or key == 'background-color'):
            css.append('background-color: %s' % bgcolor)
        for s in style:
            if "bold" in s and (key is None or key == 'font-weight'):
                css.append('font-weight: bold')
            if "italic" in s and (key is None or key == 'font-style'):
                css.append('font-style: italic')
            if "underline" in s and (key is None or key == 'text-decoration') and False:  # disabled
                css.append('text-decoration: underline')
        text = ';'.join(css)
        if text:
            text += ';'
        return text

    def apply_template(self, view, css, css_type, template_vars=None):
        """Apply template to css."""

        self.view = view

        if css_type not in (POPUP, PHANTOM):
            return ''

        self.css_type = css_type
        self.variables = self.get_variables()

        var = copy.copy(self.variables)
        if template_vars and isinstance(template_vars, (dict, OrderedDict)):
            self.plugin_vars = copy.deepcopy(template_vars)
        else:
            self.plugin_vars = {}

        var.update(
            {
                'is_phantom': self.css_type == PHANTOM,
                'is_popup': self.css_type == POPUP
            }
        )

        return self.env.from_string(css).render(var=var, plugin=self.plugin_vars)


def get_pygments(style):
    """
    Get pygments style.

    Subllime CSS support is limited.  It cannot handle well
    things like: `.class1 .class2`,  but it can handle things like:
    `.class1.class2`.  So we will not use things like `.highlight` in front.

    We will first find {...} which has no syntax class.  This will contain
    our background and possibly foreground.  If for whatever reason we
    have no background or foreground, we will use `#000000` or `#ffffff`
    respectively.
    """

    try:
        # Lets see if we can find the pygments theme
        text = HtmlFormatter(style=style).get_style_defs('.dummy')
        text = re_missing_semi_colon.sub('; }', text)
    except Exception:
        return ''

    bg = None
    fg = None

    # Find {...} which has no syntax classes
    m = re_base_colors.search(text)
    if m:
        # Find background
        m1 = re_bgcolor.search(m.group(1))
        if m1:
            # Use `background-color` as it works better
            # with Sublime CSS
            bg = m1.group(1).replace('background', 'background-color')
        # Find foreground
        m1 = re_color.search(m.group(1))
        if m1:
            fg = m1.group(1)
    # Use defaults if None found
    if bg is None:
        bg = 'background-color: #ffffff'
    if fg is None:
        fg = 'color: #000000'

    # Reassemble replacing .highlight {...} with .codehilite, .inlinehilite {...}
    # All other classes will be left bare with only their syntax class.
    code_blocks = CODE_BLOCKS
    if m:
        css = clean_css(
            (
                text[:m.start(0)] +
                (code_blocks % (bg, fg)) +
                text[m.end(0):] +
                '\n'
            )
        )
    else:
        css = clean_css(
            (
                (code_blocks % (bg, fg)) + '\n' + text + '\n'
            )
        )

    return re_pygments_selectors.sub(r'.mdpopups .highlight \1', css)
