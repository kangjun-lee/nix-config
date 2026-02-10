{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
    ] ++ [
      {
        src = pkgs.fetchFromGitHub {
          owner = "Spikerko";
          repo = "spicy-lyrics";
          rev = "5.19.11";
          hash = "sha256-87a+EsOPP97+u8/P3RUMeT2CoWCzerdaGbI+olD9mbE=";
        } + "/builds";
        name = "spicy-lyrics.mjs";
      }
    ];
  };
}
