{ pkgs, config, ... }:

let
  packages = [
    "docpars"
  ];
  consoleUser = config.system.primaryUser;
in
{
  system.activationScripts.postActivation.text = ''
    echo "Installing cargo packages: ${builtins.concatStringsSep " " packages}"
    sudo -u ${consoleUser} --set-home ${pkgs.cargo}/bin/cargo install ${builtins.concatStringsSep " " packages}
  '';
}
