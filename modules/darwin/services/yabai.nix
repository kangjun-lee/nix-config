{
  pkgs,
  userConfig,
  config,
  ...
}: let
  inherit (userConfig) username;
in {
  # <yabai />

  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;
    style = "round";
    width = 6.0;
    hidpi = false;
    active_color = "0xffcba6f7";
    inactive_color = "0xff45475a";
    # blacklist = "Arc";
  };

  environment.etc."sudoers.d/yabai".text = ''
    ${username} ALL = (root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
  '';

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      external_bar = "all:38:0";
      mouse_follows_focus = "on";
      focus_follows_mouse = "autofocus";
      window_zoom_persist = "off";
      window_placement = "second_child";
      window_shadow = "float";
      window_opacity = "off";
      window_opacity_duration = 0.0;
      active_window_opacity = 1.0;
      normal_window_opacity = 1.0;
      window_animation_duration = 0.3;
      split_ratio = 0.50;
      auto_balance = "off";
      mouse_modifier = "ctrl";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      top_padding = 14;
      bottom_padding = 14;
      left_padding = 14;
      right_padding = 14;
      window_gap = 14;
    };

    extraConfig = ''
      # reference - https://github.com/rayandrew/nix-config/blob/main/nix-darwin/yabai/default.nix
      wait4path /etc/sudoers.d/yabai
      sudo yabai --load-sa
      launchctl unload -F /System/Library/LaunchAgents/com.apple.WindowManager.plist > /dev/null 2>&1 &
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"


      # setup rules
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Karabiner-Elements$" manage=off
      yabai -m rule --add app="^DevUtils$" manage=off
      yabai -m rule --add app="Raycast" manage=off
      yabai -m rule --add app="TickTick" manage=off
      yabai -m rule --add app="DeepL" manage=off
      yabai -m rule --add app="Finder" manage=off
      yabai -m rule --add app="^Godot$" manage=off
      yabai -m rule --add app="DaysAI Analyzer" manage=off
      yabai -m rule --add app="CleanShot X" manage=off mouse_follows_focus=off
      yabai -m rule --add app="ChatGPT" manage=off mouse_follows_focus=off
      yabai -m rule --add app="qmk-display" manage=off
      yabai -m rule --add app="Session" manage=off
      yabai -m rule --add app="Rona" manage=off

      # mark window as scratchpad using rule and set size (scratchpad windows are manage=off automatically)
      yabai -m rule --add app="^카카오톡$" scratchpad=kakaotalk
      yabai -m rule --add app="^Spotify$" scratchpad=spotify grid=11:11:1:1:9:9
      yabai -m rule --add app="^Discord$" title!="^Discord Updater$" scratchpad=discord grid=11:11:1:1:9:9
      yabai -m rule --add app="^Slack$" scratchpad=slack grid=11:11:1:1:9:9
      yabai -m rule --add app="^Akiflow$" title!="^Akiflow -" scratchpad=akiflow grid=11:11:1:1:9:9
      yabai -m rule --add app="^Linear$" scratchpad=linear grid=11:11:1:1:9:9
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
    '';
  };
}
