{
  config,
  pkgs,
  ...
}: {
  sylk = {
    desktop = {
      hyprland = {
        enable = true;
      };
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
        #  mc.enable = true;
      };
      services = {
        #  ags = {
        #    enable = true;
        #  };
        #  kdeconnect.enable = true;
        dunst.enable = true;
        waybar.enable = true;
      };
    };
    dev = {
      #python.enable = true;
      #rust.enable = true;
      #julia.enable = true;
      #c.enable = true;
      #embedded.enable = false;
    };

    shell = {
      eza.enable = true;
    };

    impermanence.enable = true;
  };

  home.packages = with pkgs; [
    #kicad
  ];
}
