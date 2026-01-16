# https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable

{
	enable = true;
	taps = [];
	brews = [
		"bitwarden-cli"
		"choose-gui"
		"cliclick"
		"codex"
		"coreutils"
		"gemini-cli"
		"ollama"
		"sst/tap/opencode"
		"switchaudio-osx"
	];
	casks = [
		"adobe-creative-cloud"
		"arc"
		"betterdisplay"
		"bettermouse"
		"bitwarden"
		"claude"
		"claude-code"
		"cloudflare-warp"
		"contexts"
		"cursor"
		"displaylink"
		"elgato-camera-hub"
		"elgato-control-center"
		"elgato-stream-deck"
		"elgato-wave-link"
		"figma"
		"ghostty@tip"
		"google-chrome"
		"google-chrome@canary"
		"google-drive"
		"grandperspective"
		"handbrake-app"
		"imaging-edge"
		"jetbrains-toolbox"
		"karabiner-elements"
		"lm-studio"
		"meld-studio"
		"mqtt-explorer"
		"notion"
		"obs"
		"orbstack"
		"orion"
		"raycast"
		"shottr"
		"slack"
		"stremio"
		"superwhisper"
		"telegram"
		"visual-studio-code"
		"vlc"
		"zed"
	];
	masApps = {
		"Final Cut Pro"= 424389933;
		"GarageBand"= 682658836;
		"Keynote"= 409183694;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
}
