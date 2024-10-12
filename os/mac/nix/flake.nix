{
  description = "Rafa Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.zsh
        pkgs.bat
        pkgs.cmatrix
        pkgs.delta
        pkgs.php83Packages.composer
        pkgs.coreutils
        pkgs.eza
        pkgs.gnupg
        pkgs.ffmpeg
        pkgs.fzf
        pkgs.gh
        pkgs.git
        pkgs.git-lfs
        pkgs.go
        pkgs.gradle
        pkgs.htop
        pkgs.hyperfine
        pkgs.nodejs_20
        pkgs.ollama
        pkgs.jdk21
        pkgs.php81
        pkgs.python39
        pkgs.rustc
        pkgs.shellcheck
        pkgs.shfmt
        pkgs.sl
        pkgs.tldr
        pkgs.tmux
        pkgs.tree
        pkgs.watch
        pkgs.wget
        pkgs.yarn
        pkgs.yt-dlp
        pkgs.z-lua
        pkgs.goku
        # gui
        pkgs.gum
        pkgs.choose-gui
        pkgs.skhd
        pkgs.mas
        pkgs.pinentry_mac
      ];

      # https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable
	  homebrew = {
	    enable = true;
		casks = [
		  "adobe-creative-cloud"
          "arc"
          "betterdisplay"
          "capcut"
          "cloudflare-warp"
          "cursor"
          "contexts"
          "displaylink"
          "elgato-camera-hub"
          "elgato-control-center"
          "elgato-stream-deck"
          "figma"
          "google-chrome@canary"
          "google-drive"
          "grandperspective"
          "handbrake"
          "iterm2"
          "jetbrains-toolbox"
          "karabiner-elements"
          "notion"
          "obs"
          "orbstack"
          "raycast"
          "shottr"
          "shureplus-motiv"
          "slack"
          "stremio"
          "telegram"
          "visual-studio-code"
          "iina"
          "zed"
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
	  };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

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
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "rafa.gomez";

            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."pro".pkgs;
  };
}
