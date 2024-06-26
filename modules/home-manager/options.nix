{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
in {
  options = {
  };

  config = {
    # TODO
    # - styling options

    # TODO s
    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    # env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];

    # home-manager = {
    #   useUserPackages = true;
    #   useGlobalPkgs = true;
    # };

    # # any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];
    # # other config ...
  };
}
