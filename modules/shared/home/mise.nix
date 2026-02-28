{ pkgs, lib, ... }:
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    globalConfig = {
      settings = {
        experimental = true;
        verbose = false;
        auto_install = true;
        idiomatic_version_file_enable_tools = [ ];
      };

      env.MISE_NODE_COREPACK = "true";

      tools = {
        node = "lts";
        bun = "latest";
        deno = "latest";
        uv = "latest";
        rust = "stable";
        pnpm = "latest";
        ruby = "3.2";
      };
    };
  };

  # Ensure curl is in PATH for rustup-init during mise tool installation
  home.activation.setupMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.curl}/bin:$PATH"
    ${pkgs.mise}/bin/mise install --yes 2>/dev/null || true
  '';
}
