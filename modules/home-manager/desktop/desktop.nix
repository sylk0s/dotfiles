{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) filterAttrs isAttrs;
  inherit (sylib) mk-enable any-attrs count-attrs;
  cfg = config.sylk.desktop;
  desktop-num = count-attrs (n: v: v ? enable && v.enable) (filterAttrs (n: v: n != "enable") cfg);
in {
  options.sylk.desktop = {
    enable = mk-enable (desktop-num >= 1);
  };

  config = {
    assertions = [
      {
        assertion =
          cfg.enable
          || !(any-attrs
            (n: v: isAttrs v && (any-attrs (n: v: isAttrs v && v.enable) v))
            cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];
  };
}
