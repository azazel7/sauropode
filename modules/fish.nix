{ pkgs, ... }: {
  # Simply enable the shell under Home Manager for user-specific tweaks
  programs.fish = {
    enable = true;
    
    # Add your personal fish aliases, abbreviations, or plugins here
    shellAliases = {
      ll = "ls -l";
    };
  };
}
