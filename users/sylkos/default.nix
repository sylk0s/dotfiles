{
  config,
  pkgs,
  ...
}: {
  sylk = {
    desktop = {
      # hyprland.enable = true;
      niri.enable = true;
      # media.spotify.enable = true;
      social = {
        discord.enable = true;
        signal.enable = true;
        #fractal.enable = true;
      };
      apps = {
        firefox = {
          enable = true;
        };
        alacritty.enable = true;
        vscode.enable = true;
        thunar.enable = true;
      };
      gaming = {
        steam.enable = true;
        mc.enable = true;
        olympus.enable = true;
      };
      services = {
        dunst.enable = true;
        waybar.enable = true;
      };
    };

    shell = {
      eza.enable = true;
    };

    impermanence.enable = true;
  };

  home.packages = with pkgs; [
    kicad
    telegram-desktop
    element-desktop
  ];

  home.persistence = {
    "/persist/home/sylkos" = {
      directories = [
        ".local/share/TelegramDesktop"
        ".local/share/kicad"
      ];
    };
  };
}
