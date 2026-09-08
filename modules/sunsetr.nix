{ pkgs, ... }:

let
  pamixer-auto = pkgs.writeShellApplication {
    name = "sunsetr-auto";
    runtimeInputs = [ pkgs.pamixer ];
    text = ''
      # Start sunsetr with preset based on day of week

      day=$(date +%u)  # 1=Monday, 7=Sunday

      if [ $day -ge 1 ] && [ $day -le 5 ]; then
          # Weekdays: work schedule with earlier transitions
          sunsetr preset weekday
      else
          # Weekends: relaxed schedule, sleep in
          sunsetr preset weekend
      fi
    '';
  };
in
{
  home.packages = [ sunsetr-auto ];
}

