{...}: {
  programs.lazygit = {
    enable = true;
    
    settings = {
      disableStartupPopups = true;
      os = {
        editInTerminal = false;
        open = "nvim --server /tmp/nvim-socket-$(tmux display -p '#{window_id}').pipe --remote {{filename}}; exit";
        edit = "nvim --server /tmp/nvim-socket-$(tmux display -p '#{window_id}').pipe --remote +{{line}} {{filename}}; exit";
        editAtLine = "nvim --server /tmp/nvim-socket-$(tmux display -p '#{window_id}').pipe --remote +{{line}} {{filename}}; exit";
      };
      git = {
        overrideGpg = true;
      };
    };
  };
}
