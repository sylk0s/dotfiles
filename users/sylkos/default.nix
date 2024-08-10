{
  config,
  pkgs,
  ...
}: {
  modules = {
    desktop = {
      hyprland = {
        enable = true;
      };
      # gnome = {
      #   enable = true;
      # };
      # cosmic.enable = true;
      media.spotify.enable = true;
      social = {
        discord.enable = true;
        signal.enable = true;
        thunderbird.enable = true;
      };
      apps = {
        firefox = {
          enable = true;
          profileName = "ahpu6nkm";
        };
        intellij.enable = true;
        alacritty.enable = true;
        vscode.enable = true;
        thunar.enable = true;
        zed.enable = true;
      };
      #   security = {
      #     cutter.enable = false;
      #     wireshark.enable = true;
      #     ghidra.enable = true;
      #     burpsuite.enable = true;
      #   };
      gaming = {
        steam.enable = true;
        mc.enable = true;
        emu.enable = false;
      };
      services = {
        ags = {
          enable = true;
        };
        kdeconnect.enable = true;
        # dunst.enable = false;
      };
    };
    dev = {
      python.enable = true;
      # TODO Hello?
      #rust.enable = true;
      julia.enable = true;
      java.enable = true;
      # TODO Hello?
      #c.enable = true;
      racket.enable = true;
      haskell.enable = true;
      embedded.enable = true;
    };

    shell = {
      eza.enable = true;
    };

    impermanence.enable = true;
  };

  home.packages = with pkgs; [
    kicad
  ];
}
