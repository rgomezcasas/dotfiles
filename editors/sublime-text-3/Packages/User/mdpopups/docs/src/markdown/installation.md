# Installation

## Package Control

In order for your plugin to utilize Markdown Popups, you must be using [Package Control][package-control], and you must add `mdpopups` (and other related dependencies) as a dependency for your plugin.  This can be done in one of two ways, both of which are [documented][pc-dependencies] by Package Control; see **Using Dependencies**.  Package Control will install and update the dependency for you.  Package Control will also ensure that `mdpopups` is loaded before your plugin loads.

If ever you are on a older version than is currently released, and Package Control has not updated to the latest, you can force the update by running the `Package Control: Satisfy Dependencies` command from the command palette.

Remember, MdPopups is for Sublime Text 3 builds 3124+.

--8<-- "refs.md"
