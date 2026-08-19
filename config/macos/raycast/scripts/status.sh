#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title Status
# @raycast.packageName VPN
# @raycast.mode fullOutput
# @raycast.icon 🔐
# @raycast.description Show VPN connection status, public/local IPs, and connection type

export LC_ALL=en_US.UTF-8

gp_state=$(grep -oE 'Set state to [A-Za-z]+' "/Library/Logs/PaloAltoNetworks/GlobalProtect/PanGPS.log" 2>/dev/null | tail -1 | awk '{print $NF}')
case "$gp_state" in
Connected) global_protect_status="✅ Connected" ;;
Disconnected) global_protect_status="❌ Disconnected" ;;
*) global_protect_status="❓ ${gp_state:-unknown}" ;;
esac

warp_state=$(/usr/local/bin/warp-cli status 2>/dev/null | head -1 | awk '{print $NF}')
case "$warp_state" in
Connected) warp_status="✅ Connected" ;;
Disconnected) warp_status="❌ Disconnected" ;;
*) warp_status="❓ ${warp_state:-unknown}" ;;
esac

public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)

default_iface=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
local_ip=$(ipconfig getifaddr "$default_iface" 2>/dev/null)

hardware_port=$(networksetup -listallhardwareports | awk -v dev="$default_iface" \
	'/^Hardware Port:/ {port=substr($0, 16)} $0 == "Device: " dev {print port; exit}')

if [[ -z "$default_iface" ]]; then
	connection="❌ No network"
	link_speed="unknown"
elif [[ "$hardware_port" == "Wi-Fi" ]]; then
	connection="📶 Wi-Fi"
	transmit_rate=$(osascript -l JavaScript -e \
		'ObjC.import("CoreWLAN"); $.CWWiFiClient.sharedWiFiClient.interface.transmitRate' 2>/dev/null)
	link_speed="${transmit_rate:+$transmit_rate Mbps}"
	link_speed="${link_speed:-unknown}"
else
	connection="🔌 Cable (${hardware_port:-$default_iface})"
	link_speed=$(ifconfig "$default_iface" 2>/dev/null | awk -F'[()]' '/media:/ {print $2}' | sed 's/ <full-duplex>/ full-duplex/')
	link_speed="${link_speed:-unknown}"
fi

echo "GlobalProtect:   $global_protect_status"
echo "Cloudflare WARP: $warp_status"
echo "Connection:      $connection"
echo "Link speed:      $link_speed"
echo "Public IP:       ${public_ip:-unknown}"
echo "Local IP:        ${local_ip:-unknown}"
