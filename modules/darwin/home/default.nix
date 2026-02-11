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
    ../../shared/home/mise.nix
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
    postgresql # PostgreSQL client (psql)
    # poetry - installed via mise/pipx (nixpkgs rapidfuzz build broken on aarch64-darwin)

    # Cli Utils
    bat # cat 대체, 구문 강조
    fd # find 대체
    fzf # fuzzy finder
    ripgrep # grep 대체
    gh # GitHub CLI
    jq # JSON 처리
    tree # 디렉토리 트리
    zoxide # cd 대체
    tldr # man 대체
    bottom # 시스템 모니터
    tokei # 코드 통계
    aria2 # 다운로더

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

    # docker
    colima
    docker
    docker-buildx
    
    # battery management
    aldente

    obsidian

    wrangler

    # workmux - tmux workspace manager
    workmux
  ];

  # OpenCode workmux status plugin
  home.file.".config/opencode/plugin/workmux-status.ts" = {
    text = ''
      import type { Plugin } from '@opencode-ai/plugin';

      export const WorkmuxStatusPlugin: Plugin = async ({ $ }) => {
        return {
          event: async ({ event }) => {
            switch (event.type) {
              case 'session.status':
                if (event.properties.status.type === 'busy') {
                  await $`workmux set-window-status working`.quiet();
                }
                break;
              case 'permission.updated':
                await $`workmux set-window-status waiting`.quiet();
                break;
              case 'permission.replied':
                await $`workmux set-window-status working`.quiet();
                break;
              case 'session.idle':
                await $`workmux set-window-status done`.quiet();
                break;
            }
          },
        };
      };
    '';
  };

  programs.home-manager.enable = true;
  catppuccin.flavor = "mocha";
}
