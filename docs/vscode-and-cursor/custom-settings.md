# Custom Settings in VSCode and Cursor

VSCode and Cursor each have their own `settings.json` file, managed via dotfiles:

- **VSCode:** `editors/vscode/settings.json`
- **Cursor:** `editors/cursor/settings.json`

Both files share most of their configuration but can diverge for editor-specific features (e.g., Cursor AI settings).

## Modifying a Setting

Find the setting key in the corresponding file and change its value:

```json
"editor.tabSize": 2
```

## Adding a New Setting

Add a new key-value pair to the JSON object. Keep entries organized by namespace (e.g., `editor.*`, `explorer.*`, `terminal.*`).

```json
"editor.fontSize": 14,
"editor.wordWrap": "on"
```

## Setting Value Types

Settings accept different value types depending on the key:

```json
"editor.minimap.enabled": false,
"editor.tabSize": 4,
"editor.fontFamily": "DankMono Nerd Font",
"editor.rulers": [100],
"editor.cursorBlinking": "smooth"
```

## Common Setting Namespaces

| Namespace     | Description                          |
|---------------|--------------------------------------|
| `editor.*`    | Text editor behavior and appearance  |
| `explorer.*`  | File explorer settings               |
| `terminal.*`  | Integrated terminal                  |
| `files.*`     | File handling (auto-save, EOL, etc.) |
| `search.*`    | Search behavior                      |
| `window.*`    | Window management                    |
| `workbench.*` | UI layout and themes                 |
| `git.*`       | Git integration                      |

## Tips

- Both files must be valid JSON (no trailing commas, no comments)
- Use the Command Palette (`Cmd+Shift+P` > "Open Settings (JSON)") to discover setting keys
- If a setting should apply to both editors, update both files
