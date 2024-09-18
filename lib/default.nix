{
  lib,
  inputs,
  ...
}: let
  inherit (lib) map foldl';

  modules = import ./modules.nix {inherit lib inputs;};
in
  foldl' (a: b: a // b) {} (map (module: import module {inherit lib inputs;}) (modules.all-modules-in-dir ./.))
