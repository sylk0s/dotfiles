{
  config,
  options,
  lib,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.modules.impermanence = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO rely on ephemeral BTRFS?
    # any assertations that should be checked
    # assertations = [
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
    };
  };
}
