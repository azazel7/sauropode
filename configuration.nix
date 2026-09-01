{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  console.keyMap = "fr";

  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 300;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
    xkb = {
      layout = "fr";
      variant = "";
    };
  };

  services.openssh.enable = true;
  #networking.firewall.allowedTCPPorts = [ 22 ];


  users.users.magoa = {
    isNormalUser = true;
    extraGroups = [ "users" ];
    packages = with pkgs; [
      tree
    ];
    useDefaultShell = false; 
    
    # Set fish as the default user shell
    shell = pkgs.fish;
  };


  programs.fish.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

  # For fish. CRITICAL FOR FLAKES: Disable the standard channel-based command-not-found handler
  programs.command-not-found.enable = false;
}
