{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "tmux-file-picker";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "raine";
    repo = "tmux-file-picker";
    rev = "840bd302a281267e5fde2a8323682faa873cc718";
    sha256 = "sha256-gV65yhf4mFLoYg+Lf8RuLmhRwbF6ZawYqZLkRCSpXuQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tmux-file-picker $out/bin
    chmod +x $out/bin/tmux-file-picker
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fuzzy file picker in a tmux popup for selecting files with terminal-based AI coding assistants";
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    mainProgram = "tmux-file-picker";
    platforms = platforms.unix;
  };
}

