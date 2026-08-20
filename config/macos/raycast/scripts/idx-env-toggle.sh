#!/bin/zsh

# @raycast.schemaVersion 1
# @raycast.title IDX Env Toggle
# @raycast.packageName Environment
# @raycast.mode silent
# @raycast.icon 🛍️
# @raycast.description Enable or disable the IDX environment

export LC_ALL=en_US.UTF-8

dotfiles_path="$HOME/.dotfiles"
private_exports="$dotfiles_path/modules/private/shell/exports.sh"
shell_exports="$dotfiles_path/config/shell/exports.sh"

notify() {
	osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1
}

for file in "$private_exports" "$shell_exports"; do
	if [[ ! -f "$file" ]]; then
		notify "IDX environment" "File not found: $file"
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

uncomment_idx_block() {
	awk '
		/^# Inditex$/ { print; in_block = 1; next }
		/^# \/Inditex$/ { print; in_block = 0; next }
		in_block { sub(/^# ?/, ""); print; next }
		{ print }
	' "$1"
}

comment_idx_block() {
	awk '
		/^# Inditex$/ { print; in_block = 1; next }
		/^# \/Inditex$/ { print; in_block = 0; next }
		in_block { print ($0 == "" ? "#" : "# " $0); next }
		{ print }
	' "$1"
}

uncomment_asdf_shims() {
	sed 's|^\([[:space:]]*\)# \("\$ASDF_DATA_DIR/shims"\)|\1\2|' "$1"
}

comment_asdf_shims() {
	sed 's|^\([[:space:]]*\)\("\$ASDF_DATA_DIR/shims"\)|\1# \2|' "$1"
}

if grep -q '^export ITX_GITHUB_PAT' "$private_exports"; then
	rewrite_file "$private_exports" comment_idx_block
	rewrite_file "$shell_exports" comment_asdf_shims

	open -a GlobalProtect
	notify "IDX environment disabled" "Disconnect GlobalProtect to finish"
else
	rewrite_file "$private_exports" uncomment_idx_block
	rewrite_file "$shell_exports" uncomment_asdf_shims

	open -a GlobalProtect
	notify "IDX environment enabled" "Connect GlobalProtect to finish"
fi
