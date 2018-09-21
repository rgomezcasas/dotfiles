"""
Highlight.

A library for managing code highlighting.

All Changes Copyright 2014-2017 Isaac Muse.

---

CodeHilite Extension for Python-Markdown
========================================

Adds code/syntax highlighting to standard Python-Markdown code blocks.

See <https://pythonhosted.org/Markdown/extensions/code_hilite.html>
for documentation.

Original code Copyright 2006-2008 [Waylan Limberg](http://achinghead.com/).

All changes Copyright 2008-2014 The Python Markdown Project

License: [BSD](http://www.opensource.org/licenses/bsd-license.php)
"""
from __future__ import absolute_import
from __future__ import unicode_literals
from markdown import Extension
from markdown.treeprocessors import Treeprocessor
from markdown import util as md_util
import copy
from collections import OrderedDict
import re
try:
    from pygments import highlight
    from pygments.lexers import get_lexer_by_name, guess_lexer
    from pygments.formatters import find_formatter_class
    HtmlFormatter = find_formatter_class('html')
    pygments = True
except ImportError:  # pragma: no cover
    pygments = False
try:
    from markdown.extensions.codehilite import CodeHiliteExtension
except Exception:  # pragma: no cover
    CodeHiliteExtension = None

CODE_WRAP = '<pre%s><code%s>%s</code></pre>'
CLASS_ATTR = ' class="%s"'
DEFAULT_CONFIG = {
    'use_pygments': [
        True,
        'Use Pygments to highlight code blocks. '
        'Disable if using a JavaScript library. '
        'Default: True'
    ],
    'guess_lang': [
        False,
        "Automatic language detection - Default: True"
    ],
    'css_class': [
        'highlight',
        "CSS class to apply to wrapper element."
    ],
    'pygments_style': [
        'default',
        'Pygments HTML Formatter Style '
        '(color scheme) - Default: default'
    ],
    'noclasses': [
        False,
        'Use inline styles instead of CSS classes - '
        'Default false'
    ],
    'linenums': [
        False,
        'Display line numbers in block code output (not inline) - Default: False'
    ],
    'extend_pygments_lang': [
        [],
        'Extend pygments language with special language entry - Default: {}'
    ]
}

multi_space = re.compile(r'(?<= ) {2,}')


def replace_nbsp(m):
    """Replace spaces with nbsp."""

    return '&nbsp;' * len(m.group(0))


if pygments:
    html_re = re.compile(
        r'''(?x)
        (?P<start><span [^<>]+>)|(?P<content>[^<>]+)|(?P<end></span>)
        '''
    )

    class InlineHtmlFormatter(HtmlFormatter):
        """Format the code blocks."""

        def wrap(self, source, outfile):
            """Overload wrap."""

            return self._wrap_code(source)

        def _wrap_code(self, source):
            """Return source, but do not wrap in inline <code> block."""

            yield 0, ''
            for i, t in source:
                yield i, t.strip()
            yield 0, ''

    class SublimeInlineHtmlFormatter(HtmlFormatter):
        """Format the code blocks."""

        def wrap(self, source, outfile):
            """Overload wrap."""

            return self._wrap_code(source)

        def _wrap_code(self, source):
            """
            Wrap the pygmented code.

            Sublime popups don't really support 'code', but since it doesn't
            hurt anything, we leave it in for the possiblity of future support.
            We get around the lack of proper 'code' support by converting any
            spaces after the intial space to nbsp.  We go ahead and convert tabs
            to 4 spaces as well.
            """

            yield 0, ''
            for i, t in source:
                text = ''
                matched = False
                for m in html_re.finditer(t):
                    matched = True
                    if m.group(1):
                        text += m.group(1)
                    elif m.group(3):
                        text += m.group(3)
                    else:
                        text += multi_space.sub(
                            replace_nbsp, m.group(2).replace('\t', ' ' * 4)
                        )
                if not matched:
                    text = multi_space.sub(
                        replace_nbsp, t.replace('\t', ' ' * 4)
                    )
                yield i, text
            yield 0, ''

    class SublimeBlockFormatter(HtmlFormatter):
        """Format the code blocks."""

        def wrap(self, source, outfile):
            """Overload wrap."""

            return self._wrap_code(source)

        def _wrap_code(self, source):
            """
            Wrap the pygmented code.

            Sublime popups don't really support 'pre', but since it doesn't
            hurt anything, we leave it in for the possiblity of future support.
            We get around the lack of proper 'pre' suppurt by converting any
            spaces after the intial space to nbsp.  We go ahead and convert tabs
            to 4 spaces as well.  We also manually inject line breaks.
            """

            yield 0, '<div class="%s"><pre>' % self.cssclass
            for i, t in source:
                text = ''
                matched = False
                for m in html_re.finditer(t):
                    matched = True
                    if m.group(1):
                        text += m.group(1)
                    elif m.group(3):
                        text += m.group(3)
                    else:
                        text += m.group(2).replace('\t', ' ' * 4).replace(' ', '&nbsp;')
                if not matched:
                    text = t.replace('\t', ' ' * 4).replace(' ', '&nbsp;')
                if i == 1:
                    # it's a line of formatted code
                    text += '<br>'
                yield i, text
            yield 0, '</pre></div>'

    class SublimeWrapBlockFormatter(HtmlFormatter):
        """Format the code blocks."""

        def wrap(self, source, outfile):
            """Overload wrap."""

            return self._wrap_code(source)

        def _wrap_code(self, source):
            """
            Wrap the pygmented code.

            Sublime popups don't really support 'pre', but since it doesn't
            hurt anything, we leave it in for the possiblity of future support.
            We get around the lack of proper 'pre' suppurt by converting any
            spaces after the intial space to nbsp.  We go ahead and convert tabs
            to 4 spaces as well.  We also manually inject line breaks.
            """

            yield 0, '<div class="%s"><pre>' % self.cssclass
            for i, t in source:
                text = ''
                matched = False
                for m in html_re.finditer(t):
                    matched = True
                    if m.group(1):
                        text += m.group(1)
                    elif m.group(3):
                        text += m.group(3)
                    else:
                        text += multi_space.sub(
                            replace_nbsp, m.group(2).replace('\t', ' ' * 4)
                        )
                if not matched:
                    text = multi_space.sub(
                        replace_nbsp, t.replace('\t', ' ' * 4)
                    )
                if i == 1:
                    # it's a line of formatted code
                    text += '<br>'
                yield i, text
            yield 0, '</pre></div>'


