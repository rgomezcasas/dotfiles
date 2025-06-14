# https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable

{
	enable = true;
	taps = [];
	brews = [
		"choose-gui"
		"cliclick"
		"switchaudio-osx"
	];
	casks = [
		"adobe-creative-cloud"
		"arc"
		"betterdisplay"
		"cloudflare-warp"
		"contexts"
		"cursor"
		"displaylink"
		"elgato-camera-hub"
		"elgato-control-center"
		"elgato-stream-deck"
		"elgato-wave-link"
		"figma"
		"google-chrome@canary"
		"google-drive"
		"grandperspective"
		"handbrake"
		"jetbrains-toolbox"
		"karabiner-elements"
		"meld-studio"
		"microsoft-edge"
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
		"zen-browser"
	];
	masApps = {
#		"Bitwarden" = 1352778147;
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
