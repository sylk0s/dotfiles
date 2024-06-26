{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop;
  desktopNum = countAttrs (n: v: v ? enable && v.enable) (filterAttrs (n: v: n != "enable") cfg);
in {
  options.modules.desktop = {
    enable = mkBoolOpt (desktopNum == 1);
  };

  config = {
    assertions = [
      {
        assertion = desktopNum < 2;

        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          cfg.enable
          || !(anyAttrs
            (n: v: isAttrs v && (anyAttrs (n: v: isAttrs v && v.enable) v))
            cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];
  };
}
