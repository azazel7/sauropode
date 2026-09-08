{ pkgs, ... }:

let
  sunsetr-auto = pkgs.writeShellApplication {
    name = "sunsetr-auto";
    runtimeInputs = [ pkgs.pamixer ];
    text = ''
      # Start sunsetr with preset based on day of week

      daemon=$(pgrep -c sunsetr | wc -l)
      if [ "$daemon" -le 0 ]; then
          sunsetr --background
      fi

      day=$(date +%u)  # 1=Monday, 7=Sunday

      if [ "$day" -ge 1 ] && [ "$day" -le 4 ]; then
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

