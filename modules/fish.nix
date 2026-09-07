{ pkgs, ... }: {

  home.packages = with pkgs; [
    silver-searcher # Provides the 'ag' command
    bat
    fd
    yt-dlp
  ];
  # Enable zoxide natively through Home Manager (automatically handles shell initialization)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd j" ];
    #__ZO_EXCLUDE_DIRS = "$HOME/Desktop:/media/teapot/video:/media/loutre/bordel:/media/rorqual/home/:$HOME/dossierPersoUsb";
  };

  programs.starship = {
    enable = true;

    settings = builtins.fromTOML (
      builtins.readFile ../dotfiles/starship.toml
    );
  };

  programs.fish = {
    enable = true;

    # Universal environment variables for this user session
#   home.sessionVariables = {
#     GREP_COLOR = "31";
#     MANPAGER = "most -s";
#     BROWSER = "firefox";
#     GTEST_COLOR = "1";
#     __GL_YIELD = "USLEEP";
#     __GL_THREADED_OPTIMIZATIONS = "1";
#     PASSWORD_STORE_CLIP_TIME = "600";
#  };

    # Your custom abbreviations
    shellAbbrs = {
      g = "git";
      gs = "git status";
      m = "make";
    };

    # Your clean list of shell aliases
    shellAliases = {
      grep = "ag --color-match \"0;31\" --color-path \"0;35\" --color-line-number \"0;32\"";
      ag = "ag --color-match \"0;31\" --color-path \"0;35\" --color-line-number \"0;32\"";
      ls = "ls --color=auto -h -p --group-directories-first";
      ll = "lsd --color=auto -h -p --group-directories-first -lA";
      lld = "lsd --color=auto -h -p --group-directories-first -lA -d */";
      cp = "cp --interactive";
      mv = "mv --interactive";
      rm = "rm --interactive --verbose";
      Xrecord = "ffmpeg -f x11grab -s 1920x1080 -r 15 -i :0.0 -qscale 0 /tmp/out.mkv";
      camrecord = "ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 /tmp/out.mkv";
      gdb = "gdb -q";
      httpServer = "python3 -m http.server 8000";
      mountiso = "mount -o loop -t iso9660";
      yt-dlp-mp3 = "yt-dlp -x --audio-format mp3 --audio-quality 320K --no-playlist";
      redshift = "nohup redshift -l 45.53:-73.59 -t 7000:2200";
      poweroff = "mpd --kill; poweroff";
      reboot = "mpd --kill; reboot";
      find = "fd";
      jo = "_zoxide_and_open";
    };

    # Native fish configuration, custom functions, and interactive bindings
    interactiveShellInit = ''
      # Général
      umask 0066
      set PATH $PATH $HOME/.install/bin $HOME/.local/share/flatpak/exports/bin
      set fish_greeting

      # Custom functions
      function edit_cmd --description 'Edit cmdline in editor'
          set -l f (mktemp --tmpdir=/tmp)
          set -l p (commandline -C)
          commandline -b > $f
          $EDITOR -c set\ ft=fish $f
          commandline -r (cat $f)
          rm -f $f > /dev/null
      end

      function _zoxide_and_open 
          __zoxide_z "$argv" && ranger
      end

      # Bindings
      bind --mode insert \cf forward-word
      bind --mode insert \cb backward-word
      bind --mode insert \ce end-of-line
      bind --mode insert \ca beginning-of-line
      bind --mode insert \cn history-search-backward
      bind --mode insert \cp history-search-forward
      bind --mode insert \cv edit_cmd
    '';
  };
}

/* (magoa@nixos) Password:
fish: upgraded to version 4.3:
* Color variables are no longer set in universal scope by default.
  Migrated them to global variables set in ~/.config/fish/conf.d/fish_frozen_theme.fish
  To restore syntax highlighting in other fish sessions, please restart them.
* The fish_key_bindings variable is no longer set in universal scope by default.
  Migrated it to a global variable set in  ~/.config/fish/conf.d/fish_frozen_key_bindings.fish
See also the release notes (type `help relnotes`).

*/
