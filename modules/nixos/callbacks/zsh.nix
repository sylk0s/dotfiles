{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkMerge [
    {
      # sets any user's shells to nix which have the config set
      users.users =
        listToAttrs (map (user: nameValuePair "${user.name}" {shell = pkgs.zsh;}) (attrsToList config.home-manager.users));
    }

    (mkIf (anyUsers (user: user.modules.shell.zsh.enable) config.home-manager.users) {
      programs.zsh.enable = true;
    })
  ];
}
