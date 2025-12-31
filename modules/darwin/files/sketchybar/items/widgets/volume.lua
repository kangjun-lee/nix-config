local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Device type detection function
local function get_device_type(device_name)
  local name = device_name:lower()
  if name:find("airpods") then return "airpods" end
  if name:find("headphone") or name:find("headset") then return "headphones" end
  if name:find("macbook") and name:find("speaker") then return "builtin" end
  if name:find("internal") then return "builtin" end
  if name:find("dell") or name:find("lg ") or name:find("samsung")
     or name:find("asus") or name:find("benq") or name:find("hdmi")
     or name:find("displayport") then return "display" end
  if name:match("^%w+%d+%w*$") and #name <= 12 then return "display" end
  if name:find("homepod") then return "homepod" end
  if name:find("bluetooth") or name:find("bt ") then return "bluetooth" end
  if name:find("driver") or name:find("stream") or name:find("virtual")
     or name:find("loopback") or name:find("soundflower") then return "virtual" end
  return "speaker"
end

local popup_width = 250

local volume_percent = sbar.add("item", "widgets.volume1", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??%",
    padding_left = -1,
    font = { family = settings.font.numbers }
  },
})

local volume_icon = sbar.add("item", "widgets.volume2", {
  position = "right",
  padding_right = -1,
  icon = {
    string = icons.volume._100,
    width = 0,
    align = "left",
    color = colors.grey,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = {
    width = 25,
    align = "left",
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
})

local device_icon = sbar.add("item", "widgets.volume3", {
  position = "right",
  padding_right = 0,
  icon = {
    string = icons.audio_device.speaker,
    color = colors.grey,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = { drawing = false },
})

local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
  device_icon.name,
  volume_icon.name,
  volume_percent.name
}, {
  background = { color = colors.bg1 },
  popup = { align = "center" }
})

sbar.add("item", "widgets.volume.padding", {
  position = "right",
  width = settings.group_paddings
})

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_bracket.name,
  slider = {
    highlight_color = colors.blue,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob= {
      string = "􀀁",
      drawing = true,
    },
  },
  background = { color = colors.bg1, height = 2, y_offset = -20 },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

volume_percent:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  local icon = icons.volume._0
  if volume > 60 then
    icon = icons.volume._100
  elseif volume > 30 then
    icon = icons.volume._66
  elseif volume > 10 then
    icon = icons.volume._33
  elseif volume > 0 then
    icon = icons.volume._10
  end

  local lead = ""
  if volume < 10 then
    lead = "0"
  end

  volume_icon:set({ label = icon })
  volume_percent:set({ label = lead .. volume .. "%" })
  volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
  local drawing = volume_bracket:query().popup.drawing == "on"
  if not drawing then return end
  volume_bracket:set({ popup = { drawing = false } })
  sbar.remove('/volume.device\\.*/')
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume_bracket:query().popup.drawing == "off"
  if should_draw then
    volume_bracket:set({ popup = { drawing = true } })
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        current = current_audio_device
        local color = colors.grey
        local counter = 0

        for device in string.gmatch(available, '[^\r\n]+') do
          local color = colors.grey
          if current == device then
            color = colors.white
          end
          sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume_bracket.name,
            width = popup_width,
            align = "center",
            label = { string = device, color = color },
            click_script = 'SwitchAudioSource -s "' .. device .. '" && sketchybar --set /volume.device\\.*/ label.color=' .. colors.grey .. ' --set $NAME label.color=' .. colors.white

          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.INFO.delta
  if not (env.INFO.modifier == "ctrl") then delta = delta * 10.0 end

  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_percent:subscribe("mouse.clicked", volume_toggle_details)
volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
volume_percent:subscribe("mouse.scrolled", volume_scroll)

-- Start audio device event provider
sbar.exec("killall audio_device >/dev/null; $CONFIG_DIR/helpers/event_providers/audio_device/bin/audio_device audio_device_change 1.0 &")

-- Subscribe to custom audio device change event
device_icon:subscribe("audio_device_change", function(env)
  local device_name = env.device or ""
  if device_name == "" then return end

  current_audio_device = device_name

  local device_type = get_device_type(device_name)
  local icon = icons.audio_device[device_type] or icons.audio_device.speaker
  device_icon:set({ icon = { string = icon } })
end)

device_icon:subscribe("mouse.clicked", volume_toggle_details)
device_icon:subscribe("mouse.scrolled", volume_scroll)

