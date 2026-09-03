{ config, pkgs, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "fr" ];

      /* ---- GLOBAL POLICIES & EXTENSIONS ---- */
      # Home Manager natively supports enterprise policies here.
      # This removes the need to manually wrap the package.
      policies = {
        RequestedLocales = [ "fr" ];
        # Nix is managing the update and the version
        DisableAppUpdate = true;
        # I use another password manager, not the firefox one
        PasswordManagerEnabled = false;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          Locked = true;
        };
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        /* ---- EXTENSIONS ---- */
        ExtensionSettings = {
          # Blocks all addons except the ones explicitly listed below
          "*" = {
            installation_mode = "blocked";
          };
          # uBlock Origin:
          /*
          How to find the id : uBlock0@raymondhill.net
          - Open the extension's AMO page 
          - view page source or fetch it as text 
          - find the <a href="https://www.firefox.com/thanks/...">Download Firefox and get the extension</a> link 
          - grab the utm_content=rta%3A<base64> value 
          - base64-decode it. 
          - That's the ground-truth gecko ID, straight from Mozilla, no unzip needed.
          */
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Enhancer for YouTube
          "enhancerforyoutube@maximerf.addons.mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/latest.xpi";
            installation_mode = "force_installed";
          };
          # I don't care about cookies
          "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies/latest.xpi";
            installation_mode = "force_installed";
            default_private_browsing_allowed = true;
          };
          # PassFF
          "passff@invicem.pro" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/passff/latest.xpi";
            installation_mode = "force_installed";
            default_private_browsing_allowed = true;
          };
          # Disconnect
          "2.0@disconnect.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/disconnect/latest.xpi";
            installation_mode = "force_installed";
            default_private_browsing_allowed = true;
          };
          # Vimium
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
            default_private_browsing_allowed = true;
          };
          # Theme
          # Need to download and install the them before setting it later on
          "graffiti-bold-colorway@mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/graffiti-bold_/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        Permissions = {
          Camera = {
            BlockNewRequests = false;  # false = sites CAN ask; true = auto-deny, no prompt
              Locked = false;            # user can still change it in about:preferences if false
          };
          Microphone = {
            BlockNewRequests = false;
            Locked = false;
          };
          Notifications = { BlockNewRequests = false; };  # or true, if you're tired of the prompts
            Autoplay = {
              Default = "block-audio";  # or "allow-audio-video" / "block-audio-video"
            };
        };

        /* ---- COOKIE POLICY ---- */
        # Clear cookies on exit, except for exceptions defined below
        Cookies = {
          Behavior = "accept";
          ExpireAtSessionEnd = true; # Clears cookies when browser closes
          Allow = [
            "https://github.com"
            "https://youtube.com"
            "https://www.twitch.tv"
            "https://www.codingame.com"
            "https://store.steampowered.com"
            "https://wallhaven.cc"
            "https://accweb.mouv.desjardins.com"
          ];
        };
        /* ---- GLOBAL PREFERENCES ---- */
        Preferences = {
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };

      /* ---- PROFILES ---- */
      profiles = {
        profile_0 = {
          id = 0;
          name = "profile_0";
          isDefault = true;
          settings = {
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            /*
               Find the theme id:
               - Go to mozilla theme download
               - copy the dowload link, then dowload it with wget
               - rename the .xpi to .zip, then unzip it
               - in manifest.json, check browser_specific_settings.gecko.id
             */
            "extensions.activeThemeID" = "graffiti-bold-colorway@mozilla.org";
            "network.cookie.lifetimePolicy" = 2;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.clearOnShutdown.cookies" = true;
            "privacy.clearOnShutdown.cache" = true;
            "browser.toolbars.bookmarks.visibility" = "always"; # or "newtab" / "never"
          };
          bookmarks = {
            force = true;
            settings = [
            # A bookmark on the toolbar, in a folder
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
              { name = "FireMem";  url = "about:memory"; }
              { name = "NixOS";  url = "https://nixos.org"; }
              { name = "GitHub"; url = "https://github.com"; }
              {
                name = "Dev";
                bookmarks = [
                { name = "Home Manager options"; url = "https://nix-community.github.io/home-manager/options.xhtml"; }
                { name = "MyNixOS"; url = "https://mynixos.com"; }
                ];
              }
              ];
            }

            # Bookmarks in the regular Bookmarks Menu (not on the toolbar)
            {
              name = "Streaming";
              bookmarks = [
              { name = "YouTube"; url = "https://youtube.com"; }
              { name = "Twitch";  url = "https://www.twitch.tv"; }
              ];
            }

            # A standalone bookmark with a keyword shortcut + tags
            {
              name = "Wikipedia";
              url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
              keyword = "wiki";       # type "wiki <term>" in the address bar
                tags = [ "reference" ];
            }
            ];
          };

        };
      };
    };
  };
}


