{
  config,
  lib,
  sylib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (sylib) mk-enable mk-opt;

  cfg = config.sylk.services.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.sylk.services.sops = {
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
    nix.extraOptions = ''
      plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
    '';

    nix.settings.extra-builtins-file = [
      ../../../secrets/sops-plugin.nix
    ];

    sops = {
      validateSopsFiles = false;
      defaultSopsFile = "${inputs.self.outPath}/secrets/secrets.yaml";
      age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
