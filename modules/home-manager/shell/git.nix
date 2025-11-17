{
  config,
  osConfig,
  lib,
  sylib,
  inputs,
  secrets,
  ...
}: let
  inherit (lib) mkIf listToAttrs mkMerge;
  inherit (sylib) mk-enable mk-str-opt;
  cfg = config.sylk.shell.git;

  gits = ["per" "pro" "sch"];
  for-all-gits = fn: map fn gits;
in {
  options.sylk.shell.git = {
    enable = mk-enable true;
    userName = mk-str-opt "sylk0s";
    userEmail = mk-str-opt "julia@sylkos.xyz";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # thanks @3ulalia!
      programs.git = {
        enable = true;
        # sane defaults
        ignores = ["/.vscode" "/.pio" "/__pycache__" ".envrc" ".direnv" ".env" "/target"];
        settings = {
          init.defaultBranch = "main";
          user.name = cfg.userName;
          user.email = cfg.userEmail;
        };
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };
    })
    (mkIf (osConfig.sylk.services.git-crypt.enable && cfg.enable && osConfig.sylk.services.sops.enable) {
      programs.git = {
        includes =
          for-all-gits
          (
            x: {
              path = config.sops.secrets."git-config/gh-${x}".path;
              condition = "hasconfig:remote.*.url:git@gh-${x}*/**";
            }
          );
      };

      programs.ssh = let
        # secrets = builtins.extraBuiltins.read-sops "/persist/etc/ssh/ssh_host_ed25519_key" "${inputs.self.outPath}/secrets/secrets-${config.home.username}.nix";
      in {
        enable = true;
        includes = ["config.d/*"];
        enableDefaultConfig = false;
        matchBlocks = listToAttrs (for-all-gits (
          x: {
            name = "gh-${x}";
            compression = true;
            value = {
              host = "gh-${x}";
              hostname = secrets."${config.home.username}".github."${x}-url";
              identityFile = config.sops.secrets."ssh/gh-${x}".path;
              identitiesOnly = true;
            };
          }
        ));
      };

      # ssh keys for each git & names & emails
      sops.secrets = listToAttrs ((for-all-gits (
          x: {
            name = "ssh/gh-${x}";
            value = {};
          }
        ))
        ++ (for-all-gits (
          x: {
            name = "git-config/gh-${x}";
            value = {};
          }
        )));
    })
  ];
}
