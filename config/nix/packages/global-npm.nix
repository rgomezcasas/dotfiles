{ pkgs, config, ... }:

let
  packages = [
    "ccusage"
  ];
  consoleUser = config.system.primaryUser;
  npmPrefix = "/Users/${consoleUser}/.cache/npm/global";
in
{
  system.activationScripts.postActivation.text = ''
    echo "Installing global npm packages: ${builtins.concatStringsSep " " packages}"
    sudo -u ${consoleUser} ${pkgs.nodejs_24}/bin/npm install -g --prefix ${npmPrefix} ${builtins.concatStringsSep " " packages}
  '';
}
