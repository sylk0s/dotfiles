{
  lib,
  inputs,
  ...
}: let
  inherit (modules) map-modules;
  inherit (lib) mkDefault nixosSystem removeSuffix listToAttrs;

  modules = import ./modules.nix {inherit lib inputs;};
in rec {
  # mk-host :: Path -> SpecialArgs -> NixosSystem (Path -> AttrSet -> AttrSet)
  mk-host = special-args: path:
    nixosSystem {
      specialArgs = special-args;
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        ../hosts
        (import path)
      ];
    };

  # mk-hosts :: Path -> SpecialArgs -> NixosSystemAttrSet (Path -> AttrSet -> AttrSet)
  mk-hosts = special-args: path: map-modules (mk-host special-args) path;

  # mk-user :: UserConfig -> NixosUser
  mk-user = user: extra-groups: {
    home = mkDefault "/home/${user.name}";
    initialPassword =
      if user.password == null
      then "${user.name}"
      else null;
    hashedPasswordFile = user.password;
    isNormalUser = true;
    createHome = true;
    extraGroups =
      (
        if user.privileged
        then ["wheel"]
        else []
      )
      ++ extra-groups
      ++ user.extra-groups;
  };

  # mk-users :: List[UserConfig] -> NixosUserAttrSet (List[AttrSet] -> AttrSet)
  mk-users = users: extra-groups:
    listToAttrs (map (user: {
        name = user.name;
        value = mk-user user extra-groups;
      })
      users);
}
