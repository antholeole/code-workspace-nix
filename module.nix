{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) mkOption types;

  inherit (pkgs) runCommand;

  submodule = {...}: {
    options = {
      run = mkOption {
        type = types.package;
        description = lib.mdDoc ''
          Do not use. Triggers the command
        '';
        readOnly = true;
        default = run;
        defaultText = "<derivation>";
      };

      rootSrc = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          defaults to self.outPath
        '';
        default = self.outPath;
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
    perSystem = mkPerSystemOption ({pkgs, ...}: {
      options = {
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
    });
    # code-workspace = {
    #   configJson = "hi";
    # };
  };
}
