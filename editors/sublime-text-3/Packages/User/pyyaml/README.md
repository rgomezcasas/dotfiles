# *pyyaml* module for Package Control

This is the *[pyyaml][]* module (`yaml`)
bundled for usage with [Package Control][],
a package manager
for the [Sublime Text][] text editor.

It does **only include the pure-Python version**
and not the fast LibYAML variant.
This may or may not
be added as a different dependency
at a later point.


this repo | pypi 
---- | ----
![latest tag](https://img.shields.io/github/tag/packagecontrol/pyyaml.svg) | [![pypi](https://img.shields.io/pypi/v/pyyaml.svg)][pypi]


## How to use *pyyaml* as a dependency

In order to tell Package Control
that you are using the *pyyaml* module
in your ST package,
create a `dependencies.json` file
in your package root
with the following contents:

```js
{
   "*": {
      "*": [
         "pyyaml"
      ]
   }
}
```

If the file exists already,
add `"pyyaml"` to the every dependency list.

Then run the **Package Control: Satisfy Dependencies** command
to make Package Control
install the module for you locally
(if you don't have it already).

After all this
you can use `import yaml`
in any of your Python plugins.

See also:
[Documentation on Dependencies](https://packagecontrol.io/docs/dependencies)


## How to update this repository (for contributors)

1. Download the latest tarball
   from [pypi][].
2. Delete everything inside the `st2/` and `st3/` folders.
3. Copy the `lib/` folder
   and everything related to copyright/licensing
   from the tarball
   to the `st2/` folder
   and do the same
   with the `lib3/` folder
   and `st3/`.
4. Commit changes
   and either create a pull request
   or create a tag directly
   in the format `v<version>`
   (in case you have push access).
   This must be a semantic version,
   so append `.0`.


## License

The contents of the root folder
in this repository
are released
under the *public domain*.
The contents of the `st2/` and `st3/` folders
fall under *their own bundled licenses*.


[pyyaml]: http://pyyaml.org/wiki/PyYAML
[Package Control]: http://packagecontrol.io/
[Sublime Text]: http://sublimetext.com/
[pypi]: https://pypi.python.org/pypi/pyyaml
