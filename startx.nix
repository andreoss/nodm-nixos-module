{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.startx;
in
{
  imports = [ ];
  options.services.startx = {
    enable = mkEnableOption "Enable startx as a service.";
    user = mkOption { type = types.str; };
    dpi = mkOption {
      type = types.int;
      default = 100;
    };
    restart = mkOption {
      type = types.str;
      default = "no";
    };
    tty = mkOption {
      type = types.str;
      default = "tty1";
    };
  };
  config = {
    services.xserver.displayManager.startx = mkIf cfg.enable { enable = true; };
    systemd.services."autovt@${cfg.tty}" = mkIf cfg.enable { enable = false; };
    systemd.services.startx = mkIf cfg.enable {
      enable = true;
      restartIfChanged = false;
      description = "startx service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        LimitNOFILE = 64 * 1024;
        ExecStart = "${pkgs.xorg.xinit}/bin/startx -- -dpi ${builtins.toString cfg.dpi} -keeptty -verbose 3";
        PAMName = "login";
        Restart = "${cfg.restart}";
        RestartSec = "3";
        StandardInput = "tty";
        StandardOutput = "journal";
        TTYPath = "/dev/${cfg.tty}";
        Type = "idle";
        UnsetEnvirnment = "TERM";
        User = cfg.user;
        UtmpIdentifier = "${cfg.tty}";
        UtmpMode = "user";
        WorkingDirectory = "~";
        TasksMax = "infinity";
      };
    };
  };
}
