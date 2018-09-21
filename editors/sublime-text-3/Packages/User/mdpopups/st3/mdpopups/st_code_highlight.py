"""
SublimeHighlight.

Licensed under MIT.

Copyright (C) 2012  Andrew Gibson <agibsonsw@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------

Original code has been heavily modifed by Isaac Muse <isaacmuse@gmail.com> for the ExportHtml project.
"""
import sublime
import re
from .st_color_scheme_matcher import ColorSchemeMatcher
from .st_mapping import lang_map

NEW_SCHEMES = int(sublime.version()) >= 3150

INLINE_BODY_START = '<code class="inline-highlight">'
BODY_START = '<div class="highlight"><pre>'
LINE = '%(code)s<br>'
INLINE_LINE = '%(code)s'
CODE = '<span style="color: %(color)s;%(style)s">%(content)s</span>'
CODEBG = '<span style="background-color: %(highlight)s; color: %(color)s;%(style)s">%(content)s</span>'
BODY_END = '</pre></div>\n'
INLINE_BODY_END = '</code>'
ST_LANGUAGES = ('.sublime-syntax', '.tmLanguage')


class SublimeHighlight(object):
    """SublimeHighlight."""

    def __init__(self, scheme):
        """Initialization."""

        self.view = None

        if not NEW_SCHEMES:
            self.csm = ColorSchemeMatcher(scheme)

            self.fground = self.csm.get_special_color('foreground', simulate_transparency=True)
            self.bground = self.csm.get_special_color('background', simulate_transparency=True)

    def setup(self, **kwargs):
        """Get get general document preferences from sublime preferences."""

        self.tab_size = 4
        self.size = self.view.size()
        self.pt = 0
        self.end = 0
        self.curr_row = 0
        # self.ebground = self.bground

    def setup_print_block(self, curr_sel, multi=False):
        """Determine start and end points and whether to parse whole file or selection."""

        self.size = self.view.size()
        self.pt = 0
        self.end = 1
        self.curr_row = 1
        self.start_line = self.curr_row

    def print_line(self, line, num):
        """Print the line."""

        html_line = (INLINE_LINE if self.inline else LINE) % {
            "code": line,
        }

        return html_line

    def convert_view_to_html(self):
        """Begin conversion of the view to HTML."""

        for line in self.view.split_by_newlines(sublime.Region(self.pt, self.size)):
            self.char_count = 0
            self.size = line.end()
            empty = not bool(line.size())
            line = self.convert_line_to_html(empty)
            self.html.append(self.print_line(line, self.curr_row))
            self.curr_row += 1

    def html_encode(self, text):
        """Format text to HTML."""

        new_text = []
        for c in text:
            if c == '\t':
                tab_size = self.tab_size - self.char_count % self.tab_size
                new_text.append(' ' * tab_size)
                self.char_count += tab_size
            elif c == '&':
                new_text.append('&amp;')
                self.char_count += 1
            elif c == '>':
                new_text.append('&gt;')
                self.char_count += 1
            elif c == '<':
                new_text.append('&lt;')
                self.char_count += 1
            elif c != '\n':
                new_text.append(c)
                self.char_count += 1

        return re.sub(
            (r'(?!\s($|\S))\s' if self.inline or self.code_wrap else r'\s'),
            '&nbsp;',
            ''.join(new_text)
        )

    def format_text(self, line, text, color, bgcolor, style, empty, annotate=False):
        """Format the text."""

        if empty:
            text = '&nbsp;'

        css_style = ''
        if style and 'bold' in style:
            css_style += ' font-weight: bold;'
        if style and 'italic' in style:
            css_style += ' font-style: italic;'

        if bgcolor is None:
            code = CODE % {
                "color": color, "content": text, "style": css_style
            }
        else:
            code = CODEBG % {
                "highlight": bgcolor, "color": color, "content": text, "style": css_style
            }

        line.append(code)

    def convert_line_to_html(self, empty):
        """Convert the line to its HTML representation."""

        line = []
        do_highlight = self.curr_row in self.hl_lines

        while self.end <= self.size:
            # Get text of like scope
            scope_name = self.view.scope_name(self.pt)
            while self.view.scope_name(self.end) == scope_name and self.end < self.size:
                self.end += 1
            if NEW_SCHEMES:
                color_match = self.view.style_for_scope(scope_name)
                color = color_match.get('foreground', self.fground)
                bgcolor = color_match.get('background')
                style = []
                if color_match['bold']:
                    style.append('bold')
                if color_match['italic']:
                    style.append('italic')
                if do_highlight:
                    sfg = color_match.get('selection_forground', self.defaults.get('selection_forground'))
                    if sfg:
                        color = sfg
                    bgcolor = color_match.get('selection', '#0000FF')
            else:
                color_match = self.csm.guess_color(scope_name, selected=do_highlight, explicit_background=True)
                color = color_match.fg_simulated
                bgcolor = color_match.bg_simulated
                style = color_match.style.split(' ')

            region = sublime.Region(self.pt, self.end)
            # Normal text formatting
            tidied_text = self.html_encode(self.view.substr(region))
            self.format_text(line, tidied_text, color, bgcolor, style, empty)

            # Continue walking through line
            self.pt = self.end
            self.end = self.pt + 1

        # # Get the color for the space at the end of a line
        # if self.end < self.view.size():
        #     end_key = self.view.scope_name(self.pt)
        #     if NEW_SCHEMES:
        #         color_match = self.view.style_for_scope(end_key)
        #         self.ebground = color_match.get('background')
        #     else:
        #         color_match = self.csm.guess_color(end_key, explicit_background=True)
        #         self.ebground = color_match.bg_simulated

        # Join line segments
        return ''.join(line)

    def write_body(self):
        """Write the body of the HTML."""

        processed_rows = ""
        if not self.no_wrap:
            self.html.append(INLINE_BODY_START if self.inline else BODY_START)

        # Convert view to HTML
        self.setup_print_block(self.view.sel()[0])
        processed_rows += "[" + str(self.curr_row) + ","
        self.convert_view_to_html()
        processed_rows += str(self.curr_row) + "],"

        # Write empty line to allow copying of last line and line number without issue
        if not self.no_wrap:
            self.html.append(INLINE_BODY_END if self.inline else BODY_END)

    def set_view(self, src, lang):
        """Setup view for conversion."""

        # Get the output panel
        self.view = sublime.active_window().create_output_panel('mdpopups', unlisted=True)
        # Let all plugins no to leave this view alone
        self.view.settings().set('is_widget', True)
        # Don't translate anything.
        self.view.settings().set("translate_tabs_to_spaces", False)
        # Don't mess with my indenting Sublime!
        self.view.settings().set("auto_indent", False)
        # Insert into the view
        self.view.run_command('insert', {'characters': src})
        # Setup the proper syntax
        lang = lang.lower()
        user_map = sublime.load_settings('Preferences.sublime-settings').get('mdpopups.sublime_user_lang_map', {})
        keys = set(list(user_map.keys()) + list(lang_map.keys()))
        loaded = False
        for key in keys:
            v = lang_map.get(key, (tuple(), tuple()))
            user_v = user_map.get(key, (tuple(), tuple()))
            if lang in (tuple(user_v[0]) + v[0]):
                for l in (tuple(user_v[1]) + v[1]):
                    for ext in ST_LANGUAGES:
                        sytnax_file = 'Packages/%s%s' % (l, ext)
                        try:
                            sublime.load_binary_resource(sytnax_file)
                        except Exception:
                            continue
                        self.view.set_syntax_file(sytnax_file)
                        loaded = True
                        break
                    if loaded:
                        break
            if loaded:
                break
        if not loaded:
            # Default to plain text
            for ext in ST_LANGUAGES:
                # Just in case text one day switches to 'sublime-syntax'
                sytnax_file = 'Packages/Plain text%s' % ext
                try:
                    sublime.load_binary_resource(sytnax_file)
                except Exception:
                    continue
                self.view.set_syntax_file(sytnax_file)

    def syntax_highlight(self, src, lang, hl_lines=[], inline=False, no_wrap=False, code_wrap=False):
        """Syntax Highlight."""

        self.set_view(src, 'text' if not lang else lang)
        if NEW_SCHEMES:
            self.defaults = self.view.style()
            self.fground = self.defaults.get('foreground', '#000000')
            self.bground = self.defaults.get('background', '#FFFFFF')
        self.inline = inline
        self.hl_lines = hl_lines
        self.no_wrap = no_wrap
        self.code_wrap = code_wrap
        self.setup()
        self.html = []
        self.write_body()
        return ''.join(self.html)
