{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "git-worktree-runner";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "coderabbitai";
    repo = "git-worktree-runner";
    rev = "v2.0.0";
    sha256 = "sha256-TPd+5WtEZsR6x4/OPVkrIpW7SSDJpbZbvjYR8rzdZAs=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r adapters/ lib/ templates/ $out
    cp bin/gtr bin/git-gtr $out/bin
    chmod +x $out/bin/gtr $out/bin/git-gtr

    cp -r completions/ $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Bash-based Git worktree manager with editor and AI tool integration";
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    license = licenses.asl20;
    mainProgram = "git-gtr";
    platforms = platforms.unix;
  };
}

