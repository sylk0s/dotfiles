{
  self,
  lib,
  inputs,
  ...
}: let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in rec {
  # map over modules
  # Path -> Fn -> AttrSet { name, (fn path) }
  mapModules = dir: fn:
    mapFilterAttrs
    # this predicate removes any files that could not be parsed into modules
    (n: v: v != null && !(hasPrefix "_" n))
    # maps over all the files that are modules and flags the ones that don't match
    (n: v: let
      path = "${toString dir}/${n}";
    in
      # case for a module as a directory with default.nix included
      if v == "directory" && pathExists "${path}/default.nix"
      then nameValuePair n (fn path)
      # case for individual files
      else if (v == "regular") && (n != "default.nix") && (hasSuffix ".nix" n)
      then nameValuePair (removeSuffix ".nix" n) (fn path)
      # catchall case which gets removed if invalid later
      else nameValuePair "" null)
    # this is the dir being mapped
    (readDir dir);

  # maps over modules recursively including the default.nix
  # Path -> Fn -> (fn path)
  mapModulesRec = dir: fn: let
    dirs =
      mapAttrsToList
      (k: _: "${dir}/${k}")
      (filterAttrs
        (n: v: v == "directory" && !(hasPrefix "_" n))
        (readDir dir));
    files = attrValues (mapModules dir id);
    paths = files ++ concatLists (map (d: mapModulesRec d id) dirs);
  in
    map fn paths;
}
