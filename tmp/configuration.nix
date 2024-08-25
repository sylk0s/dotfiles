{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    ./disko-config.nix
  ];

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  nixpkgs = {
    overlays = [
      (import ./grub_overlay.nix)
    ];
    hostPlatform.system = "x86_64-linux";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        #copyKernels = true;
        enableCryptodisk = true;
        configurationLimit = 10;
      };
    };

    # initrd = {
    #   luks.devices = {
    #     "crypt" = {
    #       device = "/dev/disk/by-uuid/UUID";
    #       preLVM = true;
    #     };
    #   };
    # };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  users.users.sylkos = {
    initialPassword = "sylkos";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.openssh = {
    enable = true;
    # TODO this is bad. don't do this ever
    ports = [30022];
    openFirewall = false;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
}
