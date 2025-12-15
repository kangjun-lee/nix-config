{
  pkgs,
  userConfig,
  inputs,
  ...
}: let
  inherit (userConfig) username home;
  # username = "gangjun";
  # home = "/Users/gangjun";
in {
  home.username = username;
  home.homeDirectory = home;

  home.stateVersion = "24.11";

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./sketchybar.nix
    ./hammerspoon.nix
    ./karabiner
    ./zen-browser.nix
    ./shell.nix

    ../../shared/home/btop.nix
    ../../shared/home/git.nix
    ../../shared/home/spicetify.nix
    ../../shared/home/nvim.nix
    ../../shared/home/tmux.nix
    ../../shared/home/ghostty.nix
    ../../shared/home/weechat.nix
    ../../shared/home/yazi.nix
  ];

  # ----------

  # darwin.wallpaper.path = "${pkgs.wallpaper}/wallpapers/black-hole.png";

  home.packages = with pkgs; [
    # Development
    fnm # node version manager
    postgresql # PostgreSQL client (psql)
    poetry # Python package manager

    # Cli Utils
    wget
    curl

    fortune

    direnv

    act # Run github actions locally

    # GUI Apps - Study
    # pkgs.anki
    # pkgs.vlc
    fastlane

    figlet
    lolcat

    gitify

    pgadmin4-desktopmode

    graphite-cli

    eza

    # Network related TUI
    termshark
    trippy
    bandwhich
    # netscanner  # aarch64-darwin not supported
  ];

  programs.home-manager.enable = true;
  catppuccin.flavor = "mocha";
}
