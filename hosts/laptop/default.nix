{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
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

  # Enable sound with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # Essential for pavucontrol
    # jack.enable = true; # Optional, if you need JACK support
  };
  programs.xwayland.enable = true;
  programs.niri.enable = true;
  services.displayManager.defaultSession = "niri";
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
    ];
    useDefaultShell = false; 
    
    # Set fish as the default user shell
    shell = pkgs.fish;
  };


  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    bash
    neovim
    wget
    alacritty
    git
    light
    vlc
    pavucontrol
    upower
    brightnessctl
    htop
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

  # For fish. CRITICAL FOR FLAKES: Disable the standard channel-based command-not-found handler
  programs.command-not-found.enable = false;
}
