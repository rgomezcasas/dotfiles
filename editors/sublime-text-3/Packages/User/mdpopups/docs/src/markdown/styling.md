# CSS Styling

## Syntax Highlighting

MdPopups has two syntax highlighting methods: the native Sublime syntax highlighter (default) and Pygments.  When developing a plugin, it is wise to test out both. The native Sublime Syntax Highlighter has most default languages mapped along with a few others.

### Sublime Syntax Highlighter

As previously mentioned, MdPopups uses the internal syntax highlighter to highlight your code.  The benefit here is that you get code highlighting in your popup that matches your current theme.  The highlighting ability is dependent upon what syntax packages you have installed in Sublime.  It also depends on whether that syntax is enabled and mapped to a language keyword.  Pull requests are welcome to expand and keep the [language mapping][language-map] updated.  You can also define in your `Preferences.sublime-settings` file additional mappings.  See [`mdpopups.sublime_user_lang_map`](./settings.md#mdpopupssublime_user_lang_map) for more info.

Most users prefer using syntax highlighting that matches their current color scheme. If you are a developer, it is recommended to issue a pull request to add missing languages you need to the mapping. Optionally you can also describe how users can map what they need locally.

### Pygments

In order to use Pygments, you have to disable `mdpopups.use_sublime_highlighter`. Pygments has a great variety of highlighters out of the box.  It also comes with a number of built-in color schemes that can be used. When enabling Pygments, you must specify the color scheme to use in your user CSS using the [CSS template filter](#css-templates).

```css+jinja
/* Syntax Highlighting */
{%- if var.use_pygments %}
  {%- if var.is_light %}
{{'default'|pygments}}
  {%- else %}
{{'native'|pygments}}
  {%- endif %}
{%- endif %}
```

You can also paste your own custom Pygments CSS directly into your User CSS, but you will have to format it to work properly.

Pygments defines special classes for each span that needs to be highlighted in a coding block. Pygments CSS classes are not only given syntax classes that are applied to each span, but usually an overall class is assigned to a `#!html <div>` wrapper as well.  For instance, a class for whitespace may look like this (where `#!css .highlight` is the div wrapper's class and `#!css .w` i the span's class):

```css
.highlight .w { color: #cccccc } /* Text.Whitespace */
```

If doing your own, the Pygments CSS should define a rule to highlight general background and foregrounds.

```css
.mdpopups .highlight { background-color: #f8f8f8; color: #4d4d4c }
```

??? settings "Full Pygments CSS Example"

    ```css
    .mdpopups .highlight { background-color: #f8f8f8; color: #4d4d4c }
    .mdpopups .highlight .c { color: #8e908c; font-style: italic } /* Comment */
    .mdpopups .highlight .err { color: #c82829 } /* Error */
    .mdpopups .highlight .k { color: #8959a8; font-weight: bold } /* Keyword */
    .mdpopups .highlight .l { color: #f5871f } /* Literal */
    .mdpopups .highlight .n { color: #4d4d4c } /* Name */
    .mdpopups .highlight .o { color: #3e999f } /* Operator */
    .mdpopups .highlight .p { color: #4d4d4c } /* Punctuation */
    .mdpopups .highlight .cm { color: #8e908c; font-style: italic } /* Comment.Multiline */
    .mdpopups .highlight .cp { color: #8e908c; font-weight: bold } /* Comment.Preproc */
    .mdpopups .highlight .c1 { color: #8e908c; font-style: italic } /* Comment.Single */
    .mdpopups .highlight .cs { color: #8e908c; font-style: italic } /* Comment.Special */
    .mdpopups .highlight .gd { color: #c82829 } /* Generic.Deleted */
    .mdpopups .highlight .ge { font-style: italic } /* Generic.Emph */
    .mdpopups .highlight .gh { color: #4d4d4c; font-weight: bold } /* Generic.Heading */
    .mdpopups .highlight .gi { color: #718c00 } /* Generic.Inserted */
    .mdpopups .highlight .gp { color: #8e908c; font-weight: bold } /* Generic.Prompt */
    .mdpopups .highlight .gs { font-weight: bold } /* Generic.Strong */
    .mdpopups .highlight .gu { color: #3e999f; font-weight: bold } /* Generic.Subheading */
    .mdpopups .highlight .kc { color: #8959a8; font-weight: bold } /* Keyword.Constant */
    .mdpopups .highlight .kd { color: #8959a8; font-weight: bold } /* Keyword.Declaration */
    .mdpopups .highlight .kn { color: #8959a8; font-weight: bold } /* Keyword.Namespace */
    .mdpopups .highlight .kp { color: #8959a8; font-weight: bold } /* Keyword.Pseudo */
    .mdpopups .highlight .kr { color: #8959a8; font-weight: bold } /* Keyword.Reserved */
    .mdpopups .highlight .kt { color: #eab700; font-weight: bold } /* Keyword.Type */
    .mdpopups .highlight .ld { color: #718c00 } /* Literal.Date */
    .mdpopups .highlight .m { color: #f5871f } /* Literal.Number */
    .mdpopups .highlight .s { color: #718c00 } /* Literal.String */
    .mdpopups .highlight .na { color: #4271ae } /* Name.Attribute */
    .mdpopups .highlight .nb { color: #4271ae } /* Name.Builtin */
    .mdpopups .highlight .nc { color: #c82829; font-weight: bold } /* Name.Class */
    .mdpopups .highlight .no { color: #c82829 } /* Name.Constant */
    .mdpopups .highlight .nd { color: #3e999f } /* Name.Decorator */
    .mdpopups .highlight .ni { color: #4d4d4c } /* Name.Entity */
    .mdpopups .highlight .ne { color: #c82829; font-weight: bold } /* Name.Exception */
    .mdpopups .highlight .nf { color: #4271ae; font-weight: bold } /* Name.Function */
    .mdpopups .highlight .nl { color: #4d4d4c } /* Name.Label */
    .mdpopups .highlight .nn { color: #4d4d4c } /* Name.Namespace */
    .mdpopups .highlight .nx { color: #4271ae } /* Name.Other */
    .mdpopups .highlight .py { color: #4d4d4c } /* Name.Property */
    .mdpopups .highlight .nt { color: #c82829 } /* Name.Tag */
    .mdpopups .highlight .nv { color: #c82829 } /* Name.Variable */
    .mdpopups .highlight .ow { color: #3e999f } /* Operator.Word */
    .mdpopups .highlight .w { color: #4d4d4c } /* Text.Whitespace */
    .mdpopups .highlight .mb { color: #f5871f } /* Literal.Number.Bin */
    .mdpopups .highlight .mf { color: #f5871f } /* Literal.Number.Float */
    .mdpopups .highlight .mh { color: #f5871f } /* Literal.Number.Hex */
    .mdpopups .highlight .mi { color: #f5871f } /* Literal.Number.Integer */
    .mdpopups .highlight .mo { color: #f5871f } /* Literal.Number.Oct */
    .mdpopups .highlight .sb { color: #718c00 } /* Literal.String.Backtick */
    .mdpopups .highlight .sc { color: #4d4d4c } /* Literal.String.Char */
    .mdpopups .highlight .sd { color: #8e908c } /* Literal.String.Doc */
    .mdpopups .highlight .s2 { color: #718c00 } /* Literal.String.Double */
    .mdpopups .highlight .se { color: #f5871f } /* Literal.String.Escape */
    .mdpopups .highlight .sh { color: #718c00 } /* Literal.String.Heredoc */
    .mdpopups .highlight .si { color: #f5871f } /* Literal.String.Interpol */
    .mdpopups .highlight .sx { color: #718c00 } /* Literal.String.Other */
    .mdpopups .highlight .sr { color: #718c00 } /* Literal.String.Regex */
    .mdpopups .highlight .s1 { color: #718c00 } /* Literal.String.Single */
    .mdpopups .highlight .ss { color: #718c00 } /* Literal.String.Symbol */
    .mdpopups .highlight .bp { color: #f5871f } /* Name.Builtin.Pseudo */
    .mdpopups .highlight .vc { color: #c82829 } /* Name.Variable.Class */
    .mdpopups .highlight .vg { color: #c82829 } /* Name.Variable.Global */
    .mdpopups .highlight .vi { color: #c82829 } /* Name.Variable.Instance */
    .mdpopups .highlight .il { color: #f5871f } /* Literal.Number.Integer.Long */
    ```

## CSS Styling

One reason MdPopups was created was to give consistent popups across plugins. Originally MdPopups forced its style so that plugins couldn't override the it. Later it was realized that plugins may have reasons to override certain things, and in recent versions, this constraint was relaxed. Despite changes since its inception, one thing has stayed the same: the user has the last say in how popups work. This is achieved by controlling which CSS gets loaded when.

```flow
st=>operation: Sublime CSS/Color Scheme CSS
md=>operation: MdPopups Default CSS
pg=>operation: Plugin CSS
us=>operation: User CSS

st->md->pg->us
```

Sublime first provides its CSS which includes some basic styling and CSS from color schemes. MdPopups provides its own default CSS that styles the common HTML tags and provides minimal colors. Plugins come next and extend the CSS with plugin specific CSS. The user's CSS is loaded last and can override anything.

All CSS is passed through the Jinja2 template engine where special filters can provide things like appropriate CSS that matches your color scheme for a specific scope, load additional CSS from another source, have condition logic for specific Sublime and/or MdPopups versions, or even provide CSS for specific color schemes.

Templates are used so that a user can easily tap into all the colors, color filters, and other useful logic to control their popups and phantoms in one place without having to hard code a specific CSS for a specific color scheme.

In general, it is encouraged to use Sublime CSS variables such as `--redish`, `--bluish`, etc. to get appropriate colors for a given theme. Sublime calculates these colors from the color scheme directly. If it calculates a color that is not quite right, you can always request that the color scheme in question redefines that variable with an appropriate color.  Or you, as the user, can define one in your user CSS. You can read more about `minihtml` and it's features in the [`minihtml` documentation][minihtml].

MdPopups also provides its own CSS variables that can be overridden by a user:

Variable                            | Description
----------------------------------- | -----------
`--mdpopups-font-mono`              | Monospace font stack for elements that require monospace (like code blocks).
`--mdpopups-hr`                     | `#!html <hr>` tag color.
`--mdpopups-admon-fg`               | General admonition foreground/text color.
`--mdpopups-admon-info-fg`          | Info admonition foreground/text color.
`--mdpopups-admon-error-fg`         | Error admonition foreground/text color.
`--mdpopups-admon-success-fg`       | Success admonition foreground/text color.
`--mdpopups-admon-warning-fg`       | Warning admonition foreground/text color.
`--mdpopups-admon-title-fg`         | General admonition title foreground/text color.
`--mdpopups-admon-info-title-fg`    | Info admonition title foreground/text color.
`--mdpopups-admon-error-title-fg`   | Error admonition title foreground/text color.
`--mdpopups-admon-success-title-fg` | Success admonition title foreground/text color.
`--mdpopups-admon-warning-title-fg` | Warning admonition title foreground/text color.
`--mdpopups-admon-bg`               | General admonition background color.
`--mdpopups-admon-info-bg`          | Info admonition background color.
`--mdpopups-admon-error-bg`         | Error admonition background color.
`--mdpopups-admon-warning-bg`       | Warning admonition background color.
`--mdpopups-admon-success-bg`       | Success admonition background color.
`--mdpopups-admon-accent`           | General admonition accent color (border/title bar background).
`--mdpopups-admon-info-accent`      | Info admonition accent color (border/title bar background).
`--mdpopups-admon-error-accent`     | Error admonition accent color (border/title bar background).
`--mdpopups-admon-success-accent`   | Success admonition accent color (border/title bar background).
`--mdpopups-admon-warning-accent`   | Warning admonition accent color (border/title bar background).
`--mdpopups-kbd-fg`                 | `#!html <kbd>` foreground/text color.
`--mdpopups-kbd-bg`                 | `#!html <kbd>` background color.
`--mdpopups-kbd-border`             | `#!html <kbd>` border color.
`--mdpopups-hl-border`              | Inline and block code border color.
`--mdpopups-hl-bg`                  | Inline and block code background color.

## CSS Templates

All variables and filters provided by default *only* apply to the CSS, not the markdown or HTML content. The default provided variables are namespaced under `var`.

The Markdown and HTML content only receives the variables that are given via `template_vars` parameters and any options via the `template_env_options`; user defined variables will get passed to the CSS, but not the options. User defined variables will be namespaced under `plugin`.

### CSS Filter

With the template environment, colors and style from the current Sublime color scheme can be accessed and manipulated.  Access to the Sublime color scheme styles CSS is done via the `css` filter.

`css`
: 
    Retrieves the style for a specific Sublime scope from a Sublime color scheme.  By specifying either `foreground`, `background`, or any scope (complexity doesn't really matter) and feeding it into the `css` filter, all the related styling of the specified scope will be inserted as CSS into the CSS document.

    **Example**:

    This:

    ```css+jinja
    h1, h2, h3, h4, h5, h6 { {{'comment'|css}} }
    ```

    Might become this:

    ```css+jinja
    h1, h2, h3, h4, h5, h6 { color: #888888; font-style: italic; }
    ```

    Notice that the format of insertion is `key: value; `.  You do not need a semicolon after as the CSS lines are all formatted properly with semicolons.  If you add one, you may get multiple semicolons which *may* break the CSS.

    If you need to get at a specific CSS attribute, you can specify its name in the `css` filter (available attributes are `color`, `background-color`, `font-style`, and `font-weight`).

    This:

    ```css+jinja
    h1, h2, h3, h4, h5, h6 { {{'.comment'|css('color')}} }
    ```

    Would then only include the color:

    ```css+jinja
    h1, h2, h3, h4, h5, h6 { color: #888888; }
    ```

    In general, a foreground color is always returned, but by default, a background color is only returned if one is explicitly defined. To always get a background (which most likely will default to the overall scheme background), you can set the additional `explicit_background` parameter to `#!py False`.

    ```css+jinja
    /* If `keyword.operator` is not explicitly used, fallback to `.keyword` */
    h1, h2, h3, h4, h5, h6 { {{'keyword.operator'|css('color', False)}} }
    ```

### Color Filters

MdPopups also provides a number of color filters within the template environment that can manipulate the CSS colors returned from the `css` filter (or equivalent formatted CSS). These filters will strip out the color and modify it, and return the appropriate CSS.  To manipulate a color value directly, you can use Sublime's built in color blending.  In most cases, it is advised to use Sublime's color blending functionality, but these are available to aid those who wish to access and manipulate CSS of scopes directly.  See Sublime's [`minihtml` documentation][minihtml] for more info.

Even though Sublime generally provides contrast to popups, lets pretend you had a popup that was the same color as the view window and it was difficult to see where the popup starts and ends.  You can take the color schemes background and apply a brightness filter to it allowing you now see the popup clearly.

Here we can make the background of the popup darker:

```css+jinja
.mdpopups div.myplugin { {{'.background'|css('background-color')|brightness(0.9)}} }
```

Color filters take a single color attribute of the form `key: value;`.  So when feeding the color template filters your CSS via the `css` filter, you should specify the color attribute (`background-color` or `color`) that you wish to apply the filter to; it may be difficult to tell how many attributes `css` could return without explicitly specifying attribute.  Color filters only take either `color` or `background-color` attributes.

Filters can be chained if more intensity is needed (as some filters may clamp the value in one call), or if you want to apply multiple filters.  These are all the available filters:

`foreground` and `background`
: 

    If desired, you can convert a foreground color to a background color or vice versa.  To convert to a foreground color, you can use the `foreground` filter.  To convert to a background color, you can use the `background` filter. Remember, this is augmenting the CSS returned by the `css` filter, you can't just give it a color. 


    To convert a background to a foreground.

    **Example**:
    ```css+jinja
    body { {{'.background'|css('background-color')|foreground}} }
    ```

    To convert a foreground to a background.

    **Example**:
    ```css+jinja
    body { {{'.foreground'|css('color')|background}} }
    ```

`brightness`
: 
    Shifts brightness either dark or lighter. Brightness is relative to 1 where 1 means no change.  Accepted values are floats that are greater than 0.  Ranges are clamped between 0 and 2.

    **Example - Darken**:
    ```css+jinja
    body { {{'.background'|css('background-color')|brightness(0.9)}} }
    ```

    **Example - Lighten**:
    ```css+jinja
    body { {{'.background'|css('background-color')|brightness(1.1)}} }
    ```

`contrast`
: 
    Increases/decreases the contrast.  Contrast is relative to 1 where 1 means no change.  Accepted values are floats that are greater than 0.  Ranges are clamped between 0 and 2.

    **Example - Decrease contrast**:
    ```css+jinja
    body { {{'.background'|css('background-color')|contrast(0.9)}} }
    ```

    **Example - Increase contrast**:
    ```css+jinja
    body { {{'.background'|css('background-color')|contrast(1.1)}} }
    ```

`saturation`
: 
    Shifts the saturation either to right (saturate) or the left (desaturate).  Saturation is relative to 1 where 1 means no change.  Accepted values are floats that are greater than 0.  Ranges are clamped between 0 and 2.

    **Example - Desaturate**:
    ```css+jinja
    body { {{'.background'|css('background-color')|saturation(0.9)}} }
    ```

    **Example - Saturate**:
    ```css+jinja
    body { {{'.background'|css('background-color')|saturation(1.1)}} }
    ```

`grayscale`
: 
    Filters all colors to a grayish tone.

    **Example**:
    ```css+jinja
    body { {{'.background'|css('background-color')|grayscale}} }
    ```

`sepia`
: 
    Filters all colors to a sepia tone.

    **Example**:
    ```css+jinja
    body { {{'.background'|css('background-color')|sepia}} }
    ```

`invert`
: 
    Inverts a color.

    **Example**:
    ```css+jinja
    body { {{'.background'|css('background-color')|invert}} }
    ```

`colorize`
: 
    Filters all colors to a shade of the specified hue.  Think grayscale, but instead of gray, you define a non-gray hue.  The values are angular dimensions starting at the red primary at 0°, passing through the green primary at 120° and the blue primary at 240°, and then wrapping back to red at 360°.

    **Example**:
    ```css+jinja
    body { {{'.background'|css('background-color')|colorize(30)}} }
    ```

`hue`
: 
    Shifts the current hue either to the left or right.  The values are angular dimensions starting at the red primary at 0°, passing through the green primary at 120° and the blue primary at 240°, and then wrapping back to red at 360°.  Values can either be negative to shift left or positive to shift the hue to the right.

    **Example - Left Shift**:
    ```css+jinja
    body { {{'.background'|css('background-color')|hue(-30)}} }
    ```

    **Example - Left Right**:
    ```css+jinja
    body { {{'.background'|css('background-color')|hue(30)}} }
    ```

`fade`
: 
    Fades a color. Essentially it is like apply transparency to the color allowing the color schemes base background color to show through.

    **Example - Fade 50%**:
    ```css+jinja
    body { {{'.foreground'|css('color')|fade(0.5)}} }
    ```

### Include CSS Filter

The template environment allows for retrieving CSS resources from Sublime Packages or built-in Pygments CSS from the Pygments library.

`getcss`
: 
    Retrieve a CSS file from Sublime's `Packages` folder.  CSS retrieved in this manner can include template variables and filters.

    **Example**:
    ```css+jinja
    {{'Packages/User/aprosopo-dark.css'|getcss}}
    ```

`pygments`
: 
    Retrieve a built-in Pygments color scheme.

    **Example**:
    ```css+jinja
    {{'native'|pygments}}
    ```

## Template Variables

The template environment provides a couple of variables that can be used to conditionally alter the CSS output.  Variables are found under `var`.

`var.sublime_version`
: 
    `sublime_version` contains the current Sublime Text version.  This allows you conditionally handle CSS features that are specific to a Sublime Text version.

    **Example**
    ```css+jinja
    {% if var.sublime_version >= 3119 %}
    padding: 0.2rem;
    {% else %}
    padding: 0.2em;
    {% endif %}
    ```

`var.mdpopups_version`
: 
    `mdpopups_version` contains the current MdPopups version which you can use in your CSS templates if needed.

    **Example**
    ```css+jinja
    {% if var.mdpopups_version >= (1, 9, 0) %}
    /* do something */
    {% else %}
    /* do something else */
    {% endif %}
    ```

`var.default_style`
: 
    Flag specifying whether default styling is being used.  See [`mdpopups.default_style`](./settings.md#mdpopupsdefault_style) for how to control this flag.  And see [`default.css`][default-css] for an example of how it is used.

`var.is_dark` and `var.is_light`
: 
    `is_dark` checks if the color scheme is a dark color scheme.  Alternatively, `is_light` checks if the color scheme is a light color scheme.

    **Example**:
    ```css+jinja
    {% if var.is_light %}
    html{ {{'.background'|css('background-color')|brightness(0.9)}} }
    {% else %}
    html{ {{'.background'|css('background-color')|brightness(1.1)}} }
    {% endif %}
    ```

`var.is_popup` and `var.is_phantom`
: 
    `is_phantom` checks if the current CSS is for a phantom instead of a popup.  Alternatively, `is_popup` checks if the current use of the CSS is for a popup.

    **Example**:
    ```css+jinja
    {% if var.is_phantom %}
    html{ {{'.background'|css('background-color')|brightness(0.9)}} }
    {% else %}
    html{ {{'.background'|css('background-color')|brightness(1.1)}} }
    {% endif %}
    ```

`var.use_pygments`
: 
    Checks if the Pygments syntax highlighter is being used.

    **Example**:
    ```css+jinja
    {% if var.use_pygments %}
    {% if var.is_light %}
    {{'default'|pygments}}
    {% else %}
    {{'native'|pygments}}
    {% endif %}
    {% endif %}
    ```

`var.color_scheme`
: 
    Retrieves the current color schemes name.

    **Example**:
    ```css+jinja
    {% if (
        var.color_scheme in (
            'Packages/Theme - Aprosopo/Tomorrow-Night-Eighties-Stormy.tmTheme',
            'Packages/Theme - Aprosopo/Tomorrow-Morning.tmTheme',
        )
    ) %}
    a { {{'.keyword.operator'|css('color')}} }
    {% else %}
    a { {{'.support.function'|css('color')}} }
    {% endif %}
    ```

--8<--
refs.md

uml.md
--8<-- 
