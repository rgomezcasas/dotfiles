{ config, pkgs, username, ... }:

{
	home.username = username;
	home.homeDirectory = "/Users/${username}";
	home.stateVersion = "24.05";

	home.packages = [];

	home.file = import ./_home-files.nix { inherit config; };

	home.sessionVariables = {};

	home.sessionPath = [
		"/run/current-system/sw/bin"
		"$HOME/.nix-profile/bin"
	];
	programs.home-manager.enable = true;
}
