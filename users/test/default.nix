{config, ...}: {
  modules = {
    desktop = {
      hyprland = {
        enable = true;
      };
      social = {
        discord.enable = true;
      };
      apps = {
        firefox = {
          enable = true;
        };
        alacritty.enable = true;
      };
      services = {
        ags = {
          enable = true;
        };
      };
    };
    shell.eza.enable = true;
    impermanence.enable = true;
  };
}
