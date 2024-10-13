{
  lib,
  inputs,
  ...
}: let
  inherit (modules) map-modules;
  inherit (lib) mkDefault nixosSystem removeSuffix listToAttrs;

  modules = import ./modules.nix {inherit lib inputs;};
  attrs = import ./attrs.nix {inherit lib inputs;};
in rec {
  # mk-host :: Path -> SpecialArgs -> NixosSystem (Path -> AttrSet -> AttrSet)
  mk-host = special-args: modules: parent: path: let
    name = removeSuffix ".nix" (baseNameOf path);
  in {
    name = builtins.unsafeDiscardStringContext name;
    value = nixosSystem {
      system = "x86_64-linux";
      specialArgs = special-args;
      modules = [
        {
          imports = modules;

          networking.hostName = mkDefault name;
        }

        parent
        path
      ];
    };
  };

  # mk-hosts :: Path -> SpecialArgs -> NixosSystemAttrSet (Path -> AttrSet -> AttrSet)
  mk-hosts = special-args: modules: path: listToAttrs (map-modules (mk-host special-args modules path) path);

  # mk-user :: UserConfig -> NixosUser
  mk-user = extra-groups: user: let
    name = user.name;
  in {
    name = name;
    value = {
      home = mkDefault "/home/${name}";
      initialPassword =
        if user.password == null
        then "${name}"
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
  };

  # mk-users :: List[UserConfig] -> NixosUserAttrSet (List[AttrSet] -> AttrSet)
  mk-users = extra-groups: users:
    listToAttrs (map (mk-user extra-groups) users);
}
