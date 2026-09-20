{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/sauropode/dotfiles";
  link = subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
  };
in
{
  # Your existing modules get pulled in from here now.
  imports = [
    ../pamixer.nix
    ../sunsetr.nix
  ];

  home.packages = with pkgs; [
    ironbar /* top bar menu on desktop */
    sunsetr /* for redshift */
    libnotify /* for notification on desktop */
    fuzzel  /* app launcher */
    pamixer /* for shortcut and controling audio volume */
    satty /* --- for screenshot */
  ];

  # Config files symlinked from your dotfiles repo
  xdg.configFile = {
    niri    = link "niri";
    fuzzel  = link "fuzzel";
    ironbar = link "ironbar";
    sunsetr = link "sunsetr";
  };

  # Cut and paste your whole existing services.mako block here, unchanged
  services.mako = {
    enable = true;
    settings = {
      # --- Base look ---
      background-color = "#1e1e2eee";   # Catppuccin Mocha "base", slight transparency
      text-color = "#cdd6f4";           # Mocha "text"
      border-color = "#89b4fa";         # Mocha "blue" — subtler than plain gray
      border-size = 2;
      border-radius = 12;
      padding = "12,16";                # top/bottom, left/right
      margin = "12";
      width = 380;
      height = 120;
      font = "JetBrains Mono 10";

      # --- Layout / positioning ---
      anchor = "top-right";
      layer = "overlay";
      sort = "-time";
      max-visible = 5;
      group-by = "app-name";

      # --- Icons ---
      icons = true;
      max-icon-size = 48;
      icon-path = "/run/current-system/sw/share/icons/hicolor";

      # --- Timing ---
      default-timeout = 5000;
      ignore-timeout = false;

      # --- Progress bar (volume/brightness OSD notifications) ---
      progress-color = "over #89b4fa";

      # --- Interaction ---
      on-button-left = "dismiss";
      on-button-middle = "dismiss-all";
      on-button-right = "dismiss-group";
      on-touch = "dismiss";
    };
  };
}
