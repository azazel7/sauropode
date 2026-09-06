{ config, pkgs, inputs, ... }:

let
dotfiles = "${config.home.homeDirectory}/sauropode/dotfiles";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
# Standard .config/directory
configs = {
	qtile = "qtile";
	nvim = "nvim";
	ranger = "ranger";
  niri = "niri";
  fuzzel = "fuzzel";
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
    # inputs.noctalia.homeManagerModules.default
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
	home.stateVersion = "25.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nixos, btw";
		};
	};
	programs.git = {
		enable = true;
		userName = "Martin";
		userEmail = "martin@example.com";
	};
	home.packages = with pkgs; [
			ripgrep
			nil
			nixpkgs-fmt
			nodejs
			gcc
      jaq
			ranger
      thunderbird
      obsidian
      satty /* --- for screenshot */
      pamixer
      avidemux
      thunderbird
      qtpass
      evince
      blueberry
      yt-dlp
      fuzzel
      gcolor3
      cmatrix
      cbonsai
	];
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
