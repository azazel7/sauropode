{ config, pkgs, ... }:

{
  systemd.user.services = {
    clean-caches = {
      Unit.Description = "Clean user thumbnails and ranger cache";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'rm -rf %h/.thumbnails/* && rm -rf %h/.cache/ranger/*'";
      };
    };
    kill-weechat = {
      Unit.Description = "Kill all running weechat instances";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.killall}/bin/killall weechat || true'";
      };
    };
  };

  systemd.user.timers = {
    clean-caches = {
      Unit.Description = "Weekly cache cleaning timer";
      Timer = {
        OnCalendar = "Mon *-*-* 10:00:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    kill-weechat = {
      Unit.Description = "Daily weechat termination timer";
      Timer = {
        OnCalendar = "*-*-* 01:00:00";
        Persistent = false;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
