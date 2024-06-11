{pkgs, ...}: {

  boot = {
    initrd = {
      luks.devices = {
        "test_crypt" = {
          device = "/dev/disk/by-uuid/adff35ba-a59f-44d8-adeb-322ba5c681cf";
          preLVM = true;
        };
      };
    };
  };
}
