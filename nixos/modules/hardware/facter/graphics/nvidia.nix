{ lib, config, ... }:
let
  facterLib = import ../lib.nix lib;
  cfg = config.hardware.facter.detected.graphics.nvidia;
in
{
  options.hardware.facter.detected.graphics = {
    # todo what to do if nouveau is detected?
    nvidia.enable = lib.mkEnableOption "Enable the Nvidia Graphics module" // {
      default = builtins.elem "nvidia" (
        facterLib.collectDrivers (config.hardware.facter.report.hardware.graphics_card or [ ])
      );
      defaultText = "hardware dependent";
    };
  };
  config = lib.mkIf (config.hardware.facter.reportPath != null && cfg.enable) {
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
