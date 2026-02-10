{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  imports = [
    ../../modules/darwin
  ];
}
