(self: super: {
  grub2 = super.grub2.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches
      ++ [
        ./grub-install_luks2.patch
      ];
  });
})
