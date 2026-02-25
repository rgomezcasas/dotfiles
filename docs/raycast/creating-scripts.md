# Creating Raycast Scripts

Scripts live in `os/mac/raycast/scripts/` with a `.sh` extension. Use kebab-case filenames.

## Template

```bash
#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Script Title
# @raycast.packageName Category
# @raycast.mode silent
# @raycast.icon 🔥
# @raycast.description Brief description

# script logic here
```

## Raycast Metadata

- `schemaVersion`: Always `1`
- `title`: Display name in Raycast
- `packageName`: Category/submenu in Raycast
- `mode`: `silent` (no output) or `fullOutput` (show results)
- `icon`: Emoji or SF Symbol name
- `description`: Tooltip shown in Raycast
