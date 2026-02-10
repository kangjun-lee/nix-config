# Nix 패키지 마이그레이션 TODO

## 1. 중복 설치 정리 (Nix + Homebrew 둘 다 설치됨)

- [x] `neovim` - Nix (programs.neovim) + brew → brew 제거
- [x] `tmux` - Nix (programs.tmux) + brew → brew 제거
- [x] `gitmux` - Nix (home.packages) + brew → brew 제거
- [x] `git` - brew 설치 → Nix 또는 시스템 git 사용

```bash
brew uninstall neovim tmux gitmux
```

## 2. Homebrew Formula → Nix 추천

### 강력 추천 (nixpkgs에서 잘 관리됨)

| 패키지 | 설명 | 상태 |
|--------|------|------|
| `bat` | cat 대체, 구문 강조 | [x] |
| `fd` | find 대체 | [x] |
| `fzf` | fuzzy finder | [x] |
| `ripgrep` | grep 대체 | [x] |
| `gh` | GitHub CLI | [x] |
| `jq` | JSON 처리 | [x] |
| `tree` | 디렉토리 트리 | [x] |
| `zoxide` | cd 대체 | [x] |
| `tldr` | man 대체 | [x] |
| `bottom` | 시스템 모니터 | [x] |
| `tokei` | 코드 통계 | [x] |
| `aria2` | 다운로더 | [x] |

### 개발 도구

| 패키지 | 설명 | 상태 |
|--------|------|------|
| `deno` | JS/TS 런타임 | [ ] |
| `k9s` | Kubernetes TUI | [ ] |
| `lazydocker` | Docker TUI | [ ] |
| `lazysql` | SQL TUI | [ ] |
| `dive` | Docker 이미지 탐색 | [ ] |
| `terraform` | IaC | [ ] |
| `cloudflared` | Cloudflare 터널 | [ ] |
| `flyctl` | Fly.io CLI | [ ] |
| `rclone` | 클라우드 스토리지 | [ ] |

### 기타 유틸

| 패키지 | 설명 | 상태 |
|--------|------|------|
| `fastfetch` | 시스템 정보 (neofetch 대체) | [ ] |
| `navi` | 치트시트 | [ ] |
| `xplr` | 파일 탐색기 | [ ] |
| `pandoc` | 문서 변환 | [ ] |
| `ffmpeg` | 미디어 처리 | [ ] |

## 3. Homebrew Casks → Nix 가능

| Cask | nixpkgs 패키지 | 상태 |
|------|---------------|------|
| `iina` | `pkgs.iina` | [ ] |
| `raycast` | `pkgs.raycast` | [ ] |
| `stats` | `pkgs.stats` | [ ] |
| `anki` | `pkgs.anki` | [ ] |
| `hammerspoon` | `pkgs.hammerspoon` | [ ] |
| `discord` | `pkgs.discord` | [ ] |

## 4. Homebrew에 남겨두는 게 나은 것들

- `gcloud-cli`, `google-cloud-sdk` - brew가 업데이트 관리 용이
- `wine-crossover` - nixpkgs 지원 부족
- `via`, `kicad`, `freecad` - 특수 하드웨어/CAD 앱
- `ngrok` - brew가 더 최신
- `karabiner-elements` - 시스템 통합 필요
- `ghostty` - 아직 nixpkgs에 unstable

## 5. 기타 설치된 앱 (brew 외) - /Applications 분석

### Nix로 옮길 수 있는 앱들

| 앱 | nixpkgs 패키지 | 현재 설치 방식 | 우선순위 |
|----|---------------|---------------|---------|
| AlDente | `pkgs.aldente` | 직접 설치 | 중 |
| AltTab | `pkgs.alt-tab-macos` | 직접 설치 | 중 |
| Android Studio | `pkgs.android-studio` | 직접 설치 | 낮음 |
| AnyDesk | `pkgs.anydesk` | 직접 설치 | 낮음 |
| Arduino | `pkgs.arduino-ide` | 직접 설치 | 낮음 |
| Barrier | `pkgs.barrier` | 직접 설치 | 중 |
| DBeaver | `pkgs.dbeaver-bin` | 직접 설치 | 중 |
| Firefox | `pkgs.firefox-bin` | 직접 설치 | 중 |
| GIMP | `pkgs.gimp` | 직접 설치 | 낮음 |
| Godot | `pkgs.godot_4` | 직접 설치 | 낮음 |
| Google Chrome | `pkgs.google-chrome` | 직접 설치 | 중 |
| ImageOptim | `pkgs.imageoptim` | 직접 설치 | 낮음 |
| Keka | `pkgs.keka` | 직접 설치 | 중 |
| OBS | `pkgs.obs-studio` | 직접 설치 | 중 |
| Obsidian | `pkgs.obsidian` | 직접 설치 | 높음 |
| OpenShot | `pkgs.openshot-qt` | 직접 설치 | 낮음 |
| Postman | `pkgs.postman` | 직접 설치 | 중 |
| RustDesk | `pkgs.rustdesk` | 직접 설치 | 낮음 |
| Slack | `pkgs.slack` | 직접 설치 | 높음 |
| Steam | `pkgs.steam` | 직접 설치 | 낮음 |

