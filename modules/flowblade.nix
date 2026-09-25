{ config, pkgs, ... }:

{
  # Your existing modules get pulled in from here now.
  imports = [
  ];

  home.packages = with pkgs; [
  ];

}
