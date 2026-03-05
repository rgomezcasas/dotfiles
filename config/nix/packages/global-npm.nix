{ pkgs, username, ... }:

let
  packages = [
    "ccusage"
  ];
  npmPrefix = "/Users/${username}/.cache/npm/global";
in
{
  system.activationScripts.globalNpm.text = ''
    echo "Installing global npm packages: ${builtins.concatStringsSep " " packages}"
    sudo -u ${username} ${pkgs.nodejs_24}/bin/npm install -g --prefix ${npmPrefix} ${builtins.concatStringsSep " " packages}
  '';
}
