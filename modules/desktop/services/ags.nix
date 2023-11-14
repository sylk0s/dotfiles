{ config, options, lib, pkgs, inputs, ...}: 
with lib;
with lib.my;
let
    cfg = config.modules.desktop.services.ags;
in {
    options.modules.desktop.services.ags = {
        enable = mkBoolOpt false;
    };

    config = mkIf (cfg.enable) {

        environment.systemPackages = with pkgs; [
            sassc
            upower
        ];

        home-manager.users.${config.user.name} = {
            # add the home manager module
            imports = [ inputs.ags.homeManagerModules.default ];

            programs.ags = {
                enable = true;
                configDir = "${config.dotfiles.configDir}/ags";
                extraPackages = with pkgs; [ 
                    libsoup_3
                ];
            };
        };
    };
}
