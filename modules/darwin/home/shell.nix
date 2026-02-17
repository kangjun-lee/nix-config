{pkgs, config, ...}: let
  shellAliases = {
    # Modern replacements
    ls = "eza --icons";
    l = "eza -lbF --git --icons";
    ll = "eza -lbGF --git --icons";
    llm = "eza -lbGd --icons --git --sort=modified";
    la = "eza -lbhHgUmuSa --time-style=default --icons --git --color-scale";
    lx = "eza -lbhHgUmuSa@ --time-style=default ---icons -git --color-scale";
    lS = "eza -1 --icons";
    lt = "eza --tree --level=2 --icons";

    cat = "bat";
    top = "btop";

    # Editor aliases
    vi = "nvim";
    vim = "nvim";

    # Utility aliases
    c = "clear";
    lg = "lazygit";

    # Navigation aliases
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Git aliases (basic ones, more complex ones can go in git config)
    g = "git";
    ga = "git add";
    gc = "git commit";
    gst = "git status";
    gp = "git push";
    gl = "git pull";
    gco = "git checkout";
    gb = "git branch";
    gd = "git diff";
    glog = "git log --oneline --graph --decorate";

    q = "exit";

    # Yarn aliases
    y = "yarn";
    yr = "yarn run";
    yrd = "yarn run dev";
    yrb = "yarn run build";
    yrt = "yarn run test";
    ya = "yarn add";
    yd = "yarn remove";

    # PNPM aliases
    pn = "pnpm";
    pni = "pnpm install";
    pna = "pnpm add";
    pnr = "pnpm run";
    pnrd = "pnpm run dev";

    nvim = "nvim --listen /tmp/nvim-socket-$(tmux display -p '#{window_id}').pipe";

    wm = "workmux";
  };
in {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = shellAliases;

    initContent = ''
      export ANDROID_HOME=$HOME/Library/Android/sdk
      export PATH=$PATH:$ANDROID_HOME/emulator
      export PATH=$PATH:$ANDROID_HOME/tools
      export PATH=$PATH:$ANDROID_HOME/tools/bin
      export PATH=$PATH:$ANDROID_HOME/platform-tools
      export PATH=$HOME/.claude/local:$PATH
      export PATH=$HOME/.cargo/bin:$PATH

      export XDG_CONFIG_HOME="$HOME/.config"

      # Fix Xcode path for Expo compatibility
      export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

      $GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration
    '';

    envExtra = ''
      # https://github.com/anthropics/claude-code/issues/2110

      # also need mkdir -p ~/.config/direnv
      # touch ~/.config/direnv/direnv.toml
      # because there is a bug that causes DIRENV_LOG_FORMAT to be ignore if the config
      # file does not exist

      if command -v direnv >/dev/null; then
        if [[ ! -z "$CLAUDECODE" ]]; then
          eval "$(direnv hook zsh)"
          eval "$(DIRENV_LOG_FORMAT= direnv export zsh)"  # Need to trigger "hook" manually
        fi
      fi

      eval "$(${pkgs.mise}/bin/mise activate zsh)"
    '';
  };

  # Enable fish shell
  programs.fish = {
    enable = true;

    shellAliases = shellAliases;

    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];

    # Fish shell configuration
    shellInit = ''
      # Android SDK configuration
      set -gx ANDROID_HOME $HOME/Library/Android/sdk
      set -gx PATH $PATH $ANDROID_HOME/emulator
      set -gx PATH $PATH $ANDROID_HOME/tools
      set -gx PATH $PATH $ANDROID_HOME/tools/bin
      set -gx PATH $PATH $ANDROID_HOME/platform-tools
      set -gx PATH $HOME/.claude/local $PATH
      set -gx PATH $HOME/.cargo/bin $PATH
      set -gx XDG_CONFIG_HOME "$HOME/.config"

      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH

      set --export PATH /Users/gangjun/.opencode/bin $PATH

      # Fix Xcode path for Expo compatibility
      set -gx DEVELOPER_DIR "/Applications/Xcode.app/Contents/Developer"

      # apply local serets
      if test -f ~/.config/shell-secrets.fish
        source ~/.config/shell-secrets.fish
      end

      ${pkgs.mise}/bin/mise activate fish | source
    '';

    # Functions
    functions = {
      # Modern 'ls' function using eza
      l = "eza -la --icons $argv";

      # Quick directory navigation
      mkcd = {
        description = "Create directory and change to it";
        body = "mkdir -p $argv[1]; and cd $argv[1]";
      };

      # Extract function
      extract = {
        description = "Extract various archive formats";
        body = ''
          switch (string lower $argv[1])
            case "*.tar.bz2"
              tar xjf $argv[1]
            case "*.tar.gz"
              tar xzf $argv[1]
            case "*.bz2"
              bunzip2 $argv[1]
            case "*.rar"
              unrar e $argv[1]
            case "*.gz"
              gunzip $argv[1]
            case "*.tar"
              tar xf $argv[1]
            case "*.tbz2"
              tar xjf $argv[1]
            case "*.tgz"
              tar xzf $argv[1]
            case "*.zip"
              unzip $argv[1]
            case "*.Z"
              uncompress $argv[1]
            case "*.7z"
              7z x $argv[1]
            case "*"
              echo "Unknown archive format: $argv[1]"
          end
        '';
      };

      # Original: https://github.com/code-yeongyu/oh-my-opencode/blob/a691a3ac0a7bd9b7090ebcf591111aa1a24e84f5/docs/configurations.md
      oc = {
        description = "Launch opencode in tmux with unique session and port";
        body = ''
          set base_name (basename (pwd))
          set path_hash (echo (pwd) | md5 | cut -c1-4)
          set session_name "$base_name-$path_hash"

          # Find available port starting from 4096
          function __oc_find_port
              set port 4096
              while test $port -lt 5096
                  if not lsof -i :$port >/dev/null 2>&1
                      echo $port
                      return 0
                  end
                  set port (math $port + 1)
              end
              echo 4096
          end

          set oc_port (__oc_find_port)
          set -x OPENCODE_PORT $oc_port

          if set -q TMUX
              # Already inside tmux - just run with port
              opencode --port $oc_port $argv
          else
              # Create tmux session and run opencode
              set oc_cmd "OPENCODE_PORT=$oc_port opencode --port $oc_port $argv; exec fish"
              if tmux has-session -t "$session_name" 2>/dev/null
                  tmux new-window -t "$session_name" -c (pwd) "$oc_cmd"
                  tmux attach-session -t "$session_name"
              else
                  tmux new-session -s "$session_name" -c (pwd) "$oc_cmd"
              end
          end

          functions -e __oc_find_port
        '';
      };
    };

    shellAbbrs = {
      gg = "git gtr";
      gge = "git gtr editor";
      gga = "git gtr ai";
      ggn = "git gtr new --from-current";
      ggr = "git gtr run";
    };
  };

  home.file.".config/fish/completions/gtr.fish" = {
    source = "${pkgs.git-worktree-runner}/completions/gtr.fish";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.carapace.enable = true;
  programs.carapace.enableZshIntegration = true;
  programs.carapace.enableFishIntegration = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      format = "$all";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      gcloud.disabled = true;
      aws.disabled = true;

      git_branch.truncation_length = 26;
    };
  };
  catppuccin.starship.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enableFishIntegration = true;
}
