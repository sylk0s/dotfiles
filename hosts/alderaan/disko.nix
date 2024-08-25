{inputs, ...}: {
  imports = [inputs.disko.nixosModules.disko];

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdX";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "NIXBOOT";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              label = "NIXLUKS";
              content = {
                type = "luks";
                name = "cryptid";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; #
                extraOpenArgs = [
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings = {
                  # crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
                  allowDiscards = true;
                  # keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "NIXROOT" "-f"];
                  subvolumes = {
                    "/boot" = {
                      mountpoint = "/boot";
                      mountOptions = ["subvol=boot" "compress=zstd" "noatime"];
                    };
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "64G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
