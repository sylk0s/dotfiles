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
    # TODO assertations here about zsh?
    # any assertations that should be checked
    # assertations = [
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
