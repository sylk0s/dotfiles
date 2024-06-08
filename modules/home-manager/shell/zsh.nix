{
  config,
  osConfig,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
      };
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "rust"
          "aliases"
          "copybuffer"
          "copyfile"
          "encode64"
          "extract"
          "lol"
          "web-search"
        ];

        # theme = "powerlevel10k/powerlevel10k";
        # custom = "${osConfig.dotfiles.configDir}/oh-my-zsh/";
      };
    };
  };
}
