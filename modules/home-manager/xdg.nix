# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.
{
  config,
  lib,
  ...
}:
with lib; {
  ### A tidy $HOME is a tidy mind
  xdg = {
    enable = mkDefault true;

    #   desktopEntries = {
    #     thunar-settings = {
    #       name = "thunar-settings";
    #       genericName = "File Explorer";
    #       exec = "thunar %U";
    #       terminal = false;
    #     };
    #     thunar-bulk-rename = {
    #       name = "thunar-bulk-rename";
    #       genericName = "File Explorer";
    #       exec = "thunar %U";
    #       terminal = false;
    #     };
    #   };

    # TODO break this out of this module here
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/discord" = "discordcanary.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/spotify" = "spotify.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "Terminal" = "alacritty.desktop";
        "image/jpeg" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "text/plain" = "nvim.desktop";
      };
    };
  };

  home.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = mkDefault "$HOME/.cache";
    XDG_CONFIG_HOME = mkDefault "$HOME/.config";
    XDG_DATA_HOME = mkDefault "$HOME/.local/share";
    XDG_BIN_HOME = mkDefault "$HOME/.local/bin";
    # TODO the thing
    # EDITOR = "nvim";
    # BROWSER = "firefox";
    # TERMINAL = "alacritty";
    # __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    # CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    # HISTFILE = "$XDG_DATA_HOME/bash/history";
    # INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    # LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    # WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };

  # TODO
  # Move ~/.Xauthority out of $HOME (setting XAUTHORITY early isn't enough)
  #   extraInit = ''
  #     export XAUTHORITY=/tmp/Xauthority
  #     [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
  #   '';
}
