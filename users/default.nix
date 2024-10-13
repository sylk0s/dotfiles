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
  inherit (sylib) mk-homes all-modules-in-dir-rec;
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
            type = types.path;
          };
          extra-groups = mkOption {
            type = types.listOf types.str;
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
    users.users = listToAttrs (map (
        user: let
          pass = config.sops.secrets."passwords/${user.name}".path;
          # pass = null;
        in {
          name = user.name;
          value = {
            home = mkDefault "/home/${user.name}";
            initialPassword =
              if pass == null
              then "${user.name}"
              else null;
            hashedPasswordFile = pass;
            isNormalUser = true;
            createHome = true;
            extraGroups =
              (
                if user.privileged
                then ["wheel"]
                else []
              )
              ++ ["video" "input"]
              # ++ user.extra-groups
              ++ config.userDefaults.extraGroups;
          };
        }
      )
      cfg);

    # DO THIS ONLY IF home-manager is a nixos module
    # sets up home manager for all the users above
    home-manager = let
      module-paths = sylib.all-modules-in-dir-rec ../modules/home-manager;
    in {
      extraSpecialArgs = {inherit inputs sylib;};
      # for each user, generate a home-manager config
      users = mk-homes module-paths ./home.nix cfg;

      # listToAttrs (map (
      #     # maps to attr pair
      #     user: {
      #       name = user.name;
      #       value = {
      #         imports = [
      #           ./home.nix # default config for every user
      #           user.config # user specific config file
      #         ];
      #         # sets up user's info
      #         home = {
      #           username = user.name;
      #           homeDirectory = mkDefault "/home/${user.name}";
      #         };
      #       };
      #     }
      #   )
      #   cfg);
    };

    #   any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    # ];
    #   other config ...
  };
}
