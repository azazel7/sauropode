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
    sunsetr = "sunsetr";
    rmpc = "rmpc";
  };
in


{
	home.username = "magoa";
	home.homeDirectory = "/home/magoa";
	home.sessionVariables.EDITOR = "nvim";
	home.sessionVariables.VISUAL = "nvim";
  xdg.enable = true;
	imports = [
		../../modules/neovim.nix
		../../modules/fish.nix
		../../modules/firefox.nix
		../../modules/pamixer.nix
		../../modules/sunsetr.nix
    ../../modules/niri/default.nix
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
			gtk3 # for gtk-icon-browser
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
