# Configuration for the Alacritty terminal
{ config, options, lib, pkgs, ...}: 
with lib;
with lib.my;
let
    colorScheme = config.modules.themes.colors;
    fontStyles = config.modules.themes.fonts.styles;
    cfg = config.modules.desktop.apps.alacritty;
in {
    options.modules.desktop.apps.alacritty = {
        enable = mkBoolOpt true;
    };

    config = lib.mkIf (cfg.enable) {
        # home manager configuration
        home-manager.users.${config.user.name}.programs.alacritty = {
            enable = true;
                settings = {
                    # window settings
                    window = {
                        padding = {
                            x = 4;
                            y = 4;
                        };
                        dynamic_padding = true;
                        opacity = 1;
                    };

                    # max lines in buffer
                    scolling.history = 10000;

                    # font config
                    font = let
                            mono = fontStyles.mono;
                        in {
                            normal = {
                                family = mono.family;
                                style = "Regular";
                            };
                            bold = {
                                family = mono.family;
                                style = "Bold";
                            };
                            italic = {
                                family = mono.family;
                                style = "Italic";
                            };
                            bold_italic = {
                                family = mono.family;
                                style = "Bold Italic";
                            };
                            size = mono.size;
                        };

                    draw_bold_text_with_bright_colors = true;

                    # colorscheme
                    colors = let
                        cc = colorScheme.colors;
                        ct = colorScheme.types;
                in {
                    primary = {
                        background = ct.background;
                        foreground = ct.foreground;
                    };
                    normal = {
                        black = cc.color0;
                        red = cc.color1;
                        green = cc.color2;
                        yellow = cc.color3;
                        blue = cc.color4;
                        magenta = cc.color5;
                        cyan = cc.color6;
                        white = cc.color7;
                    };
                    bright = {
                        black = cc.color8;
                        red = cc.color9;
                        green = cc.color10;
                        yellow = cc.color11;
                        blue = cc.color12;
                        magenta = cc.color13;
                        cyan = cc.color14;
                        white = cc.color15;
                    };
                };

                # selection settings
                selection.save_to_clipboard = true;

                # cursor settings
                cursor = {
                    style.shape = "Beam";
                    unfocused_follow = false;
                };

                # mouse settings
                mouse_bindings = [
                    {
                        mouse = "Middle";
                        action = "PasteSelection";
                    }
                ];

                # key bindings
                key_bindings = [
                    {
                        key = "V";
                        mods = "Control|Shift";
                        action = "Paste";
                    }
                    {
                        key = "C";
                        mods = "Control|Shift";
                        action = "Copy";
                    }
                ];
            };
        };
    };
}
