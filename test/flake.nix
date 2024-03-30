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
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [(inputs.call-flake ../.).flakeModule];

      debug = true;

      perSystem = {
        config,
        lib,
        pkgs,
        ...
      }: let
        testScript = out: exe: json: ''
          set -x

          ${exe}


        '';
      
        mkTestShell = outPath: exe: json:
          pkgs.mkShellNoCC {
            packages = [
              (pkgs.writeShellApplication {
                name = "run-ci";

                text = ''
                set -x

                ${exe}

                generated = echo -n ${outPath} | sha256sum

                [ "$generated" == "${json}" ] && exit 0 || exit 1
                '';
              })
            ];
          };
      in {
        settingsJson = {
            configJson = "hi!";
            outName = "settings.json";
        };


        devShells = {
            default = (
                "${config.settingsJson.outDir}/${config.settingsJson.outName}" 
                "${config.settingsJson.run}/bin/settingsJson" 
                config.settingsJson.configJson
            );
        };
      };
    };
}