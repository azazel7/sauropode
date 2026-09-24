
{ config, lib, pkgs, ... }:

let
  cfg = config.sauropode.satty;
in
{
  options.sauropode.satty.screenshot-dir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/images/screenshots";
    description = "Directory where satty saves screenshots.";
  };

  config = {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "satty-simple";
        runtimeInputs = [
          pkgs.grim          /* take image of a screen */
          pkgs.slurp         /* enable to select a screen region for screenshot */
          pkgs.satty         /* for editing screenshot taken by grim/slurp */
          pkgs.wl-clipboard  /* to copy screenshot (and other) to the clipboard */
        ];
        text = ''
          mkdir -p "${cfg.screenshot-dir}"
          grim -t ppm -g "$(slurp -d)" - \
            | satty -f - \
                --initial-tool=arrow \
                --copy-command=wl-copy \
                --output-filename "${cfg.screenshot-dir}/$(date +%Y-%m-%d_%H-%M-%S).png"
        '';
      })
    ];
  };
}
