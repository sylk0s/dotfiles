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
          enabled = config.modules.services.sops.enable;
          paths = listToAttrs (map (user: {
              name = user.name;
              value = config.sops.secrets."passwords/${user.name}".path;
            })
            cfg);
        };
      in
        mk-users config.userDefaults.extraGroups sops cfg;

      # DO THIS ONLY IF home-manager is a nixos module
      # sets up home manager for all the users above
      home-manager = let
        module-paths = sylib.all-modules-in-dir-rec "${inputs.self.outPath}/modules/home-manager";
      in {
        extraSpecialArgs = {inherit inputs sylib;};
        # for each user, generate a home-manager config
        users = mk-homes module-paths ./home.nix cfg;
        backupFileExtension = "backup";
      };
    }
    (
      mkIf config.modules.services.sops.enable {
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
