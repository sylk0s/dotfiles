{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf listToAttrs;
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

  config = mkIf cfg.enable {
    # thanks @3ulalia!
    programs.git = {
      enable = true;
      # sane defaults
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      ignores = ["/.vscode" "/.pio" "/__pycache__" ".envrc" ".direnv" ".env" "/target"];
      # includes =
      #   for-all-gits
      #   (
      #     x: {
      #       path = config.sops.secrets."git-config/gh-${x}".path;
      #       condition = "hasconfig:remote.*.url:git@gh-${x}*/**";
      #     }
      #   );
      extraConfig.init.defaultBranch = "main";
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # programs.ssh = {
    #   enable = true;
    #   compression = true;
    #   includes = ["config.d/*"];
    #   matchBlocks = for-all-gits (
    #     x: {
    #       host = "gh-${x}";
    #       hostname = config.sops.secrets."git-urls/gh-${x}".path;
    #       identityFile = config.sops.secrets."ssh/gh-${x}".path;
    #       identitiesOnly = true;
    #     }
    #   );
    # };

    # # ssh keys for each git
    # sops.secrets = listToAttrs for-all-gits (
    #   x: {
    #     name = "ssh/gh-${x}";
    #     value = {};
    #   }
    # );

    # # name and email configs for each git
    # sops.secrets = listToAttrs for-all-gits (
    #   x: {
    #     name = "git-config/gh-${x}";
    #     value = {};
    #   }
    # );

    # # github urls
    # sops.secrets = listToAttrs for-all-gits (
    #   x: {
    #     name = "git-urls/gh-${x}";
    #     value = {};
    #   }
    # );
  };
}
