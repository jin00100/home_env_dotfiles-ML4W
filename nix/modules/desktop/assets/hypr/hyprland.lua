--    __  _____  _____      __  ____  ____
--   /  |/  / / / / / | /| / / / __ \/ __/
--  / /|_/ / /_/_  _/ |/ |/ / / /_/ /\ \  
-- /_/  /_/____//_/ |__/|__/  \____/___/
--   
-- Advanced configuration for Hyprland

-- Setup Nix environment and software rendering for all spawned processes
local HOME = os.getenv("HOME") or ("/home/" .. (os.getenv("USER") or "user"))
local current_path = os.getenv("PATH") or ""
hl.env("PATH", HOME .. "/.nix-profile/bin:/nix/var/nix/profiles/default/bin:" .. current_path)
hl.env("QT_QUICK_BACKEND", "software")

-- FUNCTIONS
require("functions")

-- MONITORS
require("conf.monitor")
require("monitors")

-- INPUT
require("input")

-- GESTURE
require("gestures")

-- AUTOSTART
require("conf.autostart")

-- COLORS
require("colors")

-- CONFIGURATION
require("conf.environment")
require("conf.window")
require("conf.decoration")
require("conf.layout")
require("conf.workspace")
require("conf.misc")
require("conf.keybinding")
require("conf.windowrule")
require("conf.animation")
require("conf.ml4w")

-- CUSTOM
require("custom")

-- HYPRMOD
require("hyprland-gui")

