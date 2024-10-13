{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge listToAttrs nameValuePair;
  inherit (sylib) any-user attrs-to-list;
in {
  config = mkMerge [
    {
      # sets any user's shells to nix which have the config set
      users.users =
        listToAttrs (map (user: nameValuePair "${user.name}" {shell = pkgs.zsh;}) (attrs-to-list config.home-manager.users));
    }

    (mkIf (any-user (user: user.modules.shell.zsh.enable) config.home-manager.users) {
      programs.zsh.enable = true;
    })
  ];
}
