{
  lib,
  inputs,
  ...
}: let
  inherit (lib) pathExists hasSuffix filterAttrs mapAttrsToList concatLists;
  inherit (builtins) readDir;

  is-module = path: name: type:
    (type == "directory" && pathExists "${path}/${name}/default.nix")
    || (type == "regular" && hasSuffix ".nix" name && name != "default.nix");

  get-path = dir: name: _type: "${dir}/${name}";

  get-paths-for-filter = pred: path: (mapAttrsToList (get-path path) (filterAttrs (pred path) (readDir path)));
in rec {
  is-directory = _dir: _name: type: (type == "directory");

  all-dirs-in-dir = path: get-paths-for-filter is-directory path;

  # all-modules-in-dir :: Path -> List[Path]
  all-modules-in-dir = path: get-paths-for-filter is-module path;

  # all-modules-in-dir-rec :: Path -> List[Path]
  all-modules-in-dir-rec = path: (all-modules-in-dir path) ++ (concatLists (map all-modules-in-dir-rec (all-dirs-in-dir path)));

  # map-modules :: Path -> Fn -> List[Path]
  map-modules = fn: path: (map fn (all-modules-in-dir path));

  # map-modules :: Path -> Fn -> List[Path]
  map-modules-rec = fn: path: (map fn (all-modules-in-dir-rec path));
}
