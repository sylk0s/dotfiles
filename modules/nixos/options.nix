{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) types;
  inherit (sylib) mk-opt;
in {
  options.sylk = {
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
