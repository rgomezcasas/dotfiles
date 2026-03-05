{ pkgs, ... }:

let
  packages = [
    "ccusage"
  ];
in
{
  system.activationScripts.globalNpm.text = ''
    echo "Installing global npm packages: ${builtins.concatStringsSep " " packages}"
    ${pkgs.nodejs_24}/bin/npm install -g ${builtins.concatStringsSep " " packages} 2>/dev/null
  '';
}
