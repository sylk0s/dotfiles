{
  lib,
  inputs,
  ...
}: let
  inherit (lib) listToAttrs mkDefault any;
  inherit (attrs) attrs-to-list;

  attrs = import ./attrs.nix {inherit lib attrs;};
in rec {
  # mk-home :: UserConfig -> HomeManagerConfig (AttrSet -> AttrSet)
  mk-home = modules: default: user: {
    imports =
      [
        default
        user.config
      ]
      ++ modules;
    home = {
      username = user.name;
      homeDirectory = mkDefault "/home/${user.name}";
    };
  };

  # mk-homes :: List[UserConfig] -> HomeManagerConfigAttrSet (List[AttrSet -> AttrSet])
  mk-homes = modules: default: users:
    listToAttrs (map (user: {
        name = user.name;
        value = mk-home modules default user;
      })
      users);

  any-user = pred: users:
    any (user: pred user.value) (attrs-to-list users);
}
