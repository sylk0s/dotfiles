{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.shell.git;
  configDir = osConfig.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mk-enable true;
    userName = mk-str-opt "sylk0s";
    userEmail = mk-str-opt "julia@sylkos.xyz";
  };

  config = mkIf cfg.enable {
    # TODO update this
    programs.gh.enable = true;

    xdg.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      ignores = ["/.vscode" "/.pio" "/__pycache__" ".envrc" ".direnv" ".env" "/target"];
    };

    #modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
