# -*- coding: utf-8 -*-
"""
Markdown popup.

Markdown tooltips and phantoms for SublimeText.

TextMate theme to CSS.

https://manual.macromates.com/en/language_grammars#naming_conventions
"""
import sublime
import markdown
import jinja2
import traceback
import time
from . import version as ver
from . import colorbox
from collections import OrderedDict
from .st_scheme_template import SchemeTemplate, POPUP, PHANTOM, NEW_SCHEMES
from .st_clean_css import clean_css
from .st_pygments_highlight import syntax_hl as pyg_syntax_hl
from .st_code_highlight import SublimeHighlight
from .st_mapping import lang_map
from . import imagetint
import re
import os
from . import frontmatter
try:
    import bs4
except Exception:
    bs4 = None

DEFAULT_CSS = 'Packages/mdpopups/css/default.css'
DEFAULT_USER_CSS = 'Packages/User/mdpopups.css'
IDK = '''
<style>html {background-color: #333; color: red}</style>
<div><p>¯\_(ツ)_/¯</p></div>
<div><p>
MdPopups failed to create<br>
the popup/phantom!<br><br>
Check the console to see if<br>
there are helpful errors.</p></div>
'''
HL_SETTING = 'mdpopups.use_sublime_highlighter'
STYLE_SETTING = 'mdpopups.default_style'
RE_BAD_ENTITIES = re.compile(r'(&(?!amp;|lt;|gt;|nbsp;)(?:\w+;|#\d+;))')

NODEBUG = 0
ERROR = 1
WARNING = 2
INFO = 3


def _log(msg):
    """Log."""

    print('mdpopups: %s' % str(msg))


def _debug(msg, level):
    """Debug log."""

    if int(_get_setting('mdpopups.debug', NODEBUG)) >= level:
        _log(msg)


def _get_setting(name, default=None):
    """Get the Sublime setting."""

    return sublime.load_settings('Preferences.sublime-settings').get(name, default)


def _can_show(view, location=-1):
    """
    Check if popup can be shown.

    I have seen Sublime can sometimes crash if trying
    to do a popup off screen.  Normally it should just not show,
    but sometimes it can crash.  We will check if popup
    can/should be attempted.
    """

    can_show = True
    sel = view.sel()
    if location >= 0:
        region = view.visible_region()
        if region.begin() > location or region.end() < location:
            can_show = False
    elif len(sel) >= 1:
        region = view.visible_region()
        if region.begin() > sel[0].b or region.end() < sel[0].b:
            can_show = False
    else:
        can_show = False

    return can_show


##############################
# Theme/Scheme cache management
##############################
_scheme_cache = OrderedDict()
_highlighter_cache = OrderedDict()


def _clear_cache():
    """Clear the css cache."""

    global _scheme_cache
    global _highlighter_cache
    _scheme_cache = OrderedDict()
    _highlighter_cache = OrderedDict()


def _is_cache_expired(cache_time):
    """Check if the cache entry is expired."""

    delta_time = _get_setting('mdpopups.cache_refresh_time', 30)
    if not isinstance(delta_time, int) or delta_time < 0:
        delta_time = 30
    return delta_time == 0 or (time.time() - cache_time) >= (delta_time * 60)


def _prune_cache():
    """Prune older items in cache (related to when they were inserted)."""

    limit = _get_setting('mdpopups.cache_limit', 10)
    if limit is None or not isinstance(limit, int) or limit <= 0:
        limit = 10
    while len(_scheme_cache) >= limit:
        _scheme_cache.popitem(last=True)
    while len(_highlighter_cache) >= limit:
        _highlighter_cache.popitem(last=True)


def _get_sublime_highlighter(view):
    """Get the SublimeHighlighter."""

    scheme = view.settings().get('color_scheme')
    obj = None
    if scheme is not None:
        if scheme in _highlighter_cache:
            obj, t = _highlighter_cache[scheme]
            if _is_cache_expired(t):
                obj = None
        if obj is None:
            try:
                obj = SublimeHighlight(scheme)
                _prune_cache()
                _highlighter_cache[scheme] = (obj, time.time())
            except Exception:
                _log('Failed to get Sublime highlighter object!')
                _debug(traceback.format_exc(), ERROR)
                pass
    return obj