### Homebrew Cask로 관리 가능 (nixpkgs 미지원)

| 앱 | brew cask | 비고 |
|----|-----------|------|
| Arc | `arc` | 브라우저 |
| BetterDisplay | `betterdisplay` | 디스플레이 관리 |
| Cap | `cap` | 스크린 레코더 |
| Claude | `claude` | AI |
| DeepL | `deepl` | 번역 |
| DevToys | `devtoys` | 개발 도구 모음 |
| Drafts | `drafts` | 노트 |
| GitButler | `gitbutler` | Git GUI |
| Heynote | `heynote` | 노트 |
| Homerow | `homerow` | 키보드 네비게이션 |
| Jan | `jan` | 로컬 AI |
| KeyCastr | `keycastr` | 키 입력 표시 |
| Linear | `linear-linear` | 이슈 트래커 |
| Microsoft Edge | `microsoft-edge` | 브라우저 |
| NetBird | `netbird-ui` | VPN |
| Postico 2 | `postico` | PostgreSQL GUI |
| Termius | `termius` | SSH 클라이언트 |
| VOICEVOX | `voicevox` | 음성 합성 |
| Zoom | `zoom` | 화상회의 |

### App Store / 특수 설치 (Nix/Homebrew 불가)

| 앱 | 설치 방식 | 비고 |
|----|----------|------|
| Adobe Creative Cloud | 직접 설치 | Adobe 앱들 |
| Adobe Illustrator 2024 | Creative Cloud | |
| Xcode | App Store | Apple 개발 도구 |
| GarageBand | App Store | |
| Numbers | App Store | |
| KakaoTalk | App Store | |
| Millie | App Store | 전자책 |
| YES24 eBook | App Store | 전자책 |

### 유지 (직접 설치 유지 권장)

| 앱 | 이유 |
|----|------|
| Docker | Docker Desktop 라이선스/업데이트 관리 |
| Cisco Packet Tracer | Cisco 계정 필요 |
| Focusrite Control | 오디오 드라이버 |
| Talon | 음성 코딩, 특수 설치 |
| VIA / Vial | 키보드 펌웨어 도구 |
| SEGGER | 임베디드 개발 도구 |
| Nordic Semiconductor | 임베디드 개발 도구 |
| Setapp | 구독 서비스 |

### 정리 대상 (사용 안 함 / 중복)

| 앱 | 이유 |
|----|------|
| Hammerspoon.app (/Applications) | Home Manager Apps에 이미 있음 |
| Microsoft Remote Desktop | 사용 여부 확인 |
| VNC Viewer | 사용 여부 확인 |
| Antigravity | 사용 여부 확인 |
| Rona / RonaAlpha | 사용 여부 확인 |
| Surf | 사용 여부 확인 |
| Overlayed | 사용 여부 확인 |
| PhoneCast | 사용 여부 확인 |
| Tomito | 사용 여부 확인 |
| Tiro | 사용 여부 확인 |
| screenpipe | 사용 여부 확인 |
| Session | 사용 여부 확인 |
| Unicorn HTTPS | 사용 여부 확인 |
| JustStream | 사용 여부 확인 |
| Mousecape | 사용 여부 확인 |
| ScreenBrush | 사용 여부 확인 |
| MacForge | 사용 여부 확인 |
| ImageDiff | 사용 여부 확인 |
| icns creator | 사용 여부 확인 |
| Dia | 사용 여부 확인 |
| Balance | 사용 여부 확인 |
| AU Lab | 사용 여부 확인 |
| etcd-manager / Etcd Workbench | 사용 여부 확인 |
| ResponsivelyApp | 사용 여부 확인 |
| Screaming Frog SEO Spider | 사용 여부 확인 |

---

## 6. 현재 Nix Home Manager로 관리되는 앱

- Gitify (`~/Applications/Home Manager Apps/`)
- Hammerspoon (`~/Applications/Home Manager Apps/`)
- Spotify (Spicetify) (`~/Applications/Home Manager Apps/`)
