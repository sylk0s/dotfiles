{
  config,
  options,
  lib,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.services.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.services.sops = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # any assertations that should be checked
    # assertations = [
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
      gnupg.sshKeyPaths = ["/etc/ssh/ssh_host_rsa_key"];
    };

    # TODO better secret management
    sops.secrets."passwords/sylkos" = {
      neededForUsers = true;
    };
  };
}
