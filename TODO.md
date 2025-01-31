# Dotfiles TODO

- do the refactors to make it look nice
    - make sops work again fr maybe with yubikey
        - encrypted firefox
    - do all the nice and fancy assertation linkage
- then do tpm + secure boot
- make defaults nice & clean options
- then do the bootstrapped install
- clean modules, remove things that aren't as needed
- matrix
- rebind swaylock

## Bugs

- dots not tied to a user * - (/etc/dotfiles)
- TODOs

## SOPS
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