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
  cfg = config.modules.shell.git;
  configDir = osConfig.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt true;
    userName = mkStrOpt "sylk0s";
    userEmail = mkStrOpt "julia@sylkos.xyz";
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
