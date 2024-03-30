self: {
  flake-parts-lib,
  lib,
  ...
}: let
  inherit (lib) mkOption types mdDoc literalExpression;

  inherit (flake-parts-lib) mkPerSystemOption;

  submodule = {
    pkgs,
    config,
    system,
    ...
  }: let
    inherit (pkgs) runCommand;
  in {
    options = {
      run = mkOption {
        type = types.package;
        description = lib.mdDoc ''
          Do not use. Triggers the command
        '';
        readOnly = true;
        default = config.mkSettingsJson;
        defaultText = "<derivation>";
      };

      outDir = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          defaults to self.outPath
        '';
        default = self.outPath;
      };

      outName = mkOption {
        type = types.string;
        description = lib.mdDoc ''
          defaults to settings.json
        '';
        default = "settings.json";
      };

      configJson = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          the json
        '';

        # TODO switch to json
        default = self.string;
      };
    };
  };
in {
  options = {
    perSystem = mkPerSystemOption ({
      pkgs,
      system,
      ...
    }: {
      options = {
        settingsJson = mkOption {
          type = types.attrsOf (types.submoduleWith {
            modules = [submodule];
            specialArgs = {inherit system pkgs;};
          });

          default = {};
          description = mdDoc "";
          example = literalExpression ''
            TODO doc
          '';
        };
      };
    });
  };
}
