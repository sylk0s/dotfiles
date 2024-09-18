{
  lib,
  inputs,
  ...
}: let
  inherit (lib) filter pathExists hasSuffix;
  inherit (builtins) readDir;

  inherit (attrs) attrs-to-list;

  attrs = import ./attrs.nix {inherit lib inputs;};

  is-module = a:
    (a.value == "directory" && pathExists "${a.name}/default.nix")
    || (a.value == "regular" && hasSuffix ".nix" a.name && !(hasSuffix "default.nix" a.name));

  is-directory = a: (a.value == "directory");

  get-path = a: ./. + "/${a.name}";

  get-paths-for-filter = pred: path: (map get-path (filter pred (attrs-to-list (readDir path))));

  all-dirs-in-dir = path: get-paths-for-filter is-directory path;
in rec {
  # all-modules-in-dir :: Path -> List[Path]
  all-modules-in-dir = path: get-paths-for-filter is-module path;

  # all-modules-in-dir-rec :: Path -> List[Path]
  all-modules-in-dir-rec = path: (all-modules-in-dir path) ++ (map all-modules-in-dir-rec (all-dirs-in-dir path));

  # map-modules :: Path -> Fn -> List[Path]
  map-modules = fn: path: (map fn (all-modules-in-dir path));

  # map-modules :: Path -> Fn -> List[Path]
  map-modules-rec = fn: path: (map fn (all-modules-in-dir-rec path));
}
