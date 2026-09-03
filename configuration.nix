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


  # For battery saving
  services.tlp.enable = true;
  # for intel CPU to avoid over heating
  services.thermald.enable = true;
  services.displayManager.ly.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  nix.settings.auto-optimise-store = true;

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
    extraGroups = [ 
      "wheel" # Keep wheel for root access
      "audio" #for pulse audio
    ]; 
    packages = with pkgs; [
      tree
    ];
    useDefaultShell = false; 
    
    # Set fish as the default user shell
    shell = pkgs.fish;
  };


  programs.fish.enable = true;
  # programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    alacritty
    git
    light
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

  # For fish. CRITICAL FOR FLAKES: Disable the standard channel-based command-not-found handler
  programs.command-not-found.enable = false;
}
