# Reminders about secret management
(i forgor a lot)

```
// generate key from ssh
nix-shell -p ssh-to-pgp --run "ssh-to-pgp -i /etc/ssh/ssh_host_rsa_key -o machine_name.asc"

// edit secret file
nix-shell -p sops --run "sops secrets.yaml"

// update file for more hosts
 nix-shell -p sops --run "sops updatekeys secrets.yaml"
```

- use The gpg key, make sure it's running and imported
- generate a key for the machine
- add it to the .sops.yaml
- make sure GPG key is imported for the machine using the shell.nix
-