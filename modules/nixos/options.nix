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
    dotfiles = {
      # TODO try to find path automagically
      dir = mkOpt types.path (removePrefix "/mnt"
        (findFirst pathExists (toString ../../.) [
          "/mnt/etc/dotfiles"
          "/etc/dotfiles"
          "/home/sylkos/dotfiles"
        ]));
      modulesDir = mkOpt types.path "${config.dotfiles.dir}/modules";
      configDir = mkOpt types.path "${config.dotfiles.dir}/config";
      secretsDir = mkOpt types.path "${config.dotfiles.dir}/secrets";
    };

    # TODO confirm this is merging
    userDefaults = {
      extraGroups = mkOpt (types.listOf types.str) [];
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
