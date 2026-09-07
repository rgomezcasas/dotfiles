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

wait_for_globalprotect() {
	open -a GlobalProtect || return 1

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
	for file in "${rc_files[@]}"; do
		rewrite_file "$file" comment_idx_source
		rewrite_file "$file" comment_aidevtracker_source
	done

	npmrc_warning=""
	swap_npmrc "$npmrc_original" "$npmrc_idx" || npmrc_warning=", npmrc unchanged"

	if vpn_control "Disconnect"; then
		notify "IDX environment disabled" "GlobalProtect is disconnecting$npmrc_warning"
	else
		notify "IDX environment disabled" "Disconnect GlobalProtect manually$npmrc_warning"
	fi
else
	for file in "${rc_files[@]}"; do
		rewrite_file "$file" uncomment_idx_source
		rewrite_file "$file" uncomment_aidevtracker_source
	done

	npmrc_warning=""
	swap_npmrc "$npmrc_idx" "$npmrc_original" || npmrc_warning=", npmrc unchanged"

	if vpn_control "Connect"; then
		notify "IDX environment enabled" "GlobalProtect is connecting$npmrc_warning"
	else
		notify "IDX environment enabled" "Connect GlobalProtect manually$npmrc_warning"
	fi
fi
