#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title IDX Env Toggle
# @raycast.packageName Environment
# @raycast.mode silent
# @raycast.icon 🛍️
# @raycast.description Enable or disable the IDX environment

export LC_ALL=en_US.UTF-8

dotfiles_path="$HOME/.dotfiles"
zshrc="$dotfiles_path/config/shell/zsh/.zshrc"
bashrc="$dotfiles_path/config/shell/bash/.bashrc"
rc_files=("$zshrc" "$bashrc")
idx_source_pattern='^\(# \)\?source "\$DOTFILES_PATH/modules/private/shell/idx\.sh"$'
aidevtracker_init="$HOME/.config/inditex/aidevtracker/scripts/init.sh"

npmrc="$HOME/.npmrc"
npmrc_idx="$npmrc.idx"
npmrc_original="$npmrc.original"

globalprotect_agents=(/Library/LaunchAgents/com.paloaltonetworks.gp.pangp*.plist)

avg_hub="/Applications/AVGAntivirus.app/Contents/Backend/hub"
avg_user_agent="gui/$(id -u)/com.avg.userinit"

notify() {
	osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1
}

for file in "${rc_files[@]}"; do
	if [[ ! -f "$file" ]]; then
		notify "IDX environment" "File not found: $file"
		exit 1
	fi

	if ! grep -q "$idx_source_pattern" "$file"; then
		notify "IDX environment" "No idx.sh source line in $file"
		exit 1
	fi
done

rewrite_file() {
	local file="$1"
	shift
	local tmp
	tmp=$(mktemp)
	if "$@" "$file" >"$tmp"; then
		cat "$tmp" >"$file"
	fi
	rm -f "$tmp"
}

uncomment_idx_source() {
	sed 's|^# \(source "\$DOTFILES_PATH/modules/private/shell/idx\.sh"\)$|\1|' "$1"
}

comment_idx_source() {
	sed 's|^\(source "\$DOTFILES_PATH/modules/private/shell/idx\.sh"\)$|# \1|' "$1"
}

uncomment_aidevtracker_source() {
	sed 's|^# \(source "'"$aidevtracker_init"'"\)$|\1|' "$1"
}

comment_aidevtracker_source() {
	sed 's|^\(source "'"$aidevtracker_init"'"\)$|# \1|' "$1"
}

swap_npmrc() {
	local incoming="$1"
	local outgoing="$2"

	[[ -e "$npmrc" || -L "$npmrc" ]] || return 1
	[[ -e "$incoming" || -L "$incoming" ]] || return 1
	[[ -e "$outgoing" || -L "$outgoing" ]] && return 1

	mv "$npmrc" "$outgoing" || return 1
	mv "$incoming" "$npmrc" || return 1
}

globalprotect_agent_loaded() {
	launchctl print "gui/$(id -u)/$(basename "$1" .plist)" >/dev/null 2>&1
}

load_globalprotect_agents() {
	local agent
	for agent in "${globalprotect_agents[@]}"; do
		globalprotect_agent_loaded "$agent" || launchctl load "$agent" || return 1
	done
}

unload_globalprotect_agents() {
	local agent
	for agent in "${globalprotect_agents[@]}"; do
		globalprotect_agent_loaded "$agent" && { launchctl unload "$agent" || return 1; }
	done
	return 0
}

run_as_admin() {
	local result
	result=$(osascript - "$1" "$2" 2>/dev/null <<'APPLESCRIPT'
on run argv
	try
		do shell script (item 1 of argv) with prompt (item 2 of argv) with administrator privileges
	on error number errorNumber
		if errorNumber is -128 then return "cancelled"
		return "failed"
	end try
	return "done"
end run
APPLESCRIPT
)

	case "$result" in
	done) return 0 ;;
	cancelled) return 2 ;;
	*) return 1 ;;
	esac
}

start_avg() {
	[[ -d "$avg_hub" ]] || return 0

	run_as_admin "launchctl enable system/com.avg.init && '$avg_hub/init.sh' >/dev/null 2>&1" \
		"The IDX environment needs to start AVG." || return

	launchctl enable "$avg_user_agent"
	"$avg_hub/userinit.sh" start >/dev/null 2>&1
}

