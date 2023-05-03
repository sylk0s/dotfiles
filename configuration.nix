/* configuration.nix */
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Install Home manager as module]
      ./home.nix
      # hyprland
      inputs.hyprland.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "testing"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_york";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  #i18n.extraLocaleSettings = {
  #  LC_ADDRESS = "fil_PH";
  #  LC_IDENTIFICATION = "fil_PH";
  #  LC_MEASUREMENT = "fil_PH";
  #  LC_MONETARY = "fil_PH";
  #  LC_NAME = "fil_PH";
  #  LC_NUMERIC = "fil_PH";
  #  LC_PAPER = "fil_PH";
  #  LC_TELEPHONE = "fil_PH";
  #  LC_TIME = "fil_PH";
  #};

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sylkos = {
    isNormalUser = true;
    description = "sylkos";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "kvm" "libvirt" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  #services.getty.autologinUser = "yori";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    alacritty
    kitty
    firefox
    wofi
  ];

  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true; if you have nvidia
  };

  # Nvidia Drivers
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.opengl.enable = true;

  #hardware.nvidia.modesetting.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Ubuntu" ]; })
  ];
}
