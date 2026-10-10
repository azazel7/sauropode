{ config, lib, pkgs, ... }:
{
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        # 1. PROFILE WHEN EXTERNAL MONITOR IS CONNECTED
        {
          name = "docked";
          output = [
            {
              search = [ "v=ASUSTek COMPUTER INC" "m=XG32WCS" "s=T1LMAS026778" ];
              mode = "1920x1080";
              scale = 1.0;
              position = "0,0"; 
              enable = true;
            }
            {
              search = "n=eDP-1";
              enable = false; # Turn off the laptop screen
            }
          ];
        }
        {
          name = "laptop-only";
          output = [
            {
              search = "n=eDP-1";
              /* used prefered 4k mod, but increase scale to make it smaller resolution, for cpu */
              mode = "preferred";
              scale = 2.0;
              position = "0,0";
              enable = true;
            }
          ];
        }
      ];
    };
  };

}

