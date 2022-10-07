local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }
local meh = { "alt", "ctrl", "shift" }
local ca = { "alt", "ctrl" }
local cc = { "cmd", "ctrl" }

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
spoon.SpoonInstall:installSpoonFromZipURL("https://github.com/stuart-warren/editWithEmacs.spoon/releases/download/0.1.1/editWithEmacs.spoon.zip")
hs.loadSpoon("editWithEmacs")

-- Reload Configuration using a Spoon
spoon.ReloadConfiguration:start()

spoon.MiroWindowsManager:bindHotkeys({
	up = { hyper, "up" },
	right = { hyper, "right" },
	down = { hyper, "down" },
	left = { hyper, "left" },
	fullscreen = { hyper, "f" },
})

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

-- Emojis shows
spoon.Emojis:bindHotkeys({ toggle = { hyper, "f1" } })

-- Window management

-- Microphone management
spoon.MicMute:bindHotkeys({ toggle = { hyper, "d" } }, 0.75)

-- Mouse management
spoon.MouseFollowsFocus:start()

-- remove animations
hs.window.animationDuration = 0

-- Move current Window to another screen
function moveWindowToScreen(direction)
	local w = hs.window.frontmostWindow()
	local s = w:screen()

	if direction > 0 then
		w:moveToScreen(s:next():id())
	else
		w:moveToScreen(s:previous():id())
	end
end

hs.hotkey.bind(ca, "right", function()
	moveWindowToScreen(1)
end)
hs.hotkey.bind(ca, "left", function()
	moveWindowToScreen(-1)
end)

local apps = {
	b = "Google Chrome",
	c = "Google Calendar",
	e = "Emacs",
	f = "Finder",
	g = "Gmail",
	l = "Logseq",
	m = "Spotify",
	n = "Google Meet",
	s = "Slack",
	t = "iTerm",
	y = "YouTube",
}

-- TODO: https://github.com/dmgerman/editWithEmacs.spoon

for key, app in pairs(apps) do
	hs.hotkey.bind(hyperShift, key, function()
		hs.application.launchOrFocus(app)
	end)
end

if spoon.editWithEmacs then
   local bindings = {
      edit_selection =  { hyper, "a"},
      edit_all       = { hyperShift, "a"}
   }
   spoon.editWithEmacs:bindHotkeys(bindings)
end

hs.notify.show("Hammerspoon started with spoons", "", "")
