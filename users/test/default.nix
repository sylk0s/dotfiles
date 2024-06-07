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
      };
      services = {
        ags = {
          enable = true;
        };
      };
    };
    dev = {
      julia.enable = true;
    };
  };
}
