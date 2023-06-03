{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.python;
		my-python-packages = ps: with ps; [
#			(
#				buildPythonPackage rec {
#					pname = "mons";
#					version = "1.5.0";
#					src = fetchPypi {
#						inherit pname version;
#						sha256 = "sha256-dfbe52e80cdfd5509c98db1fcc11771ee9addc10dfc0476f4e95b4e9b3cf35a5";
#					};
#					doCheck = false;
#					propagatedBuildInputs = [
#						# Specify dependencies
#						wheel
#						sphinx
#						myst-parser
#						pytest
#						tox
#					];
#				}
#			)
			# other python packages
			ipykernel
			numpy
			pip
		];
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			(python3.withPackages my-python-packages)
		];
  };
}
