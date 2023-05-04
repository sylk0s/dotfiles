{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;

{
  imports = 
    [ inputs.home-manager.nixosModules.home-manager ]
    # all personally defined modules
    ++ (mapModulesRec' (toString ./modules) import);

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # TODO
  nix = 
  let filteredInputs = filterAttrs (n: _: n != "self") inputs;
      nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
      registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
  in {
    package = pkgs.nixFlakes;
    extraOption = "experimental-features = nix-command flakes";

    nixPath = nixPathInputs ++ [ "dotfiles=${config.dotfiles.dir}" ];

    registry = registryInputs // { dotfiles.flake = inputs.self; };

    settings = {
      # also some options here about keys, subscribers, cachix

      auto-optimise-store = true;
    };
  };

  # TODO
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  boot = {
    kernalPackages = mkDefault pkgs.linuxPackages_latest;

    loadwer = {
      efi = {
	canTouchEfiVariables = mkDefault true;
	efiSysMountPoint = "/boot/efi";
      };

      grub = {
	enable = true;
	version = 2;
	devices = [ "nodev" ];
	efiSupport = true;
	useOSProber = true;
	configurationLimit = mkDefault 10;
      };

      timeout = null;
    };
  };

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
  ]
}
