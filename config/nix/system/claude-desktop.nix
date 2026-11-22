{
  lib,
  pkgs,
  username,
  ...
}:
let
  source = "/Users/${username}/.dotfiles/config/macos/claude-desktop/claude_desktop_config.json";
  target = "/Users/${username}/Library/Application Support/Claude/claude_desktop_config.json";
  jq = lib.getExe pkgs.jq;
in
{
  home.activation.mergeClaudeDesktopConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target=${lib.escapeShellArg target}
    source=${lib.escapeShellArg source}
    merged="$(mktemp)"

    if [ -f "$target" ] && ${jq} -s '.[0] * .[1]' "$target" "$source" > "$merged"; then
      run mv "$merged" "$target"
    elif [ ! -e "$target" ]; then
      run mkdir -p "$(dirname "$target")"
      run cp "$source" "$target"
      rm -f "$merged"
    else
      warnEcho "Could not merge $source into $target; leaving it untouched"
      rm -f "$merged"
    fi

    if [ -f "$target" ]; then
      run chmod 600 "$target"
    fi
  '';
}
