# Dotfiles TODO

- do the refactors to make it look nice
- first, get disko working on machines and in an integrated config
- then do tpm + secure boot
- make defaults nice & clean options
- then do the bootstrapped install

## Bugs

- dots not tied to a user * - (/etc/dotfiles)
- TODOs
- startup (systemd) & - maybe as charlie gets to it

## Disko

- write configs for all systems
- proper inclusion for easy bootstrap
- move laptop onto encrypted boot

## Impermanence/etc

- home FS setup for users & - part of bootstrapping
    - systemd service WIP
- remove first reboot into impermanence

## SOPS

- add any needed keys/multi-user support/better auto integration
- remove second reboot into sops

## Yubikey

- configure with pgp0 pgp1 luks
- redo gpg key
- add ability to boot

## General Config

- battery utils
- starship
    - possible transient prompt with different shell?
- alt DE
- firefox declarwative
- greeter options
- spanish keyboard
- general purpose thinkpad Config
- more users
- mail
- etc...
- fake tails

## Architecture

- shells
- pkgs
- more interop (defaults from parent enabled)
- nix-shell shell?
- fail safe defaults
- library into more module-y thing * - do this before next
- more ergonomic stitching
- proper overlays
- clean up defaults everywhere, make sure its all set how i want

### Install

- bootstrapping process
- secrets/gpg bootstrapping

### Documentation

- update explaination docs
- blog
- install process
- secret process

## Validation

- test multiuser
- test multi wm

## Non-Nix

- thinkpad
- extra encrypt partition
- gpg bootstrap drive