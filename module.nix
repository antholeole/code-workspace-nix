self: {
  flake-parts-lib,
  lib,
  ...
}: let
  inherit (lib) mkOption types mdDoc literalExpression;

  inherit (flake-parts-lib) mkPerSystemOption;

  codeWorkspaceSubmodule = {
    pkgs,
    config,
    system,
    ...
  }: {
    options = {
      package = mkOption {
        type = types.package;
        description = lib.mdDoc ''
          Do not use. Triggers the command
        '';
        readOnly = true;
      };

      outDir = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          defaults to self.outPath
        '';
        default = self;
      };

      outName = mkOption {
        type = types.string;
        description = lib.mdDoc ''
          defaults to settings.json
        '';
        default = "settings.json";
      };

      configJson = mkOption {
        type = types.string;
        description = lib.mdDoc ''
          the json
        '';
      };
    };

    config = {
      package = self.lib.${system}.mkSettingsJson {
        inherit (config) outDir outName;
      };
    };
  };
in {
  options = {
    perSystem = mkPerSystemOption ({
      system,
      pkgs,
      ...
    }: {
      options = {
        codeWorkspace = mkOption {
          type = types.attrsOf (types.submoduleWith {
            modules = [codeWorkspaceSubmodule];
            specialArgs = {inherit system pkgs;};
          });

          default = {};
          description = mdDoc "Attribute set containing procfile declarations";
          example = literalExpression ''
            {
              daemons.processes = {
                redis = lib.getExe' pkgs.redis "redis-server";
              };
            }
          '';
        };
      };
    });
  };
}
