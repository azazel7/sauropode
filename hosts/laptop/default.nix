{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];


  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/teapot" = {
    device = "/dev/disk/by-uuid/003B-3D17";  # find with `lsblk -f` or `blkid`
    fsType = "exfat";
    options = [
      "nofail"                        # don't block boot if drive is unplugged
      "x-systemd.automount"           # mount on first access, not at boot
    ];
  };
  fileSystems."/mnt/coffeepot" = {
    device = "/dev/disk/by-uuid/67E3-17ED";  # find with `lsblk -f` or `blkid`
    fsType = "fat32";
    options = [
      "nofail"                        # don't block boot if drive is unplugged
      "x-systemd.automount"           # mount on first access, not at boot
    ];
  };

  networking.hostName = "nixos";

  time.timeZone = "America/Toronto";

  console.keyMap = "fr";

  # For battery saving
  services.tlp.enable = true;
  # for intel CPU to avoid over heating
  services.thermald.enable = true;
  # The login manager on the machine
  services.displayManager.ly.enable = true;
  # For wifi and networking
  networking.networkmanager.enable = true;
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  # For checking power and battery
  services.upower.enable = true;
  # Enable SSH
  services.openssh.enable = true;
  # Enable sound with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # Essential for pavucontrol
    # jack.enable = true; # Optional, if you need JACK support
  };
  # Enable Graphical server
  services.xserver = {
    enable = true;
    autoRepeatDelay = 300;
    autoRepeatInterval = 35;
  };
  # Set niri as the default compositor
  services.displayManager.defaultSession = "niri";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  nix.settings.auto-optimise-store = true;


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

  # Define system wide packages
  environment.systemPackages = with pkgs; [
    veracrypt
    bash
    neovim
    wget
    alacritty
    git
    vlc
    pavucontrol
    brightnessctl
    ironbar
    htop
    btop
    ncdu
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";

  # Need to be enable before defining fish for users
  programs.fish.enable = true;
  # For fish. CRITICAL FOR FLAKES: Disable the standard channel-based command-not-found handler
  programs.command-not-found.enable = false;
  programs.xwayland.enable = true;
  programs.niri.enable = true;
}
