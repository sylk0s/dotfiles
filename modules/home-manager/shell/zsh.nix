{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.shell.zsh;
in {
  options.sylk.shell.zsh = {
    enable = mk-enable true;
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
        # custom = "${inputs.self.outPath}/config/oh-my-zsh/";
      };
    };
  };
}
