# Sylkos's Dotfiles

## Overview
Nix Flake which contains configs for most of my more recent systems. Uses modules for high configurability between systems, organization, and encapsulation of configs for a specific program. Optimized so that adding hosts and programs is easy, and it should be enough to add a new file, then rebuild and everything will work. No need to specify any extra imports.

// ## Hosts

## TMP Installation

- Run `config/scripts/install.sh` for a lvm on luks btrfs install (designed for impermanence)
- Modify config as is needed
  - `sudo nvim /mnt/etc/nixos/hardware-configuration.nix`
    - add `"compress=zstd"` to all btrfs subvols, `"noatime"` to nix, and `neededForBoot = true;` to persist, logs, and home
  - `sudo rm /mnt/etc/nixos/configuration.nix`
  - `sudo cp dotfiles/tmp/configuration.nix /mnt/etc/nixos/`
  - `sudo nvim /mnt/etc/nixos/configuration.nix`
    - add the uuid of the disk to the thing
- `cd /mnt`
- `sudo nixos-install`
- copy and setup dots. will be easier now with some creature comforts
  - copy uuids, copy hardware-config, write host file
- reboot into new system
- clone dots
  - `git clone https://github.com/sylk0s/dotfiles`
- copy gpg key onto system and into gnupg
  - `gpg --import public.key`
  - `gpg --import private.key`
  - `gpg --edit-key {KEY} trust quit` (this is to modify the permission level of the key)
  - `gpg --list-keys`
- update sops with passwd
  - get the ssh fingerprint using `nix-shell -p ssh-to-age --run "cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age"`
  - add to `.sops.yaml`
  - run `nix-shell -p sops --run "sops updatekeys secrets.yaml"`
- rebuild into new system (this should just... work now) 

## Installation
I typically use the gnome install enviornment, since it's just a bit easier to use than minimal, but either are fine. With the gnome install, I install the minimal environment & partiton accordingly and then clone this repo and run the following command.
```bash
# nixos-rebuild switch --install-bootloader --flake .#host-name
```
Note: the `--install-bootloader` arg may be omitted in certain cases depending on how you want the system to be setup.

### After installation
- regenerate SSH keys
- setup folder structure (projects, tools)

## Other Quirks
- VS Code with Wayland has a strange bug (will crash) with the options bar at the top, currently, it's set up to disable that. To access, push tab.

## Usage

### Adding a Host
This repo is designed to make it super easy to add a host!
- create a new folder under `hosts/`
- copy the hardware config from `/etc/nixos/hardware-config.nix`
- make any edits needed
- Drawing inspiration from `hosts/pc/default.nix` or `hosts/laptop/default.nix` create a host config file
  - Typically, I like a space in the hosts file to quickly add programs to a host without the need to create a module
  - This file is where you setup the modules and make any additional configs you want
- Rebuild into the new host using `nixos-rebuild switch --flake .#host-name`

### Adding a program
This repo is also designed to make it easy to add a program as a module!
- See table below for where to add programs
- If it's not a module, just add the program to a list
- Otherwise, at the appropriate place under `modules/` add a new file named `module-name.nix` and create a module (look to other modules similar for inspiration)

// Places programs are specified

## Major Inspiration
- Hlissner's dotfiles
- Auyler's dotifles
- TODO more
