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
    ../../modules/niri/default.nix
    # inputs.noctalia.homeModules.default
	];
  xdg.configFile = {
    nvim    = link "nvim";
    ranger  = link "ranger";
    ncmpcpp = link "ncmpcpp";
    vlc     = link "vlc";
    rmpc    = link "rmpc";
  };
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
      obsidian
      avidemux
      thunderbird
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

}
