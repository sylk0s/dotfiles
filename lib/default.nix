{
  inputs,
  outputs,
  lib,
  # pkgs,
  ...
}: let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModules;

  # this needs to be here because it is used in this file to import... itself
  modules = import ./modules.nix {
    inherit lib inputs;
    self.attrs = import ./attrs.nix {
      inherit lib;
      self = {};
    };
  };

  sylkoslib = makeExtensible (self:
    mapModules ./.
    (file: import file {inherit self lib inputs outputs;}));
in
  sylkoslib.extend
  (self: super:
    foldr (a: b: a // b) {} (attrValues super))