def _get_scheme(view):
    """Get the scheme object and user CSS."""

    scheme = view.settings().get('color_scheme')
    settings = sublime.load_settings("Preferences.sublime-settings")
    obj = None
    user_css = ''
    default_css = ''
    if scheme is not None:
        if scheme in _scheme_cache:
            obj, user_css, default_css, t = _scheme_cache[scheme]
            # Check if cache expired or user changed pygments setting.
            if (
                _is_cache_expired(t) or
                obj.use_pygments != (not settings.get(HL_SETTING, True)) or
                obj.default_style != settings.get(STYLE_SETTING, True)
            ):
                obj = None
                user_css = ''
                default_css = ''
        if obj is None:
            try:
                obj = SchemeTemplate(scheme)
                _prune_cache()
                user_css = _get_user_css()
                default_css = _get_default_css()
                _scheme_cache[scheme] = (obj, user_css, default_css, time.time())
            except Exception:
                _log('Failed to convert/retrieve scheme to CSS!')
                _debug(traceback.format_exc(), ERROR)
    return obj, user_css, default_css


def _get_default_css():
    """Get default CSS."""

    return clean_css(sublime.load_resource(DEFAULT_CSS))


def _get_user_css():
    """Get user css."""

    css = None

    user_css = _get_setting('mdpopups.user_css', DEFAULT_USER_CSS)
    try:
        css = clean_css(sublime.load_resource(user_css))
    except Exception:
        pass
    return css if css else ''


##############################
# Markdown parsing
##############################
class _MdWrapper(markdown.Markdown):
    """
    Wrapper around Python Markdown's class.

    This allows us to gracefully continue when a module doesn't load.
    """

    Meta = {}

    def __init__(self, *args, **kwargs):
        """Call original init."""

        if 'allow_code_wrap' in kwargs:
            self.sublime_wrap = kwargs['allow_code_wrap']
            del kwargs['allow_code_wrap']
        if 'sublime_hl' in kwargs:
            self.sublime_hl = kwargs['sublime_hl']
            del kwargs['sublime_hl']

        super(_MdWrapper, self).__init__(*args, **kwargs)

    def registerExtensions(self, extensions, configs):  # noqa
        """
        Register extensions with this instance of Markdown.

        Keyword arguments:

        * extensions: A list of extensions, which can either
           be strings or objects.  See the docstring on Markdown.
        * configs: A dictionary mapping module names to config options.

        """

        from markdown import util
        from markdown.extensions import Extension

        for ext in extensions:
            try:
                if isinstance(ext, util.string_type):
                    ext = self.build_extension(ext, configs.get(ext, {}))
                if isinstance(ext, Extension):
                    ext.extendMarkdown(self, globals())
                elif ext is not None:
                    raise TypeError(
                        'Extension "%s.%s" must be of type: "markdown.Extension"'
                        % (ext.__class__.__module__, ext.__class__.__name__)
                    )
            except Exception:
                # We want to gracefully continue even if an extension fails.
                _log('Failed to load markdown module!')
                _debug(traceback.format_exc(), ERROR)

        return self


def _get_theme(view, css=None, css_type=POPUP, template_vars=None):
    """Get the theme."""

    obj, user_css, default_css = _get_scheme(view)
    try:
        return obj.apply_template(
            view,
            default_css + '\n' +
            ((clean_css(css) + '\n') if css else '') +
            user_css,
            css_type,
            template_vars
        ) if obj is not None else ''
    except Exception:
        _log('Failed to retrieve scheme CSS!')
        _debug(traceback.format_exc(), ERROR)
        return ''


def _remove_entities(text):
    """Remove unsupported HTML entities."""

    import html.parser
    html = html.parser.HTMLParser()

    def repl(m):
        """Replace entites except &, <, >, and nbsp."""
        return html.unescape(m.group(1))

    return RE_BAD_ENTITIES.sub(repl, text)


