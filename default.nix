let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  nixpkgs' = fetchTarball {
    url = lock.nodes.nixpkgs.locked.url or "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  };
in
  {
    nixpkgs ?
      import nixpkgs' {
        config = {};
        overlays = [];
        inherit system;
      },
    system ? builtins.currentSystem,
  }: let
    inherit
      (pkgs)
      runCommand
      ;

    outFile =
      runCommand "settings.json" {
        buildInputs = [
          pkgs.jq
        ];

        passAsFile = ["rawJSON"];
        rawJSON = builtins.toJSON config.rawConfig;
      } ''
        echo "HELLO" >$out
      '';
  in {
    mkSettingsJson = {outDir, ...}:
      runCommand "settingJson" {buildInputs = [];} ''
        ln -fs ${outFile} ${outDir}/.pre-commit-config.yaml

        touch $out
      '';
  }
