hyper = {"cmd", "alt", "ctrl"}
hyperShift = {"cmd", "alt", "ctrl", "shift"}
cas = {"alt", "ctrl", "shift"}
ca = {"alt", "ctrl"}
cc = {"cmd", "ctrl"}

hs.application.enableSpotlightForNameSearches(true)
-- download and install SpoonInstall manually
-- https://www.hammerspoon.org/Spoons/SpoonInstall.html
hs.loadSpoon("SpoonInstall")
spoon.use_syncinstall = true

spoon.SpoonInstall:andUse("ReloadConfiguration")
spoon.SpoonInstall:andUse("Emojis")
spoon.SpoonInstall:andUse("MouseFollowsFocus")
spoon.SpoonInstall:andUse("MicMute")
spoon.SpoonInstall:andUse("MiroWindowsManager")

-- Reload Configuration using a Spoon
spoon.ReloadConfiguration:start()

spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "f"}
})

-- Emojis shows
spoon.Emojis:bindHotkeys({toggle = {hyper, 'f1'}})

-- Window management

-- Microphone management
spoon.MicMute:bindHotkeys({toggle = {hyper, 'd'}}, 0.75)

-- Mouse management
spoon.MouseFollowsFocus:start()

-- remove animations
-- hs.window.animationDuration = 0

hs.hotkey.bind(ca, "right", function() moveWindowToScreen(1) end)
hs.hotkey.bind(ca, "left", function() moveWindowToScreen(-1) end)

-- Move current Window to another screen
function moveWindowToScreen(direction)
    local w = hs.window.frontmostWindow()
    local nextScreen

    if direction > 0 then
        nextScreen = w:moveOneScreenNorth()
    else
        nextScreen = w:moveOneScreenSouth()
    end

end

local apps = {
    b = 'Google Chrome',
    c = 'Google Calendar',
    v = 'YouTube',
    l = 'Logseq',
    e = 'Emacs',
    s = 'Slack',
    m = 'Spotify',
    f = 'Finder',
    t = 'iTerm',
}

for key, app in pairs(apps) do
    hs.hotkey.bind(hyperShift, key, function() hs.application.launchOrFocus(app) end)
end

hs.notify.show("Hammerspoon started with spoons", "", "")
