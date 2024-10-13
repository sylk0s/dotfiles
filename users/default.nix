# Defaults and config for each user
{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) types mkOption listToAttrs map mkDefault;
  inherit (sylib) mk-homes all-modules-in-dir-rec mk-users;
  cfg = config.modules.users;
in {
  options.modules.users = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          privileged = mkOption {
            type = types.bool;
            default = false;
          };
          config = mkOption {
            type = types.path;
          };
          password = mkOption {
            type = types.nullOr types.path;
            default = null;
          };
          extra-groups = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
      }
    );
  };

  config = {
    # TODO
    # nix.settings = let
    #   users = ["root" config.user.name];
    # in {
    #   trusted-users = users;
    #   allowed-users = users;
    # };
    users.mutableUsers = false;

    # creates users from the user list above
    users.users = mk-users config.userDefaults.extraGroups cfg;

    # DO THIS ONLY IF home-manager is a nixos module
    # sets up home manager for all the users above
    home-manager = let
      module-paths = sylib.all-modules-in-dir-rec ../modules/home-manager;
    in {
      extraSpecialArgs = {inherit inputs sylib;};
      # for each user, generate a home-manager config
      users = mk-homes module-paths ./home.nix cfg;
    };
  };
}
