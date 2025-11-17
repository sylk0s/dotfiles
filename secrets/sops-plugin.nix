{exec, ... }: {
  read-sops = keyfile: name: exec ["env" "SOPS_AGE_SSH_PRIVATE_KEY_FILE=${keyfile}" "sops" "-d" "${name}"];
}
