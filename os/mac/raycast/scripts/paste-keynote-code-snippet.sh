#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Paste Keynote code snippet
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⌨️

# Documentation:
# @raycast.author rgomezcasas
# @raycast.authorURL https://raycast.com/rgomezcasas

rm -f /tmp/clipboard.rtf /tmp/clipboard_fixed.rtf

osascript -e 'set rtfData to the clipboard as «class RTF »' \
    -e 'set tempFile to "/tmp/clipboard.rtf"' \
    -e 'set fileRef to open for access tempFile with write permission' \
    -e 'set eof of fileRef to 0' \
    -e 'write rtfData to fileRef' \
    -e 'close access fileRef'

# Change font size (56 pts ≈ 28px) + remove bg
perl -i -pe 's/\\fs\d+/\\fs56/g; s/\\highlight\d+\s*//g; s/\\cb\d+\s*//g; s/\\shading\d+\s*//g; s/\\chshdng\d+\s*//g; s/\\chcbpat\d+\s*//g;' /tmp/clipboard.rtf

textutil -convert rtf -output /tmp/clipboard_fixed.rtf /tmp/clipboard.rtf
cat /tmp/clipboard_fixed.rtf | pbcopy

osascript -e 'tell application "System Events" to keystroke "v" using command down'

echo "Done!"
