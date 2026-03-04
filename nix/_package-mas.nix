# Mac App Store apps — installed only if missing from /Applications
# Uses `mas install` under the hood, skipping already-installed apps

{ pkgs, ... }:

let
  masApps = {
    "Final Cut Pro" = 424389933;
    "GarageBand" = 682658836;
    "Keynote" = 361285480;
    "Numbers" = 361304891;
  };

  installScript = builtins.concatStringsSep "\n" (
    builtins.attrValues (
      builtins.mapAttrs (name: id: ''
        if [ ! -d "/Applications/${name}.app" ]; then
          echo "Installing ${name} from Mac App Store..."
          ${pkgs.mas}/bin/mas install ${toString id}
        fi
      '') masApps
    )
  );
in
{
  system.activationScripts.postActivation.text = installScript;
}
