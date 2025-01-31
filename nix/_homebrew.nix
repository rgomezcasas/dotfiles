# https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable

{
	enable = true;
	taps = [];
	brews = [
		"cliclick"
		"choose-gui"
		"switchaudio-osx"
	];
	casks = [
		"adobe-creative-cloud"
		"arc"
		"betterdisplay"
		"capcut"
		"cloudflare-warp"
		"contexts"
		"cursor"
		"displaylink"
		"elgato-camera-hub"
		"elgato-control-center"
		"elgato-stream-deck"
		"figma"
		"google-chrome@canary"
		"google-drive"
		"grandperspective"
		"handbrake"
		"iina"
		"iterm2"
		"jetbrains-toolbox"
		"karabiner-elements"
		"notion"
		"obs"
		"orion"
		"orbstack"
		"raycast"
		"shottr"
		"shureplus-motiv"
		"slack"
		"stremio"
		"superwhisper"
		"telegram"
		"visual-studio-code"
		"zed"
		"zen-browser"
	];
	masApps = {
		"Bitwarden" = 1352778147;
		"Final Cut Pro"= 424389933;
		"GarageBand"= 682658836;
		"Gifski"= 1351639930;
		"Keynote"= 409183694;
		"Wipr"= 1320666476;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
}
