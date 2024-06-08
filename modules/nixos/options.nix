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
    };

    # TODO confirm this is merging
    userDefaults = {
      extraGroups = mkOpt (types.listOf types.str) [];
    };
  };

  config = {
    # # any assertations that should be checked
    # assertations = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];
    # # other config ...
  };
}