def _create_html(
    view, content, md=True, css=None, debug=False, css_type=POPUP,
    wrapper_class=None, template_vars=None, template_env_options=None, nl2br=True,
    allow_code_wrap=False
):
    """Create html from content."""

    debug = _get_setting('mdpopups.debug', NODEBUG)

    if css is None or not isinstance(css, str):
        css = ''

    style = _get_theme(view, css, css_type, template_vars)

    if debug:
        _debug('=====CSS=====', INFO)
        _debug(style, INFO)

    if md:
        content = md2html(
            view, content, template_vars=template_vars,
            template_env_options=template_env_options, nl2br=nl2br,
            allow_code_wrap=allow_code_wrap
        )
    else:
        # Strip out frontmatter if found as we don't currently
        # do anything with it when content is just HTML.
        content = _markup_template(frontmatter.get_frontmatter(content)[1], template_vars, template_env_options)

    if debug:
        _debug('=====HTML OUTPUT=====', INFO)
        if bs4:
            soup = bs4.BeautifulSoup(content, "html.parser")
            _debug('\n' + soup.prettify(), INFO)
        else:
            _debug('\n' + content, INFO)

    if wrapper_class:
        wrapper = ('<div class="mdpopups"><div class="%s">' % wrapper_class) + '%s</div></div>'
    else:
        wrapper = '<div class="mdpopups">%s</div>'

    html = "<style>%s</style>" % (style)
    html += _remove_entities(wrapper % content)
    return html


def _markup_template(markup, variables, options):
    """Template for markup."""

    if variables:
        if options is None:
            options = {}
        env = jinja2.Environment(**options)
        return env.from_string(markup).render(plugin=variables)
    return markup


##############################
# Public functions
##############################
def version():
    """Get the current version."""

    return ver.version()


def md2html(
    view, markup, template_vars=None, template_env_options=None,
    nl2br=True, allow_code_wrap=False
):
    """Convert Markdown to HTML."""

    if _get_setting('mdpopups.use_sublime_highlighter'):
        sublime_hl = (True, _get_sublime_highlighter(view))
    else:
        sublime_hl = (False, None)

    fm, markup = frontmatter.get_frontmatter(markup)

    # We allways include these
    extensions = [
        "mdpopups.mdx.highlight",
        "mdpopups.mdx.inlinehilite",
        "mdpopups.mdx.superfences"
    ]

    configs = {
        "mdpopups.mdx.highlight": {
            "guess_lang": False
        },
        "mdpopups.mdx.inlinehilite": {
            "style_plain_text": True
        },
        "mdpopups.mdx.superfences": {
            "custom_fences": fm.get('custom_fences', [])
        }
    }

    # Check if plugin is overriding extensions
    md_exts = fm.get('markdown_extensions', None)
    if md_exts is None:
        # No extension override, use defaults
        extensions.extend(
            [
                "markdown.extensions.admonition",
                "markdown.extensions.attr_list",
                "markdown.extensions.def_list",
                "pymdownx.betterem",
                "pymdownx.magiclink",
                "pymdownx.extrarawhtml"
            ]
        )

        # Use legacy method to determine if nl2b should be used
        if nl2br:
            extensions.append('markdown.extensions.nl2br')
    else:
        for ext in md_exts:
            if isinstance(ext, (dict, OrderedDict)):
                k, v = next(iter(ext.items()))
                # We don't allow plugins to overrides the internal color
                if not k.startswith('mdpopups.'):
                    extensions.append(k)
                    if v is not None:
                        configs[k] = v
            elif isinstance(ext, str):
                if not ext.startswith('mdpopups.'):
                    extensions.append(ext)

    return _MdWrapper(
        extensions=extensions,
        extension_configs=configs,
        sublime_hl=sublime_hl,
        allow_code_wrap=fm.get('allow_code_wrap', allow_code_wrap)
    ).convert(_markup_template(markup, template_vars, template_env_options)).replace('&quot;', '"').replace('\n', '')


def color_box(
    colors, border="#000000ff", border2=None, height=32, width=32,
    border_size=1, check_size=4, max_colors=5, alpha=False, border_map=0xF
):
    """Color box."""

    return colorbox.color_box(
        colors, border, border2, height, width,
        border_size, check_size, max_colors, alpha, border_map
    )


def color_box_raw(
    colors, border="#000000ff", border2=None, height=32, width=32,
    border_size=1, check_size=4, max_colors=5, alpha=False, border_map=0xF
):
    """Color box raw."""

    return colorbox.color_box_raw(
        colors, border, border2, height, width,
        border_size, check_size, max_colors, alpha, border_map
    )


def tint(img, color, opacity=255, height=None, width=None):
    """Tint the image."""

    if isinstance(img, str):
        try:
            img = sublime.load_binary_resource(img)
        except Exception:
            _log('Could not open binary file!')
            _debug(traceback.format_exc(), ERROR)
            return ''
    return imagetint.tint(img, color, opacity, height, width)


