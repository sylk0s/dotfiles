{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
in {
    options.modules.shell.zsh = {
        enable = mkBoolOpt true;
    };

    config = mkIf cfg.enable {
        programs.zsh = {
            enable = true;
            shellAliases = {
                update = "sudo nixos-rebuild switch --flake .#";
            };
            histSize = 10000;

            ohMyZsh = {
                enable = true;
                plugins = [ 
                    "git" 
                    "thefuck" 
                    "rust"
                    "aliases"
                    "command-not-found"
                    "copybuffer"
                    "copyfile"
                    "encode64"
                    "extract"
                    "lol"
                    "web-search"
                ];
                theme = "powerlevel10k/powerlevel10k";
                custom = "/home/sylkos/dotfiles/config/oh-my-zsh/";
            };
        };

        user.packages = with pkgs; [
                thefuck
        ];
    };
}
