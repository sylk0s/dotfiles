{ pkgs, config, ... }:

{
	hardware.opengl.enable = true;

	hardware.nvidia = {
		package = config.boot.kernelPackages.nvidiaPackages.latest;
#		prime = {
#			offload.enable = true;
#			intelBusId = "PCI:0:2:0";
#			nvidiaBusId = "PCI:1:0:0";
#		};
		powerManagement = {
			enable = true;
#			finegrained = true;
		};
#		nvidiaPersistenced = true;
		modesetting.enable = true;
	};

	services.xserver.videoDrivers = ["nvidia"];

	environment.systemPackages = [
		(pkgs.writeShellScriptBin "nvidia-offload" ''
		export __NV_PRIME_RENDER_OFFLOAD=1
		export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
		export __GLX_VENDOR__LIBRARY_NAME=nvidia
		export __VK_LAYER_NV_optimus=NVIDIA_only
		exec "$@"
		'')
	];
}
