# *pygments* module for Package Control

This is the *[pygments][]* module bundled for usage with [Package Control][], a package manager for the [Sublime Text][] text editor.


This repository | Pypi
---- | ----
![Latest tag](https://img.shields.io/github/tag/packagecontrol/pygments.svg) | [![pypi](https://img.shields.io/pypi/v/pygments.svg)][pypi]


## How to use *pygments* as a dependency

In order to tell Package Control that you are using the *pygments* module in your ST package, create a `dependencies.json` file in your package root with the following contents:

```js
{
    "*": {
        "*": [
            "pygments"
        ]
    }
}
```

If the file exists already, add `"pygments"` to the every dependency list.

Then run the **Package Control: Satisfy Dependencies** command to make Package Control install the module for you locally (if you don't have it already).

After all this you can use `import pygments` in any of your Python plugins.

See also: [Documentation on Dependencies](https://packagecontrol.io/docs/dependencies)


## How to update this repository (for contributors)

1. Download the latest zip from [Bitbucket][].
2. Delete everything inside the `all/` folder.
3. Copy the `pygments/` folder to the `all/` folder.
4. Commit changes and either create a pull request or create a tag directly in the format `v<version>` (in case you have push access).


## License

The contents of the root folder in this repository are released under the *public domain*. The contents of the `all/` folder fall under *their own bundled licenses* displayed on top of every file. If not displayed, see the `LICENSE` file on pygments' [Bitbucket][].


[pygments]: http://pygments.org
[Package Control]: http://packagecontrol.io/
[Sublime Text]: http://sublimetext.com/
[pypi]: https://pypi.python.org/pypi/pygments
[Bitbucket]: https://bitbucket.org/birkenfeld/pygments-main
