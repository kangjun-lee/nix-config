{
  config,
  pkgs,
  userConfig,
  ...
}: {
  home.file = {
    "Library/Application Support/com.mitchellh.ghostty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${userConfig.nixConfig}/modules/shared/files/ghostty";
      recursive = true;
      force = true;
    };
  };
}
