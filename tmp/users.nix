# {
#   config,
#   options,
#   lib,
#   pkgs,
#   ...
# }:
# with lib;
# with lib.sylkos; let
#   name = "xxx.xxx"; # change this to refer to the module path
#   this = "modules.${name}";
#   cfg = "config.${this}";
# in {
#   options.this = {
#     # enable option
#     enable = mkBoolOpt true;
#     # TODO make this a [Users]
#     users = mkOption {
#       type = types.listOf types.str;
#       default = [];
#     };
#   };

#   config = mkIf cfg.enable {
#     # any assertations that this module needs to make sure are true
#     assertions = [
#       {
#         assertion = true;
#         message = "";
#       }
#     ];
#   };
# }
