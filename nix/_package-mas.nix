# Mac App Store apps — installed only if missing from /Applications
# Uses `mas install` under the hood, skipping already-installed apps
# Runs as the console user since mas requires a logged-in App Store session

{ pkgs, config, ... }:

let
  masApps = {
    "Final Cut Pro" = 424389933;
    "GarageBand" = 682658836;
    "Keynote Creator Studio" = 361285480;
    "Numbers" = 361304891;
  };

  consoleUser = config.system.primaryUser;

  installScript = builtins.concatStringsSep "\n" (
    builtins.attrValues (
      builtins.mapAttrs (name: id: ''
        if [ ! -d "/Applications/${name}.app" ]; then
          echo "Installing ${name} from Mac App Store..."
          sudo -u ${consoleUser} ${pkgs.mas}/bin/mas install ${toString id}
        fi
      '') masApps
    )
  );
in
{
  system.activationScripts.postActivation.text = installScript;
}
