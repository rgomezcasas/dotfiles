{ config, lib, pkgs, username, ... }:

let
	cargoPackages = import ./_package-rust.nix;
in
{
	home.username = username;
	home.homeDirectory = "/Users/${username}";
	home.stateVersion = "24.05";

	home.packages = [];

	home.file = import ./_symlinks.nix { inherit config username; };

	home.sessionVariables = {};

	home.sessionPath = [
		"/run/current-system/sw/bin"
		"$HOME/.nix-profile/bin"
	];
	home.activation.installCargoPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
		${pkgs.cargo}/bin/cargo install ${builtins.concatStringsSep " " cargoPackages}
	'';

	programs.home-manager.enable = true;
}
