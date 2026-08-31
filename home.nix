{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
# Standard .config/directory
configs = {
	qtile = "qtile";
	nvim = "nvim";
	ranger = "ranger";
};
in


{
	home.username = "magoa";
	home.homeDirectory = "/home/magoa";
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
	programs.git.enable = true;
#  programs.neovim = {
#    enable = true;
#    vimAlias = true;
#    viAlias = true;
#  };
	home.stateVersion = "25.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nixos, btw";
		};
	};
	home.packages = with pkgs; [
		neovim
			ripgrep
			nil
			nixpkgs-fmt
			nodejs
			gcc
			ranger
	];
# Iterate over xdg configs and map them accordingly
	xdg.configFile = builtins.mapAttrs (name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
			}) configs;

}