def tint_raw(img, color, opacity=255):
    """Tint the image."""

    if isinstance(img, str):
        try:
            img = sublime.load_binary_resource(img)
        except Exception:
            _log('Could not open binary file!')
            _debug(traceback.format_exc(), ERROR)
            return ''
    return imagetint.tint_raw(img, color, opacity)


def get_language_from_view(view):
    """Guess current language from view."""

    lang = None
    user_map = sublime.load_settings('Preferences.sublime-settings').get('mdpopups.sublime_user_lang_map', {})
    syntax = os.path.splitext(view.settings().get('syntax').replace('Packages/', '', 1))[0]
    keys = set(list(lang_map.keys()) + list(user_map.keys()))
    for key in keys:
        v1 = lang_map.get(key, (tuple(), tuple()))[1]
        v2 = user_map.get(key, (tuple(), tuple()))[1]
        if syntax in (tuple(v2) + v1):
            lang = key
            break
    return lang


def syntax_highlight(view, src, language=None, inline=False, allow_code_wrap=False):
    """Syntax highlighting for code."""

    try:
        if _get_setting('mdpopups.use_sublime_highlighter'):
            highlighter = _get_sublime_highlighter(view)
            code = highlighter.syntax_highlight(
                src, language, inline=inline, code_wrap=(not inline and allow_code_wrap)
            )
        else:
            code = pyg_syntax_hl(
                src, language, inline=inline, code_wrap=(not inline and allow_code_wrap)
            )
    except Exception:
        code = src
        _log('Failed to highlight code!')
        _debug(traceback.format_exc(), ERROR)

    return code


def tabs2spaces(text, tab_size=4):
    """
    Convert tabs to spaces on tab stops.

    Does not account for char width.
    """

    return text.expandtabs(tab_size)


def scope2style(view, scope, selected=False, explicit_background=False):
    """Convert the scope to a style."""

    style = {
        'color': None,
        'background': None,
        'style': ''
    }
    obj = _get_scheme(view)[0]
    style_obj = obj.guess_style(view, scope, selected, explicit_background)
    if NEW_SCHEMES:
        style['color'] = style_obj['foreground']
        style['background'] = style_obj['background']
        font = []
        if style_obj['bold']:
            font.append('bold')
        if style_obj['italic']:
            font.append('italic')
        style['style'] = ' '.join(font)
    else:
        style['color'] = style_obj.fg_simulated
        style['background'] = style_obj.bg_simulated
        style['style'] = style_obj.style
    return style


def clear_cache():
    """Clear cache."""

    _clear_cache()


def hide_popup(view):
    """Hide the popup."""

    view.hide_popup()


def update_popup(
    view, content, md=True, css=None, wrapper_class=None,
    template_vars=None, template_env_options=None, nl2br=True,
    allow_code_wrap=False
):
    """Update the popup."""

    disabled = _get_setting('mdpopups.disable', False)
    if disabled:
        _debug('Popups disabled', WARNING)
        return

    try:
        html = _create_html(
            view, content, md, css, css_type=POPUP, wrapper_class=wrapper_class,
            template_vars=template_vars, template_env_options=template_env_options, nl2br=nl2br,
            allow_code_wrap=allow_code_wrap
        )
    except Exception:
        _log(traceback.format_exc())
        html = IDK

    view.update_popup(html)


def show_popup(
    view, content, md=True, css=None,
    flags=0, location=-1, max_width=320, max_height=240,
    on_navigate=None, on_hide=None, wrapper_class=None,
    template_vars=None, template_env_options=None, nl2br=True,
    allow_code_wrap=False
):
    """Parse the color scheme if needed and show the styled pop-up."""

    disabled = _get_setting('mdpopups.disable', False)
    if disabled:
        _debug('Popups disabled', WARNING)
        return

    if not _can_show(view, location):
        return

    try:
        html = _create_html(
            view, content, md, css, css_type=POPUP, wrapper_class=wrapper_class,
            template_vars=template_vars, template_env_options=template_env_options,
            nl2br=nl2br, allow_code_wrap=allow_code_wrap
        )
    except Exception:
        _log(traceback.format_exc())
        html = IDK

    view.show_popup(
        html, flags=flags, location=location, max_width=max_width,
        max_height=max_height, on_navigate=on_navigate, on_hide=on_hide
    )


