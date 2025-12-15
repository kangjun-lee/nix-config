{...} @ inputs: final: prev: {
  git-worktree-runner = prev.callPackage ../pkgs/git-worktree-runner.nix {};
  wallpaper = prev.callPackage ../pkgs/wallpaper.nix {};

  sbar-lua = prev.callPackage ../pkgs/darwin/sbarlua.nix {};
  stackline = prev.callPackage ../pkgs/darwin/stackline.nix {};
  hammerspoon = prev.callPackage ../pkgs/darwin/hammerspoon.nix {};
}
