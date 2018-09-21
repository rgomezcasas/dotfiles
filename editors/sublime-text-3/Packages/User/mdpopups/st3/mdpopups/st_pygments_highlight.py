"""
Sublime code highlighting for tooltips.

Licensed under MIT
Copyright (c) 2015 - 2016 Isaac Muse <isaacmuse@gmail.com>
"""
import re
from pygments import highlight
from pygments.lexers import get_lexer_by_name, guess_lexer
from pygments.formatters import find_formatter_class
HtmlFormatter = find_formatter_class('html')
pygments = True

html_re = re.compile(
    r'''(?x)
    (?P<start><span [^<>]+>)|(?P<content>[^<>]+)|(?P<end></span>)
    '''
)

multi_space = re.compile(r'(?<= ) {2,}')


def replace_nbsp(m):
    """Replace spaces with nbsp."""

    return '&nbsp;' * len(m.group(0))


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
                    ).replace('&#39;', '\'').replace('&quot;', '"')
            if not matched:
                text = multi_space.sub(
                    replace_nbsp, t.replace('\t', ' ' * 4)
                ).replace('&#39;', '\'').replace('&quot;', '"')
            if i == 1:
                # it's a line of formatted code
                text += '<br>'
            yield i, text
        yield 0, '</pre></div>'


class SublimeBlockFormatter(HtmlFormatter):
    """Format the code blocks with wrapping."""

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
                    text += m.group(2).replace(
                        '\t', ' ' * 4
                    ).replace(' ', '&nbsp;').replace('&#39;', '\'').replace('&quot;', '"')
            if not matched:
                text = t.replace('\t', ' ' * 4).replace(
                    ' ', '&nbsp;'
                ).replace('&#39;', '\'').replace('&quot;', '"')
            if i == 1:
                # it's a line of formatted code
                text += '<br>'
            yield i, text
        yield 0, '</pre></div>'


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

        yield 0, '<code class="%s">' % self.cssclass
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
                    ).replace('&#39;', '\'').replace('&quot;', '"')
            if not matched:
                text = multi_space.sub(
                    replace_nbsp, t.replace('\t', ' ' * 4)
                ).replace('&#39;', '\'').replace('&quot;', '"')
            yield i, text
        yield 0, '</code>'


def syntax_hl(src, lang=None, guess_lang=False, inline=False, code_wrap=False):
    """Highlight."""

    css_class = 'highlight'

    src = src.strip('\n')

    try:
        lexer = get_lexer_by_name(lang)
    except ValueError:
        try:
            if guess_lang:
                lexer = guess_lexer(src)
            else:
                lexer = get_lexer_by_name('text')
        except ValueError:
            lexer = get_lexer_by_name('text')
    if inline:
        formatter = SublimeInlineHtmlFormatter(
            cssclass=css_class
        )
    elif code_wrap:
        formatter = SublimeWrapBlockFormatter(
            cssclass=css_class
        )
    else:
        formatter = SublimeBlockFormatter(
            cssclass=css_class
        )
    return highlight(src, lexer, formatter)
