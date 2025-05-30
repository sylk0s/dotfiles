{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (sylib) mk-enable;
  cfg = config.sylk.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.sylk.impermanence = {
    enable = mk-enable false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
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

      home.persistence = {
        # enable = true;
        "/persist/home/${config.home.username}" = {
          directories = [
            "dotfiles"
            "Pictures"
            "Documents"
            ".gnupg"
            ".ssh"
            "projects"
            "school"
            "work"
            # ".config/sops-nix/secrets"
          ];
          allowOther = true;
        };
      };
    })
    # (mkIf (!cfg.enable) {
    #   home.persistence.enable = false;
    # })
  ];
}