class Highlight(object):
    """Highlight class."""

    def __init__(
        self, guess_lang=True, pygments_style='default', use_pygments=True,
        noclasses=False, extend_pygments_lang=None, linenums=False
    ):
        """Initialize."""

        self.guess_lang = guess_lang
        self.pygments_style = pygments_style
        self.use_pygments = use_pygments
        self.noclasses = noclasses
        self.linenums = linenums
        self.linenums_style = 'table'
        self.sublime_hl = Highlight.sublime_hl
        self.sublime_wrap = Highlight.sublime_wrap

        if extend_pygments_lang is None:
            extend_pygments_lang = []
        self.extend_pygments_lang = {}
        for language in extend_pygments_lang:
            if isinstance(language, (dict, OrderedDict)):
                name = language.get('name')
                if name is not None and name not in self.extend_pygments_lang:
                    self.extend_pygments_lang[name] = [
                        language.get('lang'),
                        language.get('options', {})
                    ]

    @classmethod
    def set_sublime_vars(cls, sublime_hl, sublime_wrap):
        """Set Sublime_vars."""

        cls.sublime_hl = sublime_hl
        cls.sublime_wrap = sublime_wrap

    def get_extended_language(self, language):
        """Get extended language."""

        return self.extend_pygments_lang.get(language, (language, {}))

    def get_lexer(self, src, language):
        """Get the Pygments lexer."""

        if language:
            language, lexer_options = self.get_extended_language(language)
        else:
            lexer_options = {}

        # Try and get lexer by the name given.
        try:
            lexer = get_lexer_by_name(language, **lexer_options)
        except Exception:
            lexer = None

        if lexer is None:
            if self.guess_lang:
                lexer = guess_lexer(src)
            else:
                lexer = get_lexer_by_name('text')
        return lexer

    def escape(self, txt, code_wrap):
        """Basic html escaping."""

        txt = txt.replace('&', '&amp;')
        txt = txt.replace('<', '&lt;')
        txt = txt.replace('>', '&gt;')
        txt = txt.replace('"', '&quot;')
        # Special format for sublime.
        if code_wrap:
            txt = multi_space.sub(replace_nbsp, txt.replace('\t', ' ' * 4))
        else:
            txt = txt.replace('\t', '&nbsp;' * 4)
            txt = txt.replace(' ', '&nbsp;')
        return txt

    def highlight(
        self, src, language, css_class='highlight', hl_lines=None,
        linestart=-1, linestep=-1, linespecial=-1, inline=False
    ):
        """Highlight code."""

        # Convert with Pygments.
        if self.sublime_hl[0]:
            # Sublime highlight
            code = self.sublime_hl[1].syntax_highlight(
                src, language, inline=inline, no_wrap=inline, code_wrap=(not inline and self.sublime_wrap)
            )
            if inline:
                class_str = css_class
        elif pygments and self.use_pygments:
            # Setup language lexer.
            lexer = self.get_lexer(src, language)

            # Setup line specific settings.
            linenums = self.linenums_style if (self.linenums or linestart >= 0) and not inline > 0 else False
            if not linenums or linestep < 1:
                linestep = 1
            if not linenums or linestart < 1:
                linestart = 1
            if not linenums or linespecial < 0:
                linespecial = 0
            if hl_lines is None or inline:
                hl_lines = []

            # Setup formatter
            if inline:
                html_formatter = SublimeInlineHtmlFormatter
            elif self.sublime_wrap:
                html_formatter = SublimeWrapBlockFormatter
            else:
                html_formatter = SublimeBlockFormatter
            formatter = html_formatter(
                cssclass=css_class,
                linenos=linenums,
                linenostart=linestart,
                linenostep=linestep,
                linenospecial=linespecial,
                style=self.pygments_style,
                noclasses=self.noclasses,
                hl_lines=hl_lines
            )

            # Convert
            code = highlight(src, lexer, formatter)
            if inline:
                class_str = css_class
        elif inline:
            # Format inline code for a JavaScript Syntax Highlighter by specifying language.
            code = self.escape(src, True)
            classes = [css_class] if css_class else []
            if language:
                classes.append('language-%s' % language)
            class_str = ''
            if len(classes):
                class_str = ' '.join(classes)
        else:
            # Format block code for a JavaScript Syntax Highlighter by specifying language.
            classes = []
            linenums = self.linenums_style if (self.linenums or linestart >= 0) and not inline > 0 else False
            if language:
                classes.append('language-%s' % language)
            if linenums:
                classes.append('linenums')
            class_str = ''
            if classes:
                class_str = CLASS_ATTR % ' '.join(classes)
            higlight_class = (CLASS_ATTR % css_class) if css_class else ''
            code = CODE_WRAP % (higlight_class, class_str, self.escape(src, self.sublime_wrap))

        if inline:
            el = md_util.etree.Element('code', {'class': class_str} if class_str else {})
            el.text = code
            return el
        else:
            return code.strip()


