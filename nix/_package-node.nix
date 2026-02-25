{ pkgs, ... }:

with pkgs.nodePackages;
[
  typescript
  typescript-language-server
]
