{
  lib,
  inputs,
  outputs,
  ...
}:
with lib; let
in rec {
  # mkHome :: User -> Host -> { name = Home }
  mkHome = user:
    lib.homeManagerConfiguration {
      modules = [
        {
          home = {
            username = user.name;
            homeDirectory = "/home/${user.name}";
          };
        }
        "${config.userDir}/home.nix"
        (import user.config)
      ];
    };

  # mapHmConfigs :: Path -> [Home]
  mapHmConfigs = dir: let
    name = "${user.name}@${host.name}";
  in (fold (
    host: hmConfigs:
      hmConfigs
      ++ (map (user: nameValuePair name (mkHome user)) host.modules.users)
  ) [] (import dir));
}
