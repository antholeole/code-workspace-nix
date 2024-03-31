{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    call-flake.url = "github:divnix/call-flake";
  };

  outputs = inputs:
    inputs.parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports = [(inputs.call-flake ../.).flakeModule];

      debug = true;

      perSystem = {
        config,
        lib,
        pkgs,
        ...
      }: {
        codeWorkspace.settings = {
          outDir = ./.;
          outName = "settings.json";
          # configJson = "BLAH";
        };

        # TODO: can run concurrently. defaults. etc
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            (pkgs.writeShellScriptBin "run-ci" ''
              set -x

              #exec ${lib.getExe config.codeWorkspace.settings.package}
            '')
          ];
        };
      };
    };
}
