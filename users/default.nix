# Defaults and config for each user
{
  config,
  options,
  lib,
  inputs,
  outputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.users;
in {
  options.modules.users = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          priviledged = mkOption {
            type = types.bool;
            default = false;
          };
          config = mkOption {
            type = types.path;
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
            extraGroups =
              (
                if user.priviledged
                then ["wheel"]
                else []
              )
              ++ ["video" "input"]
              ++ config.userDefaults.extraGroups;
          };
        }
      )
      cfg);

    # DO THIS ONLY IF home-manager is a nixos module
    # sets up home manager for all the users above
    home-manager = {
      extraSpecialArgs = {inherit inputs outputs;};
      # for each user, generate a home-manager config
      users = listToAttrs (map (
          # maps to attr pair
          user: {
            name = user.name;
            value = {
              imports = [
                ./home.nix # default config for every user
                user.config # user specific config file
              ];
              # sets up user's info
              home = {
                username = user.name;
                homeDirectory = mkDefault "/home/${user.name}";
              };
            };
          }
        )
        cfg);
    };

    #   any assertations that should be checked
    # assertations = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    # ];
    #   other config ...
  };
}
