{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf types findFirst pathExists toString removePrefix;
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
      modulesDir = mk-opt types.path "${config.dotfiles.dir}/modules";
      configDir = mk-opt types.path "${config.dotfiles.dir}/config";
      secretsDir = mk-opt types.path "${config.dotfiles.dir}/secrets";
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
