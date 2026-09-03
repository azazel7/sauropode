{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/sauropode/config";
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
	imports = [
		./modules/neovim.nix
		./modules/fish.nix
		./modules/firefox.nix
	];
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
			ranger
	];
# Iterate over xdg configs and map them accordingly
	xdg.configFile = builtins.mapAttrs (name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
			}) configs;

}