stop_avg() {
	[[ -d "$avg_hub" ]] || return 0

	run_as_admin "launchctl disable system/com.avg.init; status=0; for module in \$(ls -r '$avg_hub/modules'); do '$avg_hub/modules/'\$module stop >/dev/null 2>&1 || status=1; done; exit \$status" \
		"The IDX environment needs to stop AVG."
	local admin_status=$?
	(( admin_status == 2 )) && return 2

	launchctl disable "$avg_user_agent"
	"$avg_hub/userinit.sh" stop >/dev/null 2>&1

	return $admin_status
}

abort_if_cancelled() {
	if (( $1 == 2 )); then
		notify "IDX environment unchanged" "Password prompt cancelled"
		exit 1
	fi
}

wait_for_globalprotect() {
	local attempt
	for attempt in {1..20}; do
		if osascript -e 'tell application "System Events" to exists process "GlobalProtect"' 2>/dev/null | grep -q true; then
			return 0
		fi
		sleep 0.5
	done

	return 1
}

vpn_control() {
	wait_for_globalprotect || return 1

	osascript - "$1" >/dev/null 2>&1 <<'APPLESCRIPT'
on run argv
	set wanted to item 1 of argv

	tell application "System Events" to tell process "GlobalProtect"
		if (count of windows) = 0 then
			click menu bar item 1 of menu bar 2
			delay 1.5
		end if

		if (count of windows) = 0 then error "the GlobalProtect panel did not open"
		set panel to window 1

		set state_reached to false

		repeat with label in static texts of panel
			set state_text to ""
			try
				set state_text to (value of label as text)
			end try
			if wanted is "Connect" and state_text is "Connected" then set state_reached to true
			if wanted is "Disconnect" and state_text is "Not Connected" then set state_reached to true
		end repeat

		if state_reached then
			my close_panel()
			return
		end if

		set control_clicked to false

		repeat with candidate in buttons of panel
			if (title of candidate as text) is wanted then
				click candidate
				set control_clicked to true
				exit repeat
			end if
		end repeat

		if not control_clicked then
			set options_menu to first pop up button of panel
			click options_menu
			delay 0.8

			repeat with candidate in menu items of menu 1 of options_menu
				try
					if (title of candidate as text) starts with wanted then
						click candidate
						set control_clicked to true
						exit repeat
					end if
				end try
			end repeat

			if not control_clicked then
				key code 53
				delay 0.5
			end if
		end if

		delay 1
		my close_panel()

		if not control_clicked then error "no " & wanted & " control found"
	end tell
end run

on close_panel()
	tell application "System Events" to tell process "GlobalProtect"
		if (count of windows) > 0 then
			click menu bar item 1 of menu bar 2
			delay 0.5
		end if
	end tell
end close_panel
APPLESCRIPT
}

if grep -q '^source "\$DOTFILES_PATH/modules/private/shell/idx\.sh"$' "$zshrc"; then
	avg_warning=""
	stop_avg
	avg_status=$?
	abort_if_cancelled "$avg_status"
	(( avg_status == 0 )) || avg_warning=", AVG still running"

	for file in "${rc_files[@]}"; do
		rewrite_file "$file" comment_idx_source
		rewrite_file "$file" comment_aidevtracker_source
	done

	npmrc_warning=""
	swap_npmrc "$npmrc_original" "$npmrc_idx" || npmrc_warning=", npmrc unchanged"

	if unload_globalprotect_agents; then
		globalprotect_result="GlobalProtect closed"
	else
		globalprotect_result="Could not close GlobalProtect"
	fi

	notify "IDX environment disabled" "$globalprotect_result$avg_warning$npmrc_warning"
else
	avg_warning=""
	start_avg
	avg_status=$?
	abort_if_cancelled "$avg_status"
	(( avg_status == 0 )) || avg_warning=", AVG not started"

	for file in "${rc_files[@]}"; do
		rewrite_file "$file" uncomment_idx_source
		rewrite_file "$file" uncomment_aidevtracker_source
	done

	npmrc_warning=""
	swap_npmrc "$npmrc_idx" "$npmrc_original" || npmrc_warning=", npmrc unchanged"

	if ! load_globalprotect_agents; then
		notify "IDX environment enabled" "Could not start GlobalProtect$avg_warning$npmrc_warning"
	elif vpn_control "Connect"; then
		notify "IDX environment enabled" "GlobalProtect is connecting$avg_warning$npmrc_warning"
	else
		notify "IDX environment enabled" "Connect GlobalProtect manually$avg_warning$npmrc_warning"
	fi
fi
