{
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.services.vmware;
in {
  options.sylk.services.vmware = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vmware-horizon-client # (run vmware-view)
      openconnect
      gp-saml-gui
    ];

    environment.shellAliases = {
      uni-vpn = "gp-saml-gui -S";
    };

    # TODO persist
  };
}
