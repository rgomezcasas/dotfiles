# https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable

{
	enable = true;
	taps = [];
	brews = [
		"bitwarden-cli"
		"choose-gui"
		"cliclick"
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
		"codex"
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
		"unifi-identity-endpoint"
		"visual-studio-code"
		"vlc"
		"wifiman"
		"zed"
	];
	masApps = {
		"Final Cut Pro"= 424389933;
		"GarageBand"= 682658836;
		"Keynote"= 361285480;
		"Numbers"= 361304891;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
}
