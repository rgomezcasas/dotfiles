# API

## Dependencies

Your plugin should include the Package Control dependencies listed below. Please read about Package Control's [dependencies][pc-dependencies] to learn more.

```js
{
    "*": {
        ">=3124": [
            "pygments",
            "python-markdown",
            "mdpopups",
            "python-jinja2",
            "markupsafe",
            "pymdownx",
            "pyyaml"
        ]
    }
}
```

Check out @facelessuser/mdpopup_test as an example. Clone it into `Packages/mdpopup_test`, run `Package Control: Satisfy dependencies`, and then restart Sublime. You should be able to then run the command `Mdpopups: Test` to see an example popup or phantom.  Feel free to edit it to learn more.

## Markdown Support

MdPopups uses @Python-Markdown/markdown to parse Markdown and transform it into a Sublime popup or phantom. The Markdown environment supports basic Markdown syntax, but also includes a number of specialty extensions to enhance and extend the Markdown environment.

Due to the `minihtml` environment that Sublime uses, the type of tags and CSS that can be used are a bit limited. MdPopups provides a CSS that includes most of the common supported tags that can be used. Then few specific extensions (that work well within the `minihtml` environment) have been selected to provide support for a some additional useful features.

Prior to version 2.0.0, the default extensions and extension configurations were locked down, but starting with 2.1.0, this restriction has been mostly removed. Not all Python Markdown extensions and extension options are compatible with Sublime's `minihtml` environment, and extensions like `markdown.extensions.extra` can include some extensions that are not compatible, but there are a number of additional extension and extension options that can be used beyond what is provided by default. In general, it is recommended to include each plugin individual on a case by case basis and disable features that aren't compatible.

