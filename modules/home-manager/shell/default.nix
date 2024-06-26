{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell;
in {
  config = {
    assertions = [
      # add some assertion about only having one shell enabled?
      #{
      #  assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
      #  message = "Can't have more than one desktop environment enabled at a time";
      #}
    ];

    # default shell packages
    # this is stuff that should probably be on every system but
    # can be turned off, unlike actually important things like git and neovim
    # TODO
    home.packages = with pkgs; [
      btop
      htop
      zip
      unzip
      fd
      ripgrep
      fzf
      #socat
      #jq
      #acpi
      #busybox
      #libnotify
      #pciutils
    ];
  };
}
