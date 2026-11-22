{ pkgs, config, ... }:

let
  packages = [
    "@github/copilot"
    "ccusage"
    "turbo"
    "typescript"
  ];
  consoleUser = config.system.primaryUser;
  npmPrefix = "/Users/${consoleUser}/.cache/npm/global";
  nodeBinDir = "/opt/homebrew/opt/node@24/bin";
  npmBin = "${nodeBinDir}/npm";
in
{
  system.activationScripts.postActivation.text = ''
    if [ -x "${npmBin}" ]; then
      echo "Installing global npm packages: ${builtins.concatStringsSep " " packages}"
      sudo -u ${consoleUser} --set-home env PATH="${nodeBinDir}:$PATH" ${npmBin} install -g --prefix ${npmPrefix} ${builtins.concatStringsSep " " packages} \
        || echo "warning: global npm install failed; skipping (system switch will continue)"
    else
      echo "node@24 npm not found at ${npmBin}; skipping global npm install (re-run darwin-rebuild after Homebrew installs node@24)"
    fi
  '';
}
