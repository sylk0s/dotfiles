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
  mk-home = user: {
    imports = [
      ../users/home.nix
      user.config
    ];
    home = {
      username = user.name;
      homeDirectory = mkDefault "/home/${user.name}";
    };
  };

  # mk-homes :: List[UserConfig] -> HomeManagerConfigAttrSet (List[AttrSet -> AttrSet])
  mk-homes = users:
    listToAttrs (map (user: {
        name = user.name;
        value = mk-home user;
      })
      users);

  any-user = pred: users:
    any (user: pred user.value) (attrs-to-list users);
}