Below we will touch on the specific extensions used by default which are known to work in the Sublime `minihtml` environment. If you are on version 2.1.0+, read on in [Frontmatter](#frontmatter) to learn how to customize extensions.

### Extensions

These three extensions are setup and configured automatically and should not be configured manually. Also, do not try to use `markdown.extensions.codehilite` or `markdown.extensions.fenced_code` as the following extensions have been specifically altered to output Sublime syntax highlighting properly and will clash with `markdown.extensions.codehilite` and `markdown.extensions.fenced_code`.

- `mdpopups.mdx.highlight` ( a modified version [`pymdownx.highlight`][highlight] for Sublime Text highlighting) controls and configures the highlighting of code blocks.

- `mdpopups.mdx.superfences` (a modified version [`pymdownx.superfences`][superfences] for Sublime Text highlighting) that provides support for nested fenced blocks.

- `mdpopups.mdx.inlinehilite` (a modified version of [`pymdownx.inlinehilite`] for Sublime Text highlighting) allows for inline code highlighting: `` `#!py3thon import module` `` --> `#!py3thon import module`. Please don't use this version.

These extensions are provided by Python Markdown:

- [`markdown.extensions.attr_list`][attr_list] allows you to add HTML attributes to block and inline elements easily.

- [`markdown.extensions.nl2br`][nl2br] turns new lines into `#!html <br>` tags.

- [`markdown.extensions.def_list`][def_list] adds support for definition lists.

- [`markdown.extensions.admonition`][admonition] provides admonition blocks.

These are 3rd party extensions provided by PyMdown Extensions:

- [`pymdownx.betterem`][betterem] is an extension that aims to improve upon emphasis support in Python Markdown. MdPopups leaves it configured in its default state where underscores are handled intelligently: `_handled_intelligently_` --> _handled_intelligently_ and asterisks can be used to do mid word emphasis: `em*pha*sis` --> em*pha*sis.

- [`pymdownx.magiclink`][magiclink] auto links HTML and email links.  In `2.1.0`+, it also allows the shortening of common repository pull request, issue, and commit links (if configured).

- [`pymdownx.extrarawhtml`][extrarawhtml] allows you to add `markdown="1"` to raw, block HTML elements to allow content under them to be parsed with Python markdown (inline tags should already have their content parsed).  This module is exposing *just* this functionality from the [Python Markdown's Extra extension](https://pythonhosted.org/Markdown/extensions/extra.html#nested-markdown-inside-html-blocks) as the feature could not be enabled without including all of the `Extra` extensions other features.  You can read the Python Markdown's Extra extension documentation to learn more about this feature.

## Frontmatter

Frontmatter can be used to configure content in 2.1.0+. The frontmatter must be specified, starting on the first line of the content, before the Markdown.  The frontmatter content should be in YAML syntax and should come between the YAML markers: `---`.

```yaml
---
# yaml content
---
```

Optionally the content can use the ending `...` as shown below:

```yaml
---
# yaml content
...
```

At the base level, the YAML content is a hash table containing key value pairs.

```yaml
---
key1: value1
key2: value2
...
```

### Enable Code Wrapping

The `allow_code_wrap` setting allows block code tags to have their content wrapped. If disabled (the default), code content will not wrap lines.

```yaml
---
allow_code_wrap: true
...
```

### Custom Fences

The included `mdpopups.mdx.superfences` has an option that allows for custom fences. Custom fences are a convenient way to add support for special block content such as UML diagrams. Since configuring `mdpopups.mdx.superfences` is not allowed directly, you can setup your own custom fences via a separate `custom_fences` option. See the original SuperFences' [Custom Fences][custom-fences] documentation to learn more.

```yaml
---
custom_fences:
- name: uml
  class: uml
  format: !!python/name:mdpopup_test.plantuml.uml_format
...
```

Checkout @facelessuser/mdpopup_test to see the UML example above in action.

### Configure Markdown Extensions

Custom extension configurations are specified under the `markdown_extensions` key whose value is an array of extensions. Each extension is specified as a string.  If you have specific settings to configure for an extension, simply make that array entry a dictionary where the key name is the extension name, and value is a hash table with all the settings.  The default configuration is below.

```yaml
---
markdown_extensions:
- markdown.extensions.admonition
- markdown.extensions.attr_list
- markdown.extensions.def_list
- markdown.extensions.nl2br
- pymdownx.betterem
- pymdownx.magiclink
- pymdownx.extrarawhtml
...
```

Notice that `mdpopups.mdx.highlight`, `mdpopups.mdx.superfences`, and `mdpopups.mdx.inlinehilite` are not shown here as they cannot be set directly and are handled by automatically by MdPopups.

Let's say we wanted to keep the default extensions, but we wanted to enable `pymdown.magiclink`'s repository URL shortening and add and configure `pymdownx.keys`, `pymdownx.escapeall`, `pymdownx.smartsymbols`, and `markdown.extensions.smarty`. We must specify the full configuration we would like. We will use the base default settings outlined above, adding our new options and extensions.

```yaml
---
markdown_extensions:
- markdown.extensions.admonition
- markdown.extensions.attr_list
- markdown.extensions.def_list
- markdown.extensions.nl2br
- markdown.extensions.smarty:
    smart_quotes: false
- pymdownx.betterem
- pymdownx.magiclink:
    base_repo_url: https://github.com/facelessuser/sublime-markdown-popups
    repo_url_shortener: true
- pymdownx.extrarawhtml
- pymdownx.keys
- pymdownx.escapeall:
    hardbreak: true
    nbsp: true
- pymdownx.smartsymbols:
    ordinal_numbers: false
...
```

### Configure Frontmatter From Python Objects

A lot of times in plugins, it may be easier to build up a Python dictionary and convert it to YAML.  MdPopups provides a function to exactly this:

```py3
frontmatter = {
    "allow_code_wrap": false,
    "markdown_extensions": [
        "markdown.extensions.admonition",
        "markdown.extensions.attr_list",
        "markdown.extensions.def_list",
        "markdown.extensions.nl2br",
        # Smart quotes always have corner cases that annoy me, so don't bother with them.
        {"markdown.extensions.smarty": {"smart_quotes": False}},
        "pymdownx.betterem",
        {
            "pymdownx.magiclink": {
                "repo_url_shortener": True,
                "base_repo_url": "https://github.com/facelessuser/sublime-markdown-popups"
            }
        },
        "pymdownx.extrarawhtml",
        "pymdownx.keys",
        {"pymdownx.escapeall": {"hardbreak": True, "nbsp": True}},
        # Sublime doesn't support superscript, so no ordinal numbers
        {"pymdownx.smartsymbols": {"ordinal_numbers": False}}
    ]
}

content = mdpopups.format_frontmatter(frontmatter) + markdown_content
```

## Styling

Popups and phantoms are styled with CSS that is fed through the Jinja2 template engine. A default CSS is provided that styles commonly used elements. Plugins can provide CSS to add additional styling for plugin specific purposes. See [CSS Styling](./styling.md) to learn more about the template engine and general styling info.

It is advised to use the `wrapper_class` option of the `show_popup`, `update_popup`, and `add_phantom` commands to wrap your plugin content in a div with a unique, plugin specific class.  This way plugins can inject CSS to style their specific elements via `#!css .mdpopups .myplugin-wrapper .myclass {}` or simply `#!css .myplugin-wrapper .myclass {}`.

Also check out the included Python Markdown [`attr_list` extension syntax](https://pythonhosted.org/Markdown/extensions/attr_list.html). This is a good extension for applying classes directly to elements within Markdown format. Sometimes it can be difficult to target certain kinds of block elements, so if all else fails, you can insert raw HTML for specific elements into your Markdown and apply classes directly to them.

## API Usage

MdPopups provides a number of accessible functions.

### Version

`#!py3 (int,) mdpopups.version`
: 
    Returns the version of the MdPopups library.  Returns a tuple of integers which represents the major, minor, and patch version.

### Show Popup

`#!py3 mdpopups.show_popup`
: 
    Accepts Markdown and creates a Sublime popup.  By default, the built-in Sublime syntax highlighter will be used for code highlighting.

    Parameter              | Type                 | Default       | Description
    ---------------------- | -------------------- | ------------- | -----------
    `view`                 | `#!py3 sublime.View` |               | A Sublime Text view object.
    `content`              | `#!py3 str`          |               | Markdown/HTML content for the popup.
    `md`                   | `#!py3 bool`         | `#!py3 True`  | Defines whether the content is Markdown and needs to be converted.
    `css`                  | `#!py3 str`          | `#!py3 None`  | Additional CSS that will be injected.
    `flags`                | `#!py3 int`          | `#!py3 0`     | Flags to pass down to the Sublime Text `view.show_popup` call.
    `location`             | `#!py3 int`          | `#!py3 -1`    | Location to show popup in view.  -1 means to show right under the first cursor.
    `max_width`            | `#!py3 int`          | `#!py3 320`   | Maximum width of the popup.
    `max_height`           | `#!py3 int`          | `#!py3 240`   | Maximum height of the popup.
    `on_navigate`          | `#!py3 def fn()`     | `#!py3 None`  | Callback that receives one variable `href`.
    `on_hide`              | `#!py3 def fn()`     | `#!py3 None`  | Callback for when the popup is hidden.
    `wrapper_class`        | `#!py3 str`          | `#!py3 None`  | A string containing the class name you wish wrap your content in.  A `div` will be created with the given class.
    `template_vars`        | `#!py3 dict`         | `#!py3 None`  | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`         | `#!py3 None`  | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`         | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`         | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    !!! warning "Deprecation"
        In 2.1.0 `nl2br` and `alow_code_wrap` are deprecated. The legacy parameters here will be dropped by 2018 for ST3 and these settings will not carry over to ST4.

        To disable `nl2br`, you can customize which extensions get loaded; see [Configure Markdown Extensions](#configure-markdown-extensions).

        To enable code wrapping, see [Enable Code Wrapping](#enable-code-wrapping).

### Update Popup

`#!py3 mdpopups.update_popup`
: 
    Updates the current existing popup.

    Parameter              | Type                 | Default       | Description
    ---------------------- | -------------------- | ------------- | -----------
    `view`                 | `#!py3 sublime.View` |               | A Sublime Text view object.
    `content`              | `#!py3 str`          |               | Markdown/HTML content for the popup.
    `md`                   | `#!py3 bool`         | `#!py3 True`  | Defines whether the content is Markdown and needs to be converted.
    `css`                  | `#!py3 str`          | `#!py3 None`  | Additional CSS that will be injected.
    `wrapper_class`        | `#!py3 str`          | `#!py3 None`  | A string containing the class name you wish wrap your content in.  A `div` will be created with the given class.
    `template_vars`        | `#!py3 dict`         | `#!py3 None`  | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`         | `#!py3 None`  | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`         | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`         | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    !!! warning "Deprecation"
        In 2.1.0 `nl2br` and `alow_code_wrap` are deprecated. The legacy parameters here will be dropped by 2018 for ST3 and these settings will not carry over to ST4.

        To disable `nl2br`, you can customize which extensions get loaded; see [Configure Markdown Extensions](#configure-markdown-extensions).

        To enable code wrapping, see [Enable Code Wrapping](#enable-code-wrapping).

### Hide Popup

`#!py3 mdpopups.hide_popup`
: 
    Hides the current popup.  Included for convenience and consistency.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.


### Is Popup Visible

`#!py3 bool mdpopups.is_popup_visible`
: 
    Checks if popup is visible in the view. Included for convenience and consistency.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.

### Add Phantom

`#!py3 int mdpopups.add_phantom`
: 
    Adds a phantom to the view and returns the phantom id as an integer. By default, the built-in Sublime syntax highlighter will be used for code highlighting. 

    Parameter              | Type                   | Default       | Description
    ---------------------- | ---------------------- | ------------- | -----------
    `view`                 | `#!py3 sublime.View`   |               | A Sublime Text view object.
    `key`                  | `#!py3 str`            |               | A key that is associated with the given phantom.  Multiple phantoms can share the same key, but each phantom will have its own id.
    `region`               | `#!py3 sublime.Region` |               | Region in the view where the phantom should be inserted.
    `content`              | `#!py3 str`            |               | Markdown/HTML content for the phantom.
    `layout`               | `#!py3 int`            |               | How the HTML content should be inserted.  Acceptable values are: `sublime.LAYOUT_INLINE`, `sublime.LAYOUT_BLOCK`, and `sublime.LAYOUT_BELOW`.
    `md`                   | `#!py3 bool`           | `#!py3 True`  | Defines whether the content is Markdown and needs to be converted.
    `css`                  | `#!py3 str`            | `#!py3 None`  | Additional CSS that will be injected.
    `on_navigate`          | `#!py3 def fn()`       | `#!py3 None`  | Callback that receives one variable `href`.
    `wrapper_class`        | `#!py3 str`            | `#!py3 None`  | A string containing the class name you wish wrap your content in.  A `div` will be created with the given class.
    `template_vars`        | `#!py3 dict`           | `#!py3 None`  | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content.A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`           | `#!py3 None`  | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content. Content plugin vars are found under the object: `plugin`.A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`           | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`           | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    !!! warning "Deprecation"
        In 2.1.0 `nl2br` and `alow_code_wrap` are deprecated. The legacy parameters here will be dropped by 2018 for ST3 and these settings will not carry over to ST4.

        To disable `nl2br`, you can customize which extensions get loaded; see [Configure Markdown Extensions](#configure-markdown-extensions).

        To enable code wrapping, see [Enable Code Wrapping](#enable-code-wrapping).

### Erase Phantoms

`#!py3 mdpopups.erase_phantoms`
: 
    Erase all phantoms associated with the given key. Included for convenience and consistency.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.
    `key`     | `#!py3 str`          |         | A key that is associated with phantoms.  Multiple phantoms can share the same key, but each phantom will have its own id.

### Erase Phantom by ID

`#!py3 mdpopups.erase_phantom_by_id`
: 
    Erase a single phantom by its id.  Included for convenience and consistency.

    Parameter   | Type                 | Default | Description
    ----------- | -------------------- | ------- | -----------
    `view`      | `#!py3 sublime.View` |         | A Sublime Text view object.
    `pid`       | `#!py3 str`          |         | The id associated with a single phantom.  Multiple phantoms can share the same key, but each phantom will have its own id.

### Query Phantom

`#!py3 [sublime.Region] mdpopups.query_phantom`
: 
    Query the location of a phantom by specifying its id.  A list of `sublime.Region`s will be returned.  If the phantom with the given id is not found, the region will be returned with positions of `(-1, -1)`.  Included for convenience and consistency.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.
    `pid`     | `#!py3 int`          |         | The id associated with a single phantom.  Multiple phantoms can share the same key, but each phantom will have its own id.

### Query Phantoms

`#!py3 [sublime.Region] mdpopups.query_phantoms`
: 
    Query the location of multiple phantoms by specifying their ids.  A list of `sublime.Region`s will be returned where each index corresponds to the index of ids that was passed in.  If a given phantom id is not found, that region will be returned with positions of `(-1, -1)`.  Included for convenience and consistency.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.
    `pids`    | `#!py3 [int]`        |         | A list of ids associated with phantoms.  Multiple phantoms can share the same key, but each phantom will have its own id.

### Phantom Class

`#!py3 mdpopups.Phantoms`
: 
    A phantom object for use with [`PhantomSet`](#phantomset-class).

    Parameter              | Type                   | Default       | Description
    ---------------------- | ---------------------- | ------------- | -----------
    `region`               | `#!py3 sublime.Region` |               | Region in the view where the phantom should be inserted.
    `content`              | `#!py3 str`            |               | Markdown/HTML content for the phantom.
    `layout`               | `#!py3 int`            |               | How the HTML content should be inserted.  Acceptable values are: `sublime.LAYOUT_INLINE`, `sublime.LAYOUT_BLOCK`, and `sublime.LAYOUT_BELOW`.
    `md`                   | `#!py3 bool`           | `#!py3 True`  | Defines whether the content is Markdown and needs to be converted.
    `css`                  | `#!py3 str`            | `#!py3 None`  | Additional CSS that will be injected.
    `on_navigate`          | `#!py3 def fn()`       | `#!py3 None`  | Callback that receives one variable `href`.
    `wrapper_class`        | `#!py3 str`            | `#!py3 None`  | A string containing the class name you wish wrap your content in.  A `div` will be created with the given class.
    `template_vars`        | `#!py3 dict`           | `#!py3 None`  | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content.A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`           | `#!py3 None`  | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content. Content plugin vars are found under the object: `plugin`.A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`           | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`           | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    **Attributes**

    Attribute              | Type                   | Description
    ---------------------- | ---------------------- | -----------
    `region`               | `#!py3 sublime.Region` | Region in the view where the phantom should be inserted.
    `content`              | `#!py3 str`            | Markdown/HTML content for the phantom.
    `layout`               | `#!py3 int`            | How the HTML content should be inserted.  Acceptable values are: `sublime.LAYOUT_INLINE`, `sublime.LAYOUT_BLOCK`, and `sublime.LAYOUT_BELOW`.
    `md`                   | `#!py3 bool`           | Defines whether the content is Markdown and needs to be converted.
    `css`                  | `#!py3 str`            | Additional CSS that will be injected.
    `on_navigate`          | `#!py3 def fn()`       | Callback that receives one variable `href`.
    `wrapper_class`        | `#!py3 str`            | A string containing the class name you wish wrap your content in.  A `div` will be created with the given class.
    `template_vars`        | `#!py3 dict`           | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content.A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`           | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content. Content plugin vars are found under the object: `plugin`.A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`           | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`           | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    !!! warning "Deprecation"
        In 2.1.0 `nl2br` and `alow_code_wrap` are deprecated. The legacy parameters here will be dropped by 2018 for ST3 and these settings will not carry over to ST4.

        To disable `nl2br`, you can customize which extensions get loaded; see [Configure Markdown Extensions](#configure-markdown-extensions).

        To enable code wrapping, see [Enable Code Wrapping](#enable-code-wrapping).

### Phantom Set Class

`#!py3 mdpopups.PhantomSet`
: 
    A class that allows you to update phantoms under the specified key.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | A Sublime Text view object.
    `key`     | `#!py3 str`          |         | The key that should be associated with all related phantoms in the set.

    **Methods**

    `mdpopups.PhantomSet.update`
    : 
        Update all the phantoms in the set with the given phantom list.

        Parameter      | Type                                         | Default | Description
        -------------- | -------------------------------------------- | ------- | -----------
        `new_phantoms` | [`#!py3 [mdpopups.Phantom]`](#class-phantom) |         | A list of MdPopups phantoms. `sublime.Phantom` will be converted to `mdpopups.Phantom`.

### Clear Cache

`#!py3 mdpopups.clear_cache`
: 
    Clears the CSS theme related caches.

### Markdown to HTML

`#!py3 str mdpopups.md2html`
: 
    Exposes the Markdown to HTML converter in case it is desired to parse only a section of markdown.  This works well for someone who wants to work directly in HTML, but might want to still have fragments of markdown that they would like to occasionally convert. By default, the built-in Sublime syntax highlighter will be used for code highlighting.

    Parameter              | Type                 | Required     | Default       | Description
    ---------------------- | -------------------- | ------------ | ------------- | -----------
    `view`                 | `#!py3 sublime.View` | Yes          |               | Sublime text View object.
    `markup`               | `#!py3 string`       | Yes          |               | The markup code to be converted.
    `template_vars`        | `#!py3 dict`         | No           | `#!py3 None`  | A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content.A dictionary containing template vars.  These can be used in either the CSS or the HTML/Markdown content. These vars are found under the object `plugin`.
    `template_env_options` | `#!py3 dict`         | No           | `#!py3 None`  | A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content. Content plugin vars are found under the object: `plugin`.A dictionary containing options for the Jinja2 template environment. This **only** applies to the **HTML/Markdown** content.
    `nl2br`                | `#!py3 bool`         | `#!py3 True`  | Determines whether the newline to `#!html <br>` Python Markdown extension is enabled or not. Will be ignored if `markdown_extensions` is configured in YAML frontmatter.
    `allow_code_wrap`      | `#!py3 bool`         | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur. YAML frontmatter's `allow_code_wrap` will always be used instead of this if specified.

    !!! warning "Deprecation"
        In 2.1.0 `nl2br` and `alow_code_wrap` are deprecated. The legacy parameters here will be dropped by 2018 for ST3 and these settings will not carry over to ST4.

        To disable `nl2br`, you can customize which extensions get loaded; see [Configure Markdown Extensions](#configure-markdown-extensions).

        To enable code wrapping, see [Enable Code Wrapping](#enable-code-wrapping).

### Color Box

`#!py3 str mdpopups.color_box`
: 
    Generates a color preview box image encoded in base 64 and formatted to be inserted right in your your Markdown or HTML code as an `img` tag.

    Parameter     | Type          | Default       | Description
    ------------- | ------------- | ------------- | -----------
    `colors`      | `#!py3 [str]` |               | A list of color strings formatted as `#RRGGBBAA` where `R` is the red channel, `G` is the green channel, `B` is the blue channel, and `A` is the alpha channel.
    `border`      | `#!py3 str`   |               | The color for the color box border.  Input is a RGB color formatted as `#RRGGBB`.
    `border2`     | `#!py3 str`   | `#!py3 None`  | The optional secondary border color.  This is great if you are going to have it on a light and dark backgrounds.  You can use a double border so the color stands out regardless of the background.  Input is a RGB color formatted as `#RRGGBB`.
    `height`      | `#!py3 int`   | `#!py3 32`    | Height of color box.
    `width`       | `#!py3 int`   | `#!py3 32`    | Width of color box.
    `border_size` | `#!py3 int`   | `#!py3 1`     | Width of the color box border.  If using `border2`, the value should be set to at least 2 to see both colors.
    `check_size`  | `#!py3 int`   | `#!py3 4`     | Size of checkered box squares used for the background of transparent colors.
    `max_colors`  | `#!py3 int`   | `#!py3 5`     | Max number of colors that will be evaluated in the `colors` parameter.  Multiple colors are used to to create palette boxes showing multiple colors lined up horizontally.
    `alpha`       | `#!py3 bool`  | `#!py3 False` | Will create color box images with a real alpha channel instead of simulating one with a checkered background.
    `border_map`  | `#!py3 int`   | `#!py3 0xF`   | A mapping of which borders to show.  Where `0x1` is `TOP`, `0x2` is `LEFT`, `0x4` is `BOTTOM`, `0x8` is `RIGHT`.  Map flags can be accessed via `mdpopups.colorbox.TOP` etc.

### Color Box Raw

`#!py3 bytes mdpopups.color_box`
: 
    Generates a color preview box image and returns the raw byte string of the image.

    Parameter     | Type          | Default       | Description
    ------------- | ------------- | ------------- | -----------
    `colors`      | `#!py3 [str]` |               | A list of color strings formatted as `#RRGGBBAA` where `R` is the red channel, `G` is the green channel, `B` is the blue channel, and `A` is the alpha channel.
    `border`      | `#!py3 str`   |               | The color for the color box border.  Input is a RGB color formatted as `#RRGGBB`.
    `border2`     | `#!py3 str`   | `#!py3 None`  | The optional secondary border color.  This is great if you are going to have it on a light and dark backgrounds.  You can use a double border so the color stands out regardless of the background.  Input is a RGB color formatted as `#RRGGBB`.
    `height`      | `#!py3 int`   | `#!py3 32`    | Height of color box.
    `width`       | `#!py3 int`   | `#!py3 32`    | Width of color box.
    `border_size` | `#!py3 int`   | `#!py3 1`     | Width of the color box border.  If using `border2`, the value should be set to at least 2 to see both colors.
    `check_size`  | `#!py3 int`   | `#!py3 4`     | Size of checkered box squares used for the background of transparent colors.
    `max_colors`  | `#!py3 int`   | `#!py3 5`     | Max number of colors that will be evaluated in the `colors` parameter.  Multiple colors are used to to create palette boxes showing multiple colors lined up horizontally.
    `alpha`       | `#!py3 bool`  | `#!py3 False` | Will create color box images with a real alpha channel instead of simulating one with a checkered background.
    `border_map`  | `#!py3 int`   | `#!py3 0xF`   | A mapping of which borders to show.  Where `0x1` is `TOP`, `0x2` is `LEFT`, `0x4` is `BOTTOM`, `0x8` is `RIGHT`.  Map flags can be accessed via `mdpopups.colorbox.TOP` etc.

### Tint

`#!py3 str mdpopups.tint`
: 
    Takes a either a path to an PNG or a byte string of a PNG and tints it with a specific color and returns a string containing the base 64 encoded PNG in a HTML element.

    Parameter | Type              | Default      | Description
    --------- | ----------------- | ------------ | -----------
    `img`     | `#!py3 str/bytes` |              | Either a string in the form `Packages/Package/resource.png` or a byte string of a PNG image.
    `color`   | `#!py3 str`       |              | A string in the form of `#RRGGBB` or `#RRGGBBAA` (alpha layer will be stripped and ignored and is only allowed to make it easy to pass in colors from a color scheme).
    `opacity` | `#!py3 int`       | `#!py3 255`  | An integer value between 0 - 255 that specifies the opacity of the tint.
    `height`  | `#!py3 int`       | `#!py3 None` | Height that should be specified in the return HTML element.
    `width`   | `#!py3 int`       | `#!py3 None` | Width that should be specified in the return HTML element.

### Tint Raw

`#!py3 bytes mdpopups.tint_raw`
: 
    Takes a either a path to an PNG or a byte string of a PNG and tints it with a specific color and returns a byte string of the modified PNG.

    Parameter | Type              | Default     | Description
    --------- | ----------------- | ----------- | -----------
    `img`     | `#!py3 str/bytes` |             | Either a string in the form `Packages/Package/resource.png` or a byte string of a PNG image.
    `color`   | `#!py3 str`       |             | A string in the form of `#RRGGBB` or `#RRGGBBAA` (alpha layer will be stripped and ignored and is only allowed to make it easy to pass in colors from a color scheme).
    `opacity` | `#!py3 int`       | `#!py3 255` | An integer value between 0 - 255 that specifies the opacity of the tint.

### Scope to Style

`#!py3 dict mdpopups.scope2style`
: 
    Takes a sublime scope (complexity doesn't matter), and guesses the style that would be applied.  While there may be untested corner cases with complex scopes where it fails, in general, it is usually accurate.  The returned dictionary is in the form:

    ```py3
    {
        # Colors will be None if not found,
        # though usually, even if the scope has no color
        # it will return the overall theme foreground.
        #
        # Background might be None if using `explicit_background`
        # as it only returns a background if that style specifically
        # defines a background.
        "color": "#RRGGBB",
        "background": "#RRGGBB",
        # Style will usually be either 'bold', 'italic'.
        # Multiple styles may be returned 'bold italic' or an empty string ''.
        "style": 'bold italic'
    }
    ```

    Parameter             | Type                 | Default       | Description
    --------------------- | -------------------- | ------------- | -----------
    `view`                | `#!py3 sublime.View` |               | Sublime text View object so that the correct color scheme will be searched.
    `scope`               | `#!py3 string`       |               | The scope to search for.
    `selected`            | `#!py3 bool`         | `#!py3 False` | Whether this scope is in a selected state (selected text).
    `explicit_background` | `#!py3 bool`         | `#!py3 False` | Only return a background if one is explicitly defined in the color scheme.

### Syntax Highlight

`#!py3 str mdpopups.syntax_highlight`
: 
    Allows for syntax highlighting outside the Markdown environment.  You can just feed it code directly and give it the language of your choice, and you will be returned a block of HTML that has been syntax highlighted. By default, the built-in Sublime syntax highlighter will be used for code highlighting.

    Parameter         | Type                 | Default       | Description
    ----------------- | -------------------- | ------------- | -----------
    `view`            | `#!py3 sublime.View` |               | Sublime text View object.
    `src`             | `#!py3 str`          |               | The source code to be converted.  No fence tokes are needed (` ``` `).
    `language`        | `#!py3 str`          | `#!py3 None`  | Specifies the language to highlight as.
    `inline`          | `#!py3 bool`         | `#!py3 False` | Will return the code formatted for inline display.
    `allow_code_wrap` | `#!py3 bool`         | `#!py3 False` | Do not convert all the spaces in code blocks to `&nbsp;` so that wrapping can occur.

### Tabs to Spaces

`#!py3 str mdpopups.tabs2spaces`
: 
    The Markdown parser used converts all tabs to spaces with the simple logic of 1 tab equals 4 spaces. This logic is generally applied in other places like [`syntax_highlight`](#syntax-highlight). When formatting code for `syntax_highlight`, you may want to translate the tabs to spaces based on tab stops *before* passing it through opposed to apply the simple logic of converting all tabs to 4 spaces regardless of tab stops. `tabs2spaces` does exactly this, allowing you format the whitespace in a more intelligent manner.

    `tabs2spaces` cannot do anything about characters, and there are some even in monospace fonts, that are wider than normal characters. It doesn't detect zero width characters either. It also cannot predict cases where two or more Unicode character are shown as one. But in some cases, this more intelligent output is much better than the "all tabs are arbitrarily one size" logic.

    Example (Notice that `♭` is a bit larger than normal characters):

    ```pycon3
    >>> import mdpopups
    >>> text = '''
    ============================================================
    T\tTp\tSp\tD\tDp\tS\tD7\tT
    ------------------------------------------------------------
    A\tF#m\tBm\tE\tC#m\tD\tE7\tA
    A#\tGm\tCm\tF\tDm\tD#\tF7\tA#
    B♭\tGm\tCm\tF\tDm\tE♭m\tF7\tB♭
    '''
    >>> print(mdpopups.tabs2spaces(text, tab_size=8))

    ============================================================
    T       Tp      Sp      D       Dp      S       D7      T
    ------------------------------------------------------------
    A       F#m     Bm      E       C#m     D       E7      A
    A#      Gm      Cm      F       Dm      D#      F7      A#
    B♭      Gm      Cm      F       Dm      E♭m     F7      B
    ```

    Parameter         | Type        | Default   | Description
    ----------------- | ----------- | --------- | -----------
    `text`            | `#!py3 str` |           | Text to convert.
    `tab_size`        | `#!py3 int` | `#!py3 4` | Tab size.

### Get Language From View

`#!py3 str mdpopups.get_language_from_view`
: 
    Allows a user to extract the equivalent language specifier for `mdpopups.syntax_highlight` from a view.  If the language cannot be determined, `None` will be returned.

    Parameter | Type                 | Default | Description
    --------- | -------------------- | ------- | -----------
    `view`    | `#!py3 sublime.View` |         | Sublime text View object.

--8<-- "refs.md"
