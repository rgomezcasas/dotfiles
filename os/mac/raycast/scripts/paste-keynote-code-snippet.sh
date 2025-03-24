#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Paste Keynote code snippet
# @raycast.mode silent

# Optional parameters:
# @raycast.icon⌨️

# Documentation:
# @raycast.author rgomezcasas
# @raycast.authorURL https://raycast.com/rgomezcasas

# Limpiar archivo temporal si existe
rm -f /tmp/clipboard.rtf /tmp/clipboard_fixed.rtf

# Guardar el RTF del portapapeles en un archivo temporal
osascript -e 'set rtfData to the clipboard as «class RTF »' \
    -e 'set tempFile to "/tmp/clipboard.rtf"' \
    -e 'set fileRef to open for access tempFile with write permission' \
    -e 'set eof of fileRef to 0' \
    -e 'write rtfData to fileRef' \
    -e 'close access fileRef'

# Modificar el tamaño de fuente en el archivo RTF (56 medios puntos ≈ 28px)
sed -i '' 's/\\fs[0-9][0-9]*/\\fs56/g' /tmp/clipboard.rtf

# Usar textutil para convertir el RTF a RTF (esto puede parecer redundante pero ayuda a normalizar el formato)
textutil -convert rtf -output /tmp/clipboard_fixed.rtf /tmp/clipboard.rtf

# Copiar el RTF modificado al portapapeles usando pbcopy
cat /tmp/clipboard_fixed.rtf | pbcopy

echo "Tamaño de fuente cambiado a 28px (preservando formato y cursivas)"
