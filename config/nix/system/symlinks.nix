{ config, username, ... }:
let
  dotfilesPath = "/Users/${username}/.dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  ".bash_profile".source = symlink "${dotfilesPath}/config/shell/bash/.bash_profile";
  ".bashrc".source = symlink "${dotfilesPath}/config/shell/bash/.bashrc";
  ".claude.json".source = symlink "${dotfilesPath}/modules/private/claude/.claude.json";
  ".claude/CLAUDE.md".source = symlink "${dotfilesPath}/config/agents/GLOBAL_AGENTS.md";
  ".claude/settings.json".source = symlink "${dotfilesPath}/config/editors/claude-code/settings.json";
  ".claude/skills".source = symlink "${dotfilesPath}/config/agents/global_skills";
  ".claude/statusline-command.sh".source =
    symlink "${dotfilesPath}/config/editors/claude-code/statusline-command.sh";
  ".agents/skills".source = symlink "${dotfilesPath}/config/agents/global_skills";
  ".codex/AGENTS.md".source = symlink "${dotfilesPath}/config/agents/GLOBAL_AGENTS.md";
  ".codex/config.toml".source = symlink "${dotfilesPath}/config/editors/codex/config.toml";
  ".config/ghostty".source = symlink "${dotfilesPath}/config/macos/ghostty";
  ".config/karabiner".source = symlink "${dotfilesPath}/config/macos/karabiner-elements";
  ".config/karabiner.edn".source = symlink "${dotfilesPath}/config/macos/karabiner-goku/karabiner.edn";
  ".dotly".source = symlink "${dotfilesPath}/config/macos/.dotly";
  ".local/bin/idea".source =
    symlink "/Users/${username}/Library/Application Support/JetBrains/Toolbox/scripts/idea";
  ".gitattributes".source = symlink "${dotfilesPath}/config/git/.gitattributes";
  ".gitconfig".source = symlink "${dotfilesPath}/config/git/.gitconfig";
  ".gitignore_global".source = symlink "${dotfilesPath}/config/git/.gitignore_global";
  ".gnupg/gpg-agent.conf".source = symlink "${dotfilesPath}/modules/private/gnupg/gpg-agent.conf";
  ".npmrc".source = symlink "${dotfilesPath}/modules/private/js/.npmrc";
  ".profile".source = symlink "${dotfilesPath}/config/shell/bash/.profile";
  ".skhdrc".source = symlink "${dotfilesPath}/config/macos/skhd/.skhdrc";
  ".vimrc".source = symlink "${dotfilesPath}/config/editors/vim/.vimrc";
  ".zimrc".source = symlink "${dotfilesPath}/config/shell/zsh/.zimrc";
  ".zlogin".source = symlink "${dotfilesPath}/config/shell/zsh/.zlogin";
  ".zprofile".source = symlink "${dotfilesPath}/config/shell/zsh/.zprofile";
  ".zshenv".source = symlink "${dotfilesPath}/config/shell/zsh/.zshenv";
  ".zshrc".source = symlink "${dotfilesPath}/config/shell/zsh/.zshrc";
  "Library/Application Support/Claude/claude_desktop_config.json".source =
    symlink "${dotfilesPath}/config/macos/claude-desktop/claude_desktop_config.json";
  "Library/Application Support/Code - Insiders/User/keybindings.json".source =
    symlink "${dotfilesPath}/config/editors/code-oss/keybindings.json";
  "Library/Application Support/Code - Insiders/User/settings.json".source =
    symlink "${dotfilesPath}/config/editors/vscode/settings.json";
  "Library/Application Support/Code/User/keybindings.json".source =
    symlink "${dotfilesPath}/config/editors/code-oss/keybindings.json";
  "Library/Application Support/Code/User/settings.json".source =
    symlink "${dotfilesPath}/config/editors/vscode/settings.json";
  "Library/Application Support/Cursor/User/keybindings.json".source =
    symlink "${dotfilesPath}/config/editors/code-oss/keybindings.json";
  "Library/Application Support/Cursor/User/settings.json".source =
    symlink "${dotfilesPath}/config/editors/cursor/settings.json";
  "Library/Application Support/com.elgato.StreamDeck/ProfilesV2".source =
    symlink "${dotfilesPath}/modules/private/mac/streamdeck/ProfilesV2";
  "Library/Application Support/com.elgato.StreamDeck/ProfilesV3".source =
    symlink "${dotfilesPath}/modules/private/mac/streamdeck/ProfilesV3";
  "Library/Application Support/obs-studio/basic".source =
    symlink "${dotfilesPath}/modules/private/mac/obs/basic";
  "Library/LaunchAgents/com.user.cron.every_15s.plist".source =
    symlink "${dotfilesPath}/config/macos/LaunchAgents/com.user.cron.every_15s.plist";
}
