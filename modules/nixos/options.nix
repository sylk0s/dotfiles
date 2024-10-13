{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkIf types findFirst pathExists removePrefix;
  inherit (sylib) mk-enable mk-opt;
in {
  options = {
    dotfiles = {
      # TODO try to find path automagically
      dir = mk-opt types.path (removePrefix "/mnt"
        (findFirst pathExists (toString ../../.) [
          "/mnt/etc/dotfiles"
          "/etc/dotfiles"
          "/home/sylkos/dotfiles"
        ])) "Directory of the dotfiles";
      modulesDir = mk-opt types.path "${config.dotfiles.dir}/modules" "Path to modules";
      configDir = mk-opt types.path "${config.dotfiles.dir}/config" "Path to no-nix config";
      secretsDir = mk-opt types.path "${config.dotfiles.dir}/secrets" "Path to secrets";
    };

    # TODO confirm this is merging
    userDefaults = {
      extraGroups = mk-opt (types.listOf types.str) [] "Default groups for all users";
    };
  };

  config = {
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
