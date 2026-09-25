{ config, pkgs, services, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/sauropode/dotfiles";
  link = subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
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
		../../modules/flowblade.nix
    # inputs.noctalia.homeModules.default
	];
  xdg.configFile = {
    btop         = link "btop";
    ncmpcpp      = link "ncmpcpp";
    nvim         = link "nvim";
    ranger       = link "ranger";
    rmpc         = link "rmpc";
    vlc          = link "vlc";
    transmission = link "transmission";
  };
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
      avidemux
      qtpass
      evince
      blueman
      yt-dlp
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
      handbrake
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

}
