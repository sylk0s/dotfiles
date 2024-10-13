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

  cfg = config.modules.services.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.services.sops = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];
    # other config ...

    sops = {
      validateSopsFiles = false;
      defaultSopsFile = "${config.dotfiles.secretsDir}/secrets.yaml";
      age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };

    # TODO better secret management
    sops.secrets."passwords/sylkos" = {
      neededForUsers = true;
    };
  };
}
