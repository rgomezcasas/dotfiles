#!/usr/bin/env bash

uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
echo -n $uuid | pbcopy
echo $uuid

osascript -e 'display notification "'"$uuid"'" with title "UUID copied to the clipboard"'
