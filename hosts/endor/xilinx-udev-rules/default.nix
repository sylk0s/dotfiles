{ pkgs, }: 
pkgs.stdenv.mkDerivation {
    name = "xilinx-udev-rules";

    src = ./.;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp 52-xilinx-digilent-usb.rules $out/lib/udev/rules.d
      cp 52-xilinx-ftdi-usb.rules $out/lib/udev/rules.d
      cp 52-xilinx-pcusb.rules $out/lib/udev/rules.d
    '';
}

