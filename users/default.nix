# Defaults and config for each user
{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) types mkOption listToAttrs map mkDefault mkMerge mkIf;
  inherit (sylib) mk-homes all-modules-in-dir-rec mk-users mk-opt;
  cfg = config.sylk.users;
in {
  options.sylk = {
    users = mkOption {
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
              type = types.nullOr types.path;
              default = null;
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

    userDefaults = {
      extraGroups = mk-opt (types.listOf types.str) [] "Default groups for all users";
    };
  };

  config = mkMerge [
    {
      # TODO
      # nix.settings = let
      #   users = ["root" config.user.name];
      # in {
      #   trusted-users = users;
      #   allowed-users = users;
      # };
      users.mutableUsers = false;

      # creates users from the user list above
      users.users = let
        # sops config struct for user config
        sops = {
          enabled = config.sylk.services.sops.enable;
          paths = listToAttrs (map (user: {
              name = user.name;
              value = config.sops.secrets."passwords/${user.name}".path;
            })
            cfg);
        };
      in
        mk-users config.sylk.userDefaults.extraGroups sops cfg;

      # DO THIS ONLY IF home-manager is a nixos module
      # sets up home manager for all the users above
      home-manager = let
        module-paths = sylib.all-modules-in-dir-rec "${inputs.self.outPath}/modules/home-manager";
        secrets =
          if config.sylk.services.git-crypt.enable
          then
            (listToAttrs (map (user: {
                name = user.name;
                value = builtins.fromJSON (builtins.readFile "${inputs.self.outPath}/secrets/git-crypt/secrets-${user.name}.json");
              })
              cfg))
          else null;
      in {
        extraSpecialArgs = {
          inherit inputs sylib secrets;
        };
        # for each user, generate a home-manager config
        users = mk-homes module-paths ./home.nix cfg;
        backupFileExtension = "backup";
        # TODO - this is a big fix from 3ulalia's closed PR
        # sharedModules = [inputs.niri.homeModules.niri];
      };
    }
    (
      mkIf config.sylk.services.sops.enable {
        # pulls in passwords if sops is enabled
        sops.secrets = listToAttrs (map (user: {
            name = "passwords/${user.name}";
            value = {
              neededForUsers = true;
            };
          })
          cfg);
      }
    )
  ];

  # sops assertion
}