def get_hl_settings(md):
    """Get the specified extension."""
    target = None

    for ext in md.registeredExtensions:
        if isinstance(ext, HighlightExtension):
            target = ext.getConfigs()
            break

    if target is None:
        for ext in md.registeredExtensions:
            if isinstance(ext, CodeHiliteExtension):
                target = ext.getConfigs()
                break

    if target is None:
        target = {}
        config_clone = copy.deepcopy(DEFAULT_CONFIG)
        for k, v in config_clone.items():
            target[k] = config_clone[k][0]
    return target


class HighlightTreeprocessor(Treeprocessor):
    """Highlight source code in code blocks."""

    def run(self, root):
        """Find code blocks and store in `htmlStash`."""

        blocks = root.iter('pre')
        for block in blocks:
            if len(block) == 1 and block[0].tag == 'code':
                code = Highlight(
                    guess_lang=self.config['guess_lang'],
                    pygments_style=self.config['pygments_style'],
                    use_pygments=self.config['use_pygments'],
                    noclasses=self.config['noclasses'],
                    linenums=self.config['linenums'],
                    extend_pygments_lang=self.config['extend_pygments_lang']
                )
                placeholder = self.markdown.htmlStash.store(
                    code.highlight(
                        block[0].text,
                        '',
                        self.config['css_class']
                    ),
                    safe=True
                )

                # Clear codeblock in etree instance
                block.clear()
                # Change to p element which will later
                # be removed when inserting raw html
                block.tag = 'p'
                block.text = placeholder


class HighlightExtension(Extension):
    """Configure highlight settings globally."""

    def __init__(self, *args, **kwargs):
        """Initialize."""

        self.config = copy.deepcopy(DEFAULT_CONFIG)
        super(HighlightExtension, self).__init__(*args, **kwargs)

    def extendMarkdown(self, md, md_globals):
        """Add support for code highlighting."""

        Highlight.set_sublime_vars(md.sublime_hl, md.sublime_wrap)
        ht = HighlightTreeprocessor(md)
        ht.config = self.getConfigs()
        md.treeprocessors.add("indent-highlight", ht, "<inline")
        md.registerExtension(self)


def makeExtension(*args, **kwargs):
    """Return extension."""

    return HighlightExtension(*args, **kwargs)
