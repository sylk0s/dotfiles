{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.sops-nix;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.sops-nix = {
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
  };
}
