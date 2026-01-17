{
  userConfig,
  config,
  pkgs,
  ...
}: let
  inherit (userConfig) home;
in {
  system.primaryUser = userConfig.username;
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.WindowManager" = {
        EnableTiledWindowMargins = false;
        EnableTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = false;
        EnableTopTilingByEdgeDrag = false;
      };
    };

    NSGlobalDomain = {
      _HIHideMenuBar = true;
      # Whether to enable “Natural” scrolling direction
      "com.apple.swipescrolldirection" = false;
    };

    finder = {
      AppleShowAllFiles = true; # show hidden files
      CreateDesktop = false; # show icons on desktop
      FXPreferredViewStyle = "Nlsv"; # Change the default finder view. “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View The default is icnv.
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Dock
    dock = {
      autohide = true;
      autohide-time-modifier = 0.0;
      expose-animation-duration = 15.0; # Disable dock
      expose-group-apps = false;
      tilesize = 24;
      largesize = 79;
      launchanim = true;
      magnification = false;
      mineffect = "genie";
      orientation = "bottom";
      minimize-to-application = false;
      mouse-over-hilite-stack = false;
      mru-spaces = false;
      show-process-indicators = true;
      scroll-to-open = true;

      persistent-apps = [
        "/Applications/Arc.app"
        "/Applications/KakaoTalk.app"
        "/Applications/OBS.app"
        "/Applications/Setapp/Paw.app"
        "/Applications/Setapp/TablePlus.app"
        "/Applications/Termius.app"
        "/Applications/Spotify.app"
        "/Applications/iTerm.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Obsidian.app"
        "/System/Applications/Calendar.app"
        "/Applications/Linear.app"
        "/Applications/Discord.app"
        "/Applications/Slack.app"
        "/Applications/Akiflow.app"
        "/Applications/DeepL.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/System/Applications/iPhone Mirroring.app"
        "/System/Applications/System Settings.app"
      ];

      persistent-others = [
        {folder = {path = "${home}/Pictures/screenshots/"; displayas = "stack"; showas = "fan"; arrangement = "date-created";};}
        {folder = {path = "${home}/Downloads/"; displayas = "stack"; showas = "fan"; arrangement = "date-created";};}
      ];

      # Hot corner bottom right -> show desktop(2) / others -> disabled(1)
      "wvous-br-corner" = 2;
      "wvous-bl-corner" = 1;
      "wvous-tl-corner" = 1;
      "wvous-tr-corner" = 1;
    };
  };
}
