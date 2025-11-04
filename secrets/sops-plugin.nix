{exec, ... }: {
  read-sops = name: exec ["sops" "-d" "${name}"];
}
