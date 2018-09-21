"""Frontmatter stripping."""
import yaml
import re
from collections import OrderedDict


def yaml_load(stream, loader=yaml.Loader, object_pairs_hook=OrderedDict):
    """
    Custom yaml loader.

    Make all YAML dictionaries load as ordered Dicts.
    http://stackoverflow.com/a/21912744/3609487

    Load all strings as unicode.
    http://stackoverflow.com/a/2967461/3609487
    """

    def construct_mapping(loader, node):
        """Convert to ordered dict."""

        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))

    def construct_yaml_str(self, node):
        """Override the default string handling function to always return unicode objects."""

        return self.construct_scalar(node)

    class Loader(loader):
        """Custom Loader."""

    Loader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping
    )

    Loader.add_constructor(
        'tag:yaml.org,2002:str',
        construct_yaml_str
    )

    return yaml.load(stream, Loader)


def yaml_dump(data, stream=None, dumper=yaml.Dumper):
    """Special dumper wrapper to modify the yaml dumper."""

    class Dumper(dumper):
        """Custom dumper."""

    # Handle Ordered Dict
    Dumper.add_representer(
        OrderedDict,
        lambda self, data: self.represent_mapping('tag:yaml.org,2002:map', data.items())
    )

    return yaml.dump(data, stream, Dumper, width=None, indent=4, allow_unicode=True, default_flow_style=False)


def dump_frontmatter(values):
    """Turn Python dict values to frontmatter string."""

    return '---\n%s\n...\n' % yaml_dump(values)


def get_frontmatter(string):
    """Get frontmatter from string."""

    frontmatter = OrderedDict()

    if string.startswith("---"):
        m = re.search(r'^(-{3}\r?\n(?!\r?\n)(.*?)(?<=\n)(?:-{3}|\.{3})\r?\n)', string, re.DOTALL)
        if m:
            yaml_okay = True
            try:
                frontmatter = yaml_load(m.group(2))
                if frontmatter is None:
                    frontmatter = OrderedDict()
                # If we didn't get a dictionary, we don't want this as it isn't frontmatter.
                assert isinstance(frontmatter, (dict, OrderedDict)), TypeError
            except Exception:
                # We had a parsing error. This is not the YAML we are looking for.
                yaml_okay = False
                frontmatter = OrderedDict()
            if yaml_okay:
                string = string[m.end(1):]

    return frontmatter, string
