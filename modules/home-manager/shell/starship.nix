{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.starship;
in {
  options.modules.shell.starship = {
    enable = mkBoolOpt true;
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
