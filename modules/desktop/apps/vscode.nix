{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.vscode;
in {
  options.modules.desktop.apps.vscode = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions;
          [
            # ms-python.python
            ms-toolsai.jupyter
            ms-toolsai.vscode-jupyter-slideshow
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap

            twxs.cmake
            ms-vscode.cpptools
            ms-vscode.cmake-tools
            ms-vscode.makefile-tools

            sumneko.lua

            bbenoist.nix
            kamadorueda.alejandra
            arrterian.nix-env-selector

            github.copilot
            eamodio.gitlens
            github.vscode-github-actions
            github.vscode-pull-request-github

            mikestead.dotenv

            serayuzgur.crates
            tamasfe.even-better-toml
            rust-lang.rust-analyzer

            nvarner.typst-lsp

            ms-vscode.hexeditor

            eugleo.magic-racket

            ms-vsliveshare.vsliveshare
            catppuccin.catppuccin-vsc
            ms-vscode-remote.remote-ssh

            ms-azuretools.vscode-docker
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "cargo";
              publisher = "panicbit";
              version = "0.2.3";
              sha256 = "sha256-B0oLZE8wtygTaUX9/qOBg9lJAjUUg2i7B2rfSWJerEU=";
            }
            {
              name = "catppuccin-vsc-icons";
              publisher = "Catppuccin";
              version = "0.30.0";
              sha256 = "sha256-D8pQ6qKjGLvAU59Q4X966RlxTb5AQNqBTrCY0meguQw=";
            }
            {
              name = "vscode-circuitpython";
              publisher = "joedevivo";
              version = "0.1.20";
              sha256 = "sha256-slcRB2wnc0Zp7NZArk5bV9C4Vzq7SQ14//iPizz94HM=";
            }
            {
              name = "language-julia";
              publisher = "julialang";
              version = "1.60.2";
              sha256 = "sha256-aHvW/TlbhFCeUQeclbScFe2l+EUBr4/dkJ2TVII2UcU=";
            }
            {
              name = "cortex-debug";
              publisher = "marus25";
              version = "1.12.1";
              sha256 = "sha256-ioK6gwtkaAcfxn11lqpwhrpILSfft/byeEqoEtJIfM0=";
            }
            {
              name = "vscode-latex";
              publisher = "mathematic";
              version = "1.3.0";
              sha256 = "sha256-/mbMpel9JHmSh0GN/wIbFi/0voaQBxGn0SueZlUFZUc=";
            }
            {
              name = "peripheral-viewer";
              publisher = "mcu-debug";
              version = "1.4.6";
              sha256 = "sha256-flWBK+ugrbgy5pEDmGQeUzk1s2sCMQJRgrS3Ku1Oiag=";
            }
            {
              name = "platformio-ide";
              publisher = "platformio";
              version = "3.3.1";
              sha256 = "sha256-zBZFpOWJ4JEv6qu9XT1u0uspZ+N2wKrpL3joC+/t/zs=";
            }
            {
              name = "tex-preview";
              publisher = "tialki";
              version = "0.0.4";
              sha256 = "sha256-bMISvB0z4OE5ceZ3/InDpdXNdpaeO4Vo5kf/vOtkh+Y=";
            }
            {
              name = "rtos-views";
              publisher = "mcu-debug";
              version = "0.0.7";
              sha256 = "sha256-VvMAYU7KiFxwLopUrOjvhBmA3ZKz4Zu8mywXZXCEHdo=";
            }
            {
              name = "memory-view";
              publisher = "mcu-debug";
              version = "0.0.25";
              sha256 = "sha256-Tck3MYKHJloiXChY/GbFvpBgLBzu6yFfcBd6VTpdDkc=";
            }
            {
              name = "copilot-chat";
              publisher = "GitHub";
              version = "0.11.2023111601";
              sha256 = "sha256-QM7gR4RC8EOHffU7QluZsj747wRzmXDR5keX7XOV2oU=";
            }
            {
              name = "debug-tracker-vscode";
              publisher = "mcu-debug";
              version = "0.0.15";
              sha256 = "sha256-2u4Moixrf94vDLBQzz57dToLbqzz7OenQL6G9BMCn3I=";
            }
            {
              name = "firedbg-rust";
              publisher = "SeaQL";
              version = "0.1.2";
              sha256 = "sha256-LKe5Lgp4XUJH0gx3T3mRwKJ5tRKC6mJNx7xpZJNRjDw=";
            }
          ];
      })
    ];
    # in ~/.config/Code/User/settings.json
    #       {
    #           "window.titleBarStyle": "custom",
    #           ...
    #       }

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
