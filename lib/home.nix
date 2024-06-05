{lib, ...}:
with lib; let
in rec {
  # mapUsers :: [User] -> (User -> a) -> [a])

  # mkHome :: User -> System -> Home (?)
  mkHome = user: system: let
    name = "${user.name}@${system}";
  in
    lib.homeManagerConfiguration {
      modules = [
      ];
    };
}
