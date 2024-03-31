let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  nixpkgs' = fetchTarball {
    url =
      lock.nodes.nixpkgs.locked.url or "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  };
in { nixpkgs ? import nixpkgs' {
  config = { };
  overlays = [ ];
  inherit system;
}, system ? builtins.currentSystem, }:
let
  pkgs = nixpkgs;
  inherit (pkgs) 
    runCommand
    writeTextFile
  ;
in {
  mkSettingsJson = { outName, outDir, ... }: writeTextFile {
    name = "settings.json";
    text = ''
      Contents of File
    '';
  }
