{ pkgs, ... }:

let
  pamixer-auto = pkgs.writeShellApplication {
    name = "pamixer-auto";
    runtimeInputs = [ pkgs.pamixer ];
    text = ''
      SINK=$(pamixer --list-sinks | tail -n 1 | cut -d ' ' -f 1)
      pamixer --sink "$SINK" "$@"
    '';
  };
in
{
  home.packages = [ pamixer-auto ];
}
