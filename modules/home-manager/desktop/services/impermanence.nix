{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.modules.impermanence = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # TODO rely on ephemeral BTRFS?
    # any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];
    # other config ...

    home.persistence."/persist/home/${config.home.username}" = {
      directories = [
        "dotfiles"
        "Pictures"
        "Documents"
        ".gnupg"
        ".ssh"
        # TODO more...
      ];
      allowOther = true;
    };
  };
}
