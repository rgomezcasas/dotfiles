{ config, ... }:
let
	dotfilesPath = "/Users/rafa.gomez/.dotfiles";
	symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
	".bash_profile".source = symlink "${dotfilesPath}/shell/bash/.bash_profile";
	".bashrc".source = symlink "${dotfilesPath}/shell/bash/.bashrc";
	".claude.json".source = symlink "${dotfilesPath}/modules/private/claude/.claude.json";
	".claude/settings.json".source = symlink "${dotfilesPath}/editors/claude-code/settings.json";
	".config/alacritty/alacritty.toml".source = symlink "${dotfilesPath}/os/mac/alacritty/alacritty.toml";
	".config/clojure-lsp".source = symlink "${dotfilesPath}/langs/clojure/clojure-lsp";
	".config/clojure/profiles.clj".source = symlink "${dotfilesPath}/langs/clojure/profiles.clj";
	".config/ghostty".source = symlink "${dotfilesPath}/os/mac/ghostty";
	".config/karabiner".source = symlink "${dotfilesPath}/os/mac/karabiner-elements";
	".config/karabiner.edn".source = symlink "${dotfilesPath}/os/mac/karabiner-goku/karabiner.edn";
	".config/kitty".source = symlink "${dotfilesPath}/os/mac/kitty";
	".config/linearmouse".source = symlink "${dotfilesPath}/os/mac/linearmouse";
	".config/sketchybar".source = symlink "${dotfilesPath}/os/mac/sketchybar";
	".config/yabai".source = symlink "${dotfilesPath}/os/mac/yabai";
	".dotly".source = symlink "${dotfilesPath}/os/mac/.dotly";
	".gitattributes".source = symlink "${dotfilesPath}/git/.gitattributes";
	".gitconfig".source = symlink "${dotfilesPath}/git/.gitconfig";
	".gitignore_global".source = symlink "${dotfilesPath}/git/.gitignore_global";
	".gnupg/gpg-agent.conf".source = symlink "${dotfilesPath}/modules/private/gnupg/gpg-agent.conf";
	".profile".source = symlink "${dotfilesPath}/shell/bash/.profile";
	".sbt/1.0/plugins/plugins.sbt".source = symlink "${dotfilesPath}/langs/scala/plugins.sbt";
	".skhdrc".source = symlink "${dotfilesPath}/os/mac/skhd/.skhdrc";
	".tmux.conf".source = symlink "${dotfilesPath}/os/mac/.tmux.conf";
	".vimrc".source = symlink "${dotfilesPath}/editors/vim/.vimrc";
	".zimrc".source = symlink "${dotfilesPath}/shell/zsh/.zimrc";
	".zlogin".source = symlink "${dotfilesPath}/shell/zsh/.zlogin";
	".zprofile".source = symlink "${dotfilesPath}/shell/zsh/.zprofile";
	".zshenv".source = symlink "${dotfilesPath}/shell/zsh/.zshenv";
	".zshrc".source = symlink "${dotfilesPath}/shell/zsh/.zshrc";
	"Library/Application Support/Cursor/User/keybindings.json".source = symlink "${dotfilesPath}/editors/cursor/keybindings.json";
	"Library/Application Support/Cursor/User/settings.json".source = symlink "${dotfilesPath}/editors/cursor/settings.json";
	"Library/Application Support/Cursor/User/snippets".source = symlink "${dotfilesPath}/editors/cursor/snippets";
	"Library/Application Support/com.elgato.StreamDeck/ProfilesV2".source = symlink "${dotfilesPath}/modules/private/mac/streamdeck/ProfilesV2";
	"Library/Application Support/obs-studio/basic".source = symlink "${dotfilesPath}/modules/private/mac/obs/basic";
	"Library/Application Support/obs-studio/global.ini".source = symlink "${dotfilesPath}/modules/private/mac/obs/global.ini";
	"Library/Application Support/zen/Profiles/8fh0vfxw.Default (alpha)/chrome/userChrome.css".source = symlink "${dotfilesPath}/os/mac/zen/userChrome.css";
	"Library/LaunchAgents/com.user.disable.airpods.microphone.plist".source = symlink "${dotfilesPath}/os/mac/LaunchAgents/com.user.disable.airpods.microphone.plist";
	"Library/LaunchAgents/com.user.toggle.menubar.plist".source = symlink "${dotfilesPath}/os/mac/LaunchAgents/com.user.toggle.menubar.plist";
}
