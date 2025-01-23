{
  lib,
  sylib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkIf mkDefault mkMerge mkOption;
  inherit (sylib) mk-enable;

  cfg = config.sylk.system.nvidia;
in {
  options.sylk.system.nvidia = {
    enable = mk-enable false;
    prime = mkOption {
      type = types.submodule {
        options = let
          pcie-bus = types.strMatching "PCI:[0-9]:[0-9]:[0-9]";
        in {
          enable = mk-enable false;
          intel-bus-id = mkOption {
            type = pcie-bus;
          };
          nvidia-bus-id = mkOption {
            type = pcie-bus;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Enable OpenGL
      hardware.graphics = {
        enable = mkDefault true;
      };

      # hyprland thing
      boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

      boot.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
        "i2c-nvidia_gpu"
      ];

      # good for hyprland
      environment.variables = {
        "LIBVA_DRIVER_NAME" = "nvidia";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = mkDefault true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = mkDefault true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = mkDefault true;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = mkDefault false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        # TODO conditional on desktop
        nvidiaSettings = mkDefault true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    }
    (mkIf cfg.prime.enable
      {
        # laptop multi gpu switching
        hardware.nvidia.prime = {
          offload = {
            enable = true;
            enableOffloadCmd = mkDefault true;
          };

          # bus ids are handled by nixos hardware
          # Bus ID of the Intel GPU.
          intelBusId = mkDefault cfg.prime.intel-bus-id;

          # Bus ID of the NVIDIA GPU.
          nvidiaBusId = mkDefault cfg.prime.nvidia-bus-id;
        };
      })
  ]);
}
