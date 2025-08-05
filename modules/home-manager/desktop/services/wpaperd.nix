{
  lib,
  sylib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.services.wpaperd;
in {
  options.sylk.desktop.services.wpaperd = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.wpaperd = {
      enable = true;
# TODO make this more configurable
      settings = {
        "eDP-1".path = "${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-clouds-1k.jpg";
        default.path = "${inputs.self.outPath}/config/assets/wallpapers/nix-black-4k.png";
      };
    };
  };
}
