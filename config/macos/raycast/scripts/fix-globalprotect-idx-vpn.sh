#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Fix GlobalProtect IDX VPN
# @raycast.packageName IDX
# @raycast.mode silent
# @raycast.icon 🔒
# @raycast.description Restart the GlobalProtect agent when the VPN gets stuck

launchctl kickstart -k "gui/$(id -u)/com.paloaltonetworks.gp.pangps"
