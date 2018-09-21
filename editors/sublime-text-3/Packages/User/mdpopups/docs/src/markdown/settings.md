# User Settings

## Configuring MdPopups

All settings for MdPopups are placed in Sublime's `Preferences.sublime-settings`.  They are applied globally and to all popups and phantoms.

## `mdpopups.debug`

Turns on debug mode.  This will dump out all sorts of info to the console.  Content before parsing to HTML, final HTML output, traceback from failures, etc..  This is more useful for plugin developers.  It works by specifying an error level.  `0` or `false` would disable it.  1 would trigger on errors. 2 would trigger on warnings and any level below.  3 would be general info (like HTML output) and any level below.

```js
    "mdpopups.debug": 1,
```

## `mdpopups.disable`

Global kill switch to prevent popups (created by MdPopups) from appearing.

```js
    "mdpopups.disable": true,
```

## `mdpopups.cache_refresh_time`

Control how long a CSS theme file will be in the cache before being refreshed.  Value should be a positive integer greater than 0.  Units are in minutes.  Default is 30.

```js
    "mdpopups.cache_refresh_time": 30,
```

## `mdpopups.cache_limit`

Control how many CSS theme files will be kept in cache at any given time.  Value should be a positive integer greater than or equal to 0.

```js
    "mdpopups.cache_limit": 10
```

## `mdpopups.use_sublime_highlighter`

Controls whether the Pygments or the native Sublime syntax highlighter is used for code highlighting.  This affects code highlighting in Markdown conversion and when code is directly processed using [syntax_highlight](./api.md#syntax-highlight). To learn more about the syntax highlighter see [Syntax Highlighting](./styling.md#syntax-highlighting).

```js
    "mdpopups.use_sublime_highlighter": true
```

## `mdpopups.user_css`

Overrides the default CSS and/or CSS of a plugin.  Value should be a relative path pointing to the CSS file: `Packages/User/my_custom_theme.css`.  Slashes should be forward slashes. By default, it will point to `Packages/User/mdpopups.css`.  User CSS overrides **all** CSS as it is the last to be processed.

```js
    "mdpopups.user_css": "Packages/User/mdpopups.css"
```

## `mdpopups.default_style`

Controls whether MdPopups' default styling (contained in [`default.css`][default-css]) will be applied or not.

## `mdpopups.sublime_user_lang_map`

This setting is for the Sublime Syntax Highlighter and allows the mapping of personal Sublime syntax languages which are not yet included, or will not be included, in the official mapping table.  You can either define your own new entry, or use the same language name of an existing entry to extend the language `mapping_alias` or syntax languages.  When extending, the user mappings will be cycled through first.

```js
    'mdpopups.sublime_user_lang_map': {
        "language": (('mapping_alias',), ('MyPackage/MySyntaxLanguage'))
    }
```

**Example**:
```js
'mdpopups.sublime_user_lang_map': {
    'javascript': (('javascript', 'js'), ('JavaScript/JavaScript', 'JavaScriptNext - ES6 Syntax/JavaScriptNext'))
}
```

For a list of all currently supported syntax mappings, see the official [mapping file][language-map].

!!! tip "Tip"
    When submitting new languages to the mapping table, it is encouraged to pick key names that correspond to what is used in Pygments so a User can switch between Pygments' and Sublime's syntax highlighter and still get highlighting.

--8<-- "refs.md"
