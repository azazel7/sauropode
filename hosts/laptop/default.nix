{ config, lib, pkgs, inputs, ... }:

let
  mountUid = toString config.users.users.magoa.uid;
  mountGid = "100";  # NixOS's "users" group

  autoMounts = [
    { mountpoint = "/mnt/teapot";    uuid = "003B-3D17"; fsType = "exfat"; }
    { mountpoint = "/mnt/coffeepot"; uuid = "67E3-17ED"; fsType = "vfat";  }
    { mountpoint = "/mnt/usb"; uuid = "57F6-B30A"; fsType = "vfat";  }
    { mountpoint = "/mnt/plain-hardrive"; uuid = "577E-0F94"; fsType = "vfat";  }
    { mountpoint = "/mnt/rorqual"; uuid = "7d3796a2-6570-47c7-a5cf-0d3e33cefc37"; fsType = "ext4";  }
    { mountpoint = "/mnt/loutre"; uuid = "acd63365-8604-4409-9339-11dd00e159bd"; fsType = "ext4";  }
    { mountpoint = "/mnt/ebook"; uuid = "564A-6EB5"; fsType = "vfat";  }
  ];

  mkAutoMount = { mountpoint, uuid, fsType }: {
    name = mountpoint;
    value = {
      device = "/dev/disk/by-uuid/${uuid}";
      inherit fsType;
      options = [
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=1ms"
        "uid=${mountUid}"
        "gid=${mountGid}"
        "umask=0177"
        "dmask=077"
      ];
    };
  };
in
{
  imports =
    [
      ./hardware.nix
    ];


  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = builtins.listToAttrs (map mkAutoMount autoMounts);
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


  networking.firewall.allowedTCPPorts = [ 
    /* SSH */
    22
    /* python http */
    8000
  ];

  users.users.magoa = {
    isNormalUser = true;
    uid = 1000;
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
