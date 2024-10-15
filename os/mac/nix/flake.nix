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
				pkgs.findutils
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
				pkgs.unrar
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
				pkgs.kitty
			];

			# https://daiderd.com/nix-darwin/manual/index.html#:~:text=darwin/modules/fonts%3E-,homebrew.enable,-Whether%20to%20enable
			homebrew = {
				enable = true;
				taps = [];
				brews = ["cliclick"];
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

			# https://daiderd.com/nix-darwin/manual/index.html#:~:text=system/version.nix%3E-,system.defaults,-.%22.GlobalPreferences%22.%22com.apple
			system.defaults = {
				".GlobalPreferences"."com.apple.mouse.scaling" = 0.875;
				ActivityMonitor.IconType = 6; # Show CPU history
				ActivityMonitor.OpenMainWindow = true;
				ActivityMonitor.ShowCategory = 101; # All Processes, Hierarchally
				ActivityMonitor.SortColumn = "CPUUsage";
				ActivityMonitor.SortDirection = 0; # Descending
				LaunchServices.LSQuarantine = false;
				NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = true;
				NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = true;
				NSGlobalDomain.AppleFontSmoothing = null;
				NSGlobalDomain.AppleICUForce24HourTime = true;
				NSGlobalDomain.AppleInterfaceStyle = "Dark";
				NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;
				NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
				NSGlobalDomain.AppleMetricUnits = 1;
				NSGlobalDomain.ApplePressAndHoldEnabled = true;
				NSGlobalDomain.AppleShowAllExtensions = true;
				NSGlobalDomain.AppleShowAllFiles = false;
				NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
				NSGlobalDomain.AppleTemperatureUnit = "Celsius";
				NSGlobalDomain.InitialKeyRepeat = 12;
				NSGlobalDomain.KeyRepeat = 1;
				NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
				NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
				NSGlobalDomain.NSAutomaticInlinePredictionEnabled = true;
				NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
				NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
				NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
				NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = true;
				NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
				NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
				NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
				NSGlobalDomain.NSScrollAnimationEnabled = true;
				NSGlobalDomain.NSTableViewDefaultSizeMode = 3;
				NSGlobalDomain.NSWindowShouldDragOnGesture = false;
				NSGlobalDomain._HIHideMenuBar = true;
				NSGlobalDomain."com.apple.keyboard.fnState" = false;
				NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
				NSGlobalDomain."com.apple.swipescrolldirection" = true;

				SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
				WindowManager.EnableStandardClickToShowDesktop = false;
				WindowManager.GloballyEnabled = false;
				dock = {
					enable-spring-load-actions-on-all-items = false;
					appswitcher-all-displays = true;
					autohide = true;
					autohide-delay = 0.20;
					autohide-time-modifier = 1.0;
					largesize = 16;
					launchanim = true;
					magnification = false;
					mineffect = "genie";
					minimize-to-application = true;
					mru-spaces = false;
					orientation = "left";
					persistent-apps = [
						"/System/Volumes/Data/Applications/Arc.app"
					];
					persistent-others = null;
					show-process-indicators = true;
					show-recents = false;
					showhidden = true;
					slow-motion-allowed = false;
					tilesize = 43;
					wvous-bl-corner = 1;
					wvous-br-corner = 1;
					wvous-tl-corner = 1;
					wvous-tr-corner = 1;
				};
				finder = {
					AppleShowAllExtensions = true;
					AppleShowAllFiles = false;
					CreateDesktop = true;
					FXDefaultSearchScope = "SCcf";
					FXEnableExtensionChangeWarning = false;
					FXPreferredViewStyle = "clmv";
					QuitMenuItem = false;
					ShowPathbar = true;
					ShowStatusBar = true;
					_FXShowPosixPathInTitle = false;
					_FXSortFoldersFirst = true;
				};
				loginwindow.DisableConsoleAccess = true;
				loginwindow.GuestEnabled = false;
				menuExtraClock.IsAnalog = false;
				menuExtraClock.Show24Hour = true;
				menuExtraClock.ShowAMPM = false;
				menuExtraClock.ShowDate = 1;
				menuExtraClock.ShowDayOfMonth = true;
				menuExtraClock.ShowDayOfWeek = true;
				menuExtraClock.ShowSeconds = false;
				screencapture.show-thumbnail = false;
				screensaver.askForPassword = true;
				spaces.spans-displays = false;
				trackpad.ActuationStrength = 0;
				trackpad.Clicking = true;
				trackpad.Dragging = false;
				trackpad.TrackpadRightClick = true;
				trackpad.TrackpadThreeFingerDrag = false;
				trackpad.TrackpadThreeFingerTapGesture = 0;
				universalaccess.closeViewScrollWheelToggle = true;
				universalaccess.closeViewZoomFollowsFocus = true;
				universalaccess.reduceMotion = false;
				universalaccess.reduceTransparency = false;
			};
			system.keyboard.enableKeyMapping = true;
			system.keyboard.remapCapsLockToEscape = true;

			# Auto upgrade nix package and the daemon service.
			services.nix-daemon.enable = true;
			# nix.package = pkgs.nix;

			# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";

			# Create /etc/zshrc that loads the nix-darwin environment.
			programs.zsh.enable = true;
			programs.zsh.enableCompletion = false;
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
