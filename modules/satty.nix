{ pkgs, ... }:

let
  satty-simple = pkgs.writeShellApplication {
    name = "satty-simple";
    runtimeInputs = [ 
      pkgs.grim /* take image of a screen */
      pkgs.slurp /* enable to select a screen region for screenshot */
      pkgs.satty /* --- for editing screenshot taken by grim/slurp */
      pkgs.wl-clipboard /* to copy screenshot (and other) to the clipboard */
    ];
    text = ''
      grim -t ppm -g "$(slurp -d)" - | satty -f - --initial-tool=arrow --copy-command=wl-copy
    '';
  };
in
{
  home.packages = [ satty-simple ];
}

