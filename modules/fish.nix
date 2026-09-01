{ pkgs, ... }: {
  # Enable Fish shell via Home Manager
  programs.fish = {
    enable = true;
  };

  # Instruct Bash to instantly launch Fish for interactive sessions
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      # If the parent process is not fish and it is an interactive shell, exec fish
      if [[ $(ps -o comm= -p $PPID) != "fish" && $- == *i* ]]; then
        export SHELL="${pkgs.fish}/bin/fish"
        exec "${pkgs.fish}/bin/fish"
      fi
    '';
  };
}
