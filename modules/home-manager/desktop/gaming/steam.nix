{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO
    # eventually i wanna move this here
    home.packages = with pkgs; [
      steam-tui
      steamPackages.steamcmd
    ];

    # for now...
    # callback to callbacks/steam.nix
    home.persistence."/persist/home/${config.home.username}" = {
      directories = [
        ".steam"
        ".local/share/Steam/"
        ".local/share/vulkan/"
      ];
    };
  };
}
