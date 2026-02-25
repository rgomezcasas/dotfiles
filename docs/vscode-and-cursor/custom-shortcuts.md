# Custom Keyboard Shortcuts in VSCode and Cursor

Both editors share the same keybindings file: `editors/code-oss/keybindings.json`.

Add entries in alphabetical order by key. Entry format:

```json
{
  "key": "cmd+1",
  "command": "workbench.view.explorer",
  "when": "!explorerViewletFocus"
}
```

Disable a default shortcut by prefixing the command with `-`:

```json
{
  "key": "cmd+b",
  "command": "-workbench.action.toggleSidebarVisibility"
}
```

Run `rebuild` after changes.
