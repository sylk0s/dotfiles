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
        plugin-files = ${ pkgs.nix-plugins.override {
# TODO: I don't like this. fix it
	        nixComponents = pkgs.nixVersions.nixComponents_2_31;
      }}/lib/nix/plugins
      '';

    nix.settings.extra-builtins-file = [
      "${inputs.self.outPath}/secrets/sops-plugin.nix"
    ];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      validateSopsFiles = false;
      defaultSopsFile = "${inputs.self.outPath}/secrets/secrets.yaml";
# TODO: Hey! this makes BAD assumptions about filesystem structure! Don't do this silly!
# ok so in retrospect... this is needed or it fails. L
      age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