def is_popup_visible(view):
    """Check if popup is visible."""

    return view.is_popup_visible()


def add_phantom(
    view, key, region, content, layout, md=True,
    css=None, on_navigate=None, wrapper_class=None,
    template_vars=None, template_env_options=None, nl2br=True,
    allow_code_wrap=False
):
    """Add a phantom and return phantom id."""

    disabled = _get_setting('mdpopups.disable', False)
    if disabled:
        _debug('Phantoms disabled', WARNING)
        return

    try:
        html = _create_html(
            view, content, md, css, css_type=PHANTOM, wrapper_class=wrapper_class,
            template_vars=template_vars, template_env_options=template_env_options,
            nl2br=nl2br, allow_code_wrap=allow_code_wrap
        )
    except Exception:
        _log(traceback.format_exc())
        html = IDK

    return view.add_phantom(key, region, html, layout, on_navigate)


def erase_phantoms(view, key):
    """Erase phantoms."""

    view.erase_phantoms(key)


def erase_phantom_by_id(view, pid):
    """Erase phantom by ID."""

    view.erase_phantom_by_id(pid)


def query_phantom(view, pid):
    """Query phantom."""

    return view.query_phantom(pid)


def query_phantoms(view, pids):
    """Query phantoms."""

    return view.query_phantoms(pids)


class Phantom(sublime.Phantom):
    """A phantom object."""

    def __init__(
        self, region, content, layout, md=True,
        css=None, on_navigate=None, wrapper_class=None,
        template_vars=None, template_env_options=None, nl2br=True,
        allow_code_wrap=False
    ):
        """Initialize."""

        super().__init__(region, content, layout, on_navigate)
        self.md = md
        self.css = css
        self.wrapper_class = wrapper_class
        self.template_vars = template_vars
        self.template_env_options = template_env_options
        self.nl2br = nl2br
        self.allow_code_wrap = allow_code_wrap

    def __eq__(self, rhs):
        """Check if phantoms are equal."""

        # Note that self.id is not considered
        return (
            self.region == rhs.region and self.content == rhs.content and
            self.layout == rhs.layout and self.on_navigate == rhs.on_navigate and
            self.md == rhs.md and self.css == rhs.css and self.nl2br == rhs.nl2br and
            self.wrapper_class == rhs.wrapper_class and self.template_vars == rhs.template_vars and
            self.template_env_options == rhs.template_env_options and
            self.allow_code_wrap == rhs.allow_code_wrap
        )


class PhantomSet(sublime.PhantomSet):
    """Object that allows easy updating of phantoms."""

    def __init__(self, view, key=""):
        """Initialize."""

        super().__init__(view, key)

    def __del__(self):
        """Delete phantoms."""

        for p in self.phantoms:
            erase_phantom_by_id(self.view, p.id)

    def update(self, new_phantoms):
        """Update the list of phantoms that exist in the text buffer with their current location."""

        regions = query_phantoms(self.view, [p.id for p in self.phantoms])
        for i in range(len(regions)):
            self.phantoms[i].region = regions[i]

        count = 0
        for p in new_phantoms:
            if not isinstance(p, Phantom):
                # Convert sublime.Phantom to mdpopups.Phantom
                p = Phantom(
                    p.region, p.content, p.layout,
                    md=False, css=None, on_navigate=p.on_navigate, wrapper_class=None,
                    template_vars=None, template_env_options=None, nl2br=False,
                    allow_code_wrap=False
                )
                new_phantoms[count] = p
            try:
                # Phantom already exists, copy the id from the current one
                idx = self.phantoms.index(p)
                p.id = self.phantoms[idx].id
            except ValueError:
                p.id = add_phantom(
                    self.view,
                    self.key,
                    p.region,
                    p.content,
                    p.layout,
                    p.md,
                    p.css,
                    p.on_navigate,
                    p.wrapper_class,
                    p.template_vars,
                    p.template_env_options,
                    p.nl2br,
                    p.allow_code_wrap
                )
            count += 1

        for p in self.phantoms:
            # if the region is -1, then it's already been deleted, no need to call erase
            if p not in new_phantoms and p.region != sublime.Region(-1):
                erase_phantom_by_id(self.view, p.id)

        self.phantoms = new_phantoms


def format_frontmatter(values):
    """Format values as frontmatter."""

    return frontmatter.dump_frontmatter(values)
