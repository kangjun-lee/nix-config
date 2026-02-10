{pkgs, ...}: {
  home.packages = with pkgs; [
    hammerspoon
    stackline
  ];

  #  <yabai> <stackline>
  home.file.".hammerspoon/stackline" = {
    source = builtins.toPath (pkgs.stackline + "/source");
    recursive = true;
  };
  home.file.".hammerspoon/init.lua".text = ''
    require("hs.ipc")

    stackline = require "stackline"
    stackline:init({
        paths = {
            yabai = "${pkgs.yabai}/bin/yabai"
        },
    })

    stackline.config:set('appearance.showIcons', true)
    -- stackline.config:set('appearance.color', { red=0.094, green=0.086, blue=0.137 })
    stackline.config:set('appearance.color', { red=0.72, green=0.58, blue=0.87 })
    stackline.config:set('features.clickToFocus', false)

    -- display current language
    -- https://cliearl.github.io/posts/etc/show-current-language-in-macos/
    local inputSource = {
      english = "com.apple.keylayout.ABC",
      english2 = "io.github.colemakmods.keyboardlayout.colemakdh.colemakdhmatrix-extended",
      korean2 = "org.youknowone.inputmethod.Gureum.han2",
      korean3 = "org.youknowone.inputmethod.Gureum.han3moa-semoe-2018i",
      japanese = "com.apple.inputmethod.Japanese"
    }

    local customStyle = hs.alert.defaultStyle

    customStyle.fillColor = { white = 0, alpha = 0.25 }
    customStyle.strokeColor = { alpha = 0 }

    customStyle.textColor = { white = 0.75, alpha = 0.75 }
    customStyle.textSize = 50

    customStyle.fadeOutDuration = 1.0

    function IM_alert()

    local current = hs.keycodes.currentSourceID()
    local language = nil


    if current == inputSource.korean2 then
    language = ' 🇰🇷 두벌식 '
    elseif current == inputSource.korean3 then
    language = ' 🇰🇷 세벌식 '
    elseif current == inputSource.english then
    language = ' 🇺🇸 QWERTY '
    elseif current == inputSource.english2 then
    language = ' 🇺🇸 COLEMAK '
    elseif current == inputSource.japanese then
    language = ' 🇯🇵 あいう '
    else
    language = current
    end

    if hs.keycodes.currentSourceID() == last_alerted_IM_ID then return end

    hs.alert.closeSpecific(last_IM_alert_uuid)
    last_IM_alert_uuid = hs.alert.show(language, customStyle, 0.3)
    last_alerted_IM_ID = hs.keycodes.currentSourceID()
    end


    hs.keycodes.inputSourceChanged(IM_alert)

    local opencodeNotification = nil
    local opencodeHotkeyEsc = nil
    local opencodeHotkeyEnter = nil
    local opencodeTarget = nil

    function opencode_dismiss()
      if opencodeNotification then
        opencodeNotification:delete()
        opencodeNotification = nil
      end
      if opencodeHotkeyEsc then
        opencodeHotkeyEsc:delete()
        opencodeHotkeyEsc = nil
      end
      if opencodeHotkeyEnter then
        opencodeHotkeyEnter:delete()
        opencodeHotkeyEnter = nil
      end
      opencodeTarget = nil
    end

    function opencode_goto()
      if opencodeTarget and opencodeTarget.session and opencodeTarget.window then
        local target = opencodeTarget.session .. ":" .. opencodeTarget.window
        hs.execute("tmux select-window -t " .. target, true)
        local terminalApps = {"Ghostty", "WezTerm", "iTerm2", "Terminal"}
        for _, appName in ipairs(terminalApps) do
          local app = hs.application.find(appName)
          if app then
            app:activate()
            break
          end
        end
      end
      opencode_dismiss()
    end

    function opencode_notify(session, window, event, paneTitle, message, duration)
      opencode_dismiss()

      local screen = hs.screen.mainScreen()
      local frame = screen:frame()

      local width = 440
      local padding = 16
      local headerHeight = 32
      local paneTitleHeight = paneTitle and paneTitle ~= "" and 24 or 0
      local messageHeight = message and message ~= "" and 22 or 0
      local totalHeight = padding + headerHeight + paneTitleHeight + messageHeight + padding

      local x = frame.x + (frame.w - width) / 2
      local y = frame.y + 100

      opencodeNotification = hs.canvas.new({ x = x, y = y, w = width, h = totalHeight })

      local eventColors = {
        complete = { red = 0.2, green = 0.8, blue = 0.4 },
        error = { red = 1, green = 0.4, blue = 0.4 },
        permission = { red = 1, green = 0.7, blue = 0.2 },
        question = { red = 0.4, green = 0.6, blue = 1 },
      }
      local eventIcons = {
        complete = "✓",
        error = "✗",
        permission = "⚡",
        question = "?",
      }
      local accentColor = eventColors[event] or { red = 0.5, green = 0.5, blue = 0.5 }
      local icon = eventIcons[event] or "●"

      local border = 2
      opencodeNotification[1] = {
        type = "rectangle",
        fillColor = { red = 0.1, green = 0.1, blue = 0.14, alpha = 0.96 },
        strokeColor = { red = accentColor.red, green = accentColor.green, blue = accentColor.blue, alpha = 0.5 },
        strokeWidth = 1.5,
        roundedRectRadii = { xRadius = 12, yRadius = 12 },
        frame = { x = border, y = border, w = width - border * 2, h = totalHeight - border * 2 },
      }

      local idx = 2
      local yOffset = padding

      opencodeNotification[idx] = {
        type = "rectangle",
        fillColor = { red = accentColor.red * 0.3, green = accentColor.green * 0.3, blue = accentColor.blue * 0.3, alpha = 0.8 },
        roundedRectRadii = { xRadius = 5, yRadius = 5 },
        frame = { x = padding, y = yOffset + 5, w = 24, h = 20 },
      }
      idx = idx + 1

      opencodeNotification[idx] = {
        type = "text",
        text = icon,
        textColor = accentColor,
        textSize = 12,
        textFont = ".AppleSystemUIFontBold",
        textAlignment = "center",
        frame = { x = padding, y = yOffset + 5, w = 24, h = 20 },
      }
      idx = idx + 1

      local badgeX = padding + 30
      if session and session ~= "" then
        opencodeNotification[idx] = {
          type = "rectangle",
          fillColor = { white = 0.2, alpha = 0.6 },
          roundedRectRadii = { xRadius = 4, yRadius = 4 },
          frame = { x = badgeX, y = yOffset + 5, w = 44, h = 20 },
        }
        idx = idx + 1

        opencodeNotification[idx] = {
          type = "text",
          text = session,
          textColor = { white = 0.9, alpha = 1 },
          textSize = 11,
          textFont = ".AppleSystemUIFontMedium",
          textAlignment = "center",
          frame = { x = badgeX, y = yOffset + 6, w = 44, h = 18 },
        }
        idx = idx + 1
        badgeX = badgeX + 48
      end

      if window and window ~= "" then
        opencodeNotification[idx] = {
          type = "rectangle",
          fillColor = { white = 0.15, alpha = 0.6 },
          roundedRectRadii = { xRadius = 4, yRadius = 4 },
          frame = { x = badgeX, y = yOffset + 5, w = 28, h = 20 },
        }
        idx = idx + 1

        opencodeNotification[idx] = {
          type = "text",
          text = "#" .. window,
          textColor = { white = 0.7, alpha = 1 },
          textSize = 11,
          textFont = ".AppleSystemUIFont",
          textAlignment = "center",
          frame = { x = badgeX, y = yOffset + 6, w = 28, h = 18 },
        }
        idx = idx + 1
      end

      opencodeNotification[idx] = {
        type = "text",
        text = event:upper(),
        textColor = accentColor,
        textSize = 13,
        textFont = ".AppleSystemUIFontBold",
        textAlignment = "right",
        frame = { x = width - padding - 100, y = yOffset + 6, w = 100, h = 22 },
      }
      idx = idx + 1
      yOffset = yOffset + headerHeight

      if paneTitle and paneTitle ~= "" then
        opencodeNotification[idx] = {
          type = "text",
          text = paneTitle,
          textColor = { white = 1, alpha = 0.95 },
          textSize = 15,
          textFont = ".AppleSystemUIFont",
          frame = { x = padding, y = yOffset, w = width - padding * 2, h = paneTitleHeight },
        }
        idx = idx + 1
        yOffset = yOffset + paneTitleHeight
      end

      if message and message ~= "" then
        opencodeNotification[idx] = {
          type = "text",
          text = message,
          textColor = { white = 0.6, alpha = 0.85 },
          textSize = 12,
          textFont = ".AppleSystemUIFont",
          frame = { x = padding, y = yOffset, w = width - padding * 2, h = messageHeight },
        }
      end

      opencodeNotification:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
      opencodeNotification:level(hs.canvas.windowLevels.overlay)
      opencodeNotification:show()

      opencodeTarget = { session = session, window = window }
      opencodeHotkeyEsc = hs.hotkey.bind({}, "escape", opencode_dismiss)
      opencodeHotkeyEnter = hs.hotkey.bind({"cmd"}, "return", opencode_goto)

      if duration and duration > 0 then
        hs.timer.doAfter(duration, opencode_dismiss)
      end
    end

    -- Screen blackout toggle
    local blackoutCanvases = {}

    function toggleBlackout()
      if #blackoutCanvases > 0 then
        for _, canvas in ipairs(blackoutCanvases) do
          canvas:delete()
        end
        blackoutCanvases = {}
      else
        local screens = hs.screen.allScreens()
        for i, screen in ipairs(screens) do
          local frame = screen:fullFrame()
          local canvas = hs.canvas.new(frame)
          canvas[1] = {
            type = "rectangle",
            fillColor = { red = 0, green = 0, blue = 0, alpha = 1 },
            frame = { x = 0, y = 0, w = frame.w, h = frame.h },
          }
          canvas:level(hs.canvas.windowLevels.screenSaver)
          canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
          canvas:show()
          blackoutCanvases[i] = canvas
        end
      end
    end

    hs.hotkey.bind({"ctrl", "alt"}, "b", toggleBlackout)
  '';
  # <yabai> <stackline>
}
