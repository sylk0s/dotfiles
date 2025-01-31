{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.shell.starship;
in {
  options.sylk.shell.starship = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    # TODO assertions here about zsh?
    # any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];
    # # other config ...

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # TODO transient prompt in ZSH
    };
  };
}
