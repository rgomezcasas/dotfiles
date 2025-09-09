{
	description = "Rafa Darwin system flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
	let
		hostname = "RafaComputerPro";
		username = "rafa.gomez";
		configuration = { pkgs, ... }: {
			nixpkgs.config.allowUnfree = true;

			networking.hostName = hostname;
			networking.computerName = hostname;

			users.users."${username}" = {
				name = username;
				home = "/Users/${username}";
				description = username;
			};

			environment.systemPackages = import ./_packages.nix { inherit pkgs; };
			homebrew = import ./_homebrew.nix;

			home-manager.backupFileExtension = "bkp_" + builtins.toString builtins.currentTime;

			# https://daiderd.com/nix-darwin/manual/index.html#:~:text=system/version.nix%3E-,system.defaults,-.%22.GlobalPreferences%22.%22com.apple
			system.defaults = import ./_macos-defaults.nix;
			system.keyboard.enableKeyMapping = true;
			system.keyboard.remapCapsLockToEscape = true;
			system.primaryUser = username;

			# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";
			nix.settings.download-buffer-size = 100000000;

			# Create /etc/zshrc that loads the nix-darwin environment.
			programs.zsh.enable = true;
			programs.zsh.enableCompletion = true;
			programs.zsh.enableBashCompletion = true;

			# Set Git commit hash for darwin-version.
			system.configurationRevision = self.rev or self.dirtyRev or null;

			# Used for backwards compatibility, please read the changelog before changing.
			# $ darwin-rebuild changelog
			system.stateVersion = 5;

			# The platform the configuration will be used on.
			nixpkgs.hostPlatform = "aarch64-darwin";
		};
	in
	{
		# Build darwin flake using:
		# $ darwin-rebuild build --flake .#pro
		darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
			modules = [
				configuration
				nix-homebrew.darwinModules.nix-homebrew
				{
					nix-homebrew = {
						enable = true;
						enableRosetta = true;
						user = username;

						autoMigrate = true;
					};
				}
				home-manager.darwinModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit username; };
					home-manager.users."${username}" = import ./home.nix;
				}
			];
		};

		# Expose the package set, including overlays, for convenience.
		darwinPackages = self.darwinConfigurations."pro".pkgs;
	};
}
