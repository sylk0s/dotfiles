{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    validateSopsFiles = false;
    defaultSopsFile = "${inputs.self.outPath}/secrets/secrets.yaml";
    age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
  };
}
