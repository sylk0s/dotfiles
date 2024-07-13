{
  inputs,
  outputs,
  lib,
  # pkgs,
  ...
}: let
  inherit (lib) nixosSystem mkDefault genAttrs removeSuffix;
  inherit (lib.sylkos) mapModules;
in rec {
  # creates a host given a config directory
  mkHost = path:
    nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        # sets up the right hostname for this host
        {
          # nixpkgs.pkgs = pkgs; # figure out what this is actually doing
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }

        ../hosts # /defaults for all hosts

        (import path) # config for the host specifically
      ];
    };

  # map over all the host dirs in a /hosts directory, creating a host for each
  mapHosts = dir:
    mapModules dir (hostPath: mkHost hostPath);

  systems = ["x86_64-linux"];

  # This is a function that generates an attribute by calling a function you
  # pass to it, with each system as an argument
  forAllSystems = genAttrs systems;
}
