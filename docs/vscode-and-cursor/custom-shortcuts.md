# Custom Keyboard Shortcuts in VSCode and Cursor

Both VSCode and Cursor share the same keybindings file, managed via dotfiles at `editors/code-oss/keybindings.json`.

## Adding a New Shortcut

Add a new entry to the JSON array in `editors/code-oss/keybindings.json`:

```json
{
  "key": "ctrl+shift+k",
  "command": "editor.action.deleteLines",
  "when": "editorTextFocus"
}
```

### Properties

- **key:** The keyboard combination (e.g., `ctrl+shift+k`, `cmd+option+d`, `alt+z`)
- **command:** The command ID to execute
- **when:** Optional condition for when the shortcut is active (e.g., `editorTextFocus`, `editorTextFocus && !editorReadonly`)

## Modifying an Existing Shortcut

Find the entry in `editors/code-oss/keybindings.json` and change the `key` value.

## Disabling a Default Shortcut

Prefix the command with `-` to unbind it:

```json
{
  "key": "cmd+k",
  "command": "-editor.action.deleteLines"
}
```

## Running Multiple Commands

Use `runCommands` to chain multiple commands on a single shortcut:

```json
{
  "key": "cmd+1",
  "command": "runCommands",
  "args": { "commands": ["workbench.action.toggleSidebarVisibility", "workbench.action.focusActiveEditorGroup"] },
  "when": "explorerViewletFocus"
}
```

## Passing Arguments to Commands

```json
{
  "key": "ctrl+e",
  "command": "editor.action.codeAction",
  "args": {
    "kind": "refactor.extract.function"
  }
}
```

## Common Keybinding Conditions

- `editorFocus`: Editor has focus
- `editorTextFocus`: Cursor is in text
- `editorReadonly` / `!editorReadonly`: Read-only state
- `explorerViewletFocus`: File explorer has focus
- `focusedView == 'workbench.scm'`: Specific view has focus

## Tips

- Chain key sequences with space: `cmd+k cmd+v`
- Combine conditions with `&&`: `editorTextFocus && !editorReadonly`
- Negate conditions with `!`: `!inputFocus`
