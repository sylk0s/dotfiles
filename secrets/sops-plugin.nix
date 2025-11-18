{exec, ... }: {
  read-sops = keyfile: name: exec ["env" "SOPS_AGE_KEY=$(nix" "run" "nixpkgs$ssh-to-age" "--" "-private-key" "-t" "${keyfile})" "sops" "-d" "${name}"];
}
