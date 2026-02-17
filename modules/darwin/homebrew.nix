{
  userConfig,
  config,
  ...
}: let
  inherit (userConfig) username;
in {
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    #enableRosetta = true;
  };

  homebrew = {
    enable = true;

    taps = [];

    brews = [
      # <sketchybar>
      "switchaudio-osx"
      "nowplaying-cli"
      # </sketchybar>

      "hashcat"
      "luarocks"

      # <nvim>
      "pngpaste"
    ];

    casks = [
      "cursor"

      "lookaway"
      "kicad" # cad app

      # <sketchybar>
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      # </sketchybar>

      # <karabiner-elements>
      "karabiner-elements"
      # </karabiner-elements>

      # <wallpaper>
      "desktoppr"
      # </wallpaper>

      "ghostty"

      # <zen-browser>
      "zen"
      # </zen-browser>

      "minecraft"

      "freecad"

      "figma"

      "tailscale-app"

      "bluetility"

      "discord"

      "raycast"

      "android-studio"
    ];
  };
}
