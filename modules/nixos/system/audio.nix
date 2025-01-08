{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (sylib) mk-enable;

  cfg = config.sylk.system.audio;
in {
  options.sylk.system.audio = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        security.rtkit.enable = true;

        services = {
          pipewire = {
            enable = true;
            alsa = {
              enable = true;
              support32Bit = true;
            };
            pulse.enable = true;
            jack.enable = true;
          };
        };

        sylk.userDefaults.extraGroups = ["audio"];
      }

      # bluetooth audio config
      (mkIf config.sylk.system.bluetooth.enable {
        services.pipewire.wireplumber.extraConfig = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
          };
          "10-disable-camera" = {
            "wireplumber.profiles" = {
              main."monitor.libcamera" = "disabled";
            };
          };
        };

        systemd.user.services.mpris-proxy = {
          description = "Mpris proxy";
          after = ["network.target" "sound.target"];
          wantedBy = ["default.target"];
          serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
      })
    ]
  );
}
