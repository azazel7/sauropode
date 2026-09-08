{ config, pkgs, services, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/sauropode/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    nvim = "nvim";
    ranger = "ranger";
    niri = "niri";
    fuzzel = "fuzzel";
    ironbar = "ironbar";
    ncmpcpp = "ncmpcpp";
    vlc = "vlc";
  };
in


{
	home.username = "magoa";
	home.homeDirectory = "/home/magoa";
	home.sessionVariables.EDITOR = "nvim";
	home.sessionVariables.VISUAL = "nvim";
	imports = [
		../../modules/neovim.nix
		../../modules/fish.nix
		../../modules/firefox.nix
		../../modules/pamixer.nix
    # inputs.noctalia.homeModules.default
	];
	# programs.noctalia = {
 #      enable = true;
	#
 #      settings = { # This may also be a string or path to a .toml file.
 #        theme = {
 #          mode = "dark";
 #          source = "builtin";
 #          builtin = "Catppuccin";
 #        };
	#
 #        # wallpaper = {
 #        #   enabled = true;
 #        #   default.path = "/path/to/wallpapers/wallpaper.png";
 #        # };
 #      };
	# };
	home.stateVersion = "26.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			ll = "lsd -lah";
		};
	};
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Martin";
				email = "martin@example.com";
			};
		};
	};

	home.packages = with pkgs; [
			ripgrep
			nil
			nixpkgs-fmt
			nodejs
			gcc
      jaq
      lsd /* better ls */
			ranger
      thunderbird
      obsidian
      satty /* --- for screenshot */
      pamixer
      avidemux
      thunderbird
      qtpass
      evince
      blueman
      yt-dlp
      fuzzel
      gcolor3
      cmatrix
      cbonsai
      sshfs
      transmission_4-gtk
      mpd
      ncmpcpp
      mpc
      rmpc
      timer
      python3
      mako
	];
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };
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

# need more up to date packages
# programs.satty = {
#   enable = true;
#   settings = {
#     general = {
#       fullscreen = false;
#       initial-tool = "brush";
#     };
#   };
# };
# Iterate over xdg configs and map them accordingly
	xdg.configFile = builtins.mapAttrs (name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
			}) configs;

}
