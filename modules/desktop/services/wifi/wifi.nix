{
  config,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.services.wifi;
in {
  options.modules.desktop.services.wifi = {
    enable = mkBoolOpt false;
  };

  #   config = mkIf (cfg.enable) {
  #     nixpkgs.config.packageOverrides = pkgs: rec {
  #       wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
  #         patches = attrs.patches ++ [./eduroam.patch];
  #       });
  #     };

  #     networking = {
  #       networkmanager.enable = true;

  #       wireless = {
  #         enable = false;
  #         userControlled.enable = true;

  #         environmentFile = config.age.secrets.wifi.path;

  #         networks = {
  #           "NUwave" = {
  #             hidden = false;

  #             auth = ''
  #               key_mgmt=WPA-EAP
  #               eap=PEAP
  #               phase1="peaplabel=0"
  #               phase2="auth=MSCHAPV2"
  #               identity="@NUwave-username@"
  #               password="@NUwave-password@"
  #             '';
  #           };
  #         };
  #       };
  #     };
  #  };
}
