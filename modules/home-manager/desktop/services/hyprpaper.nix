{
  lib,
  sylib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.services.hyprpaper;
in {
  options.sylk.desktop.services.hyprpaper = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [
          "${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-far-from-tomorrow-1080px.jpg"
          "${inputs.self.outPath}/config/assets/wallpapers/nix-black-4k.png"
        ];

        # TODO add wallpapers to this
        wallpaper = [
          "eDP-1, ${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-far-from-tomorrow-1080px.jpg"
          ", ${inputs.self.outPath}/config/assets/wallpapers/nix-black-4k.png"
        ];
      };
    };
  };
}
