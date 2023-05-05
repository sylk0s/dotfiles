{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt true;
    userName = mkStrOpt "sylk0s";
    userEmail = mkStrOpt "sylkos49@gmail.com";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      #gitAndTools.git-annex
      #unstable.gitAndTools.gh
      #gitAndTools.git-open
      #gitAndTools.diff-so-fancy
      #(mkIf config.modules.shell.gnupg.enable
      #  gitAndTools.git-crypt)
      #act
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    home-manager.users.${config.user.name} = {
      programs.git = {
	enable = true;
	userName = cfg.userName;
	userEmail = cfg.userEmail;
	ignores = ["/.vscode" "/.pio" "/__pycache__" ".envrc" ".direnv" ".env" ]
      }
    }

    #modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
