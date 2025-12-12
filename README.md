# Xeric Library

[![Lua](https://img.shields.io/badge/Language-Lua-blue?style=flat-square&logo=lua)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Platform-Roblox-brightgreen?style=flat-square&logo=roblox)](https://www.roblox.com/)

A sleek, modern UI library for Roblox, featuring animated, responsive widgets for seamless user experiences. Built for performance and customization, originally for Xeric Hub by [rxdavidcb](https://github.com/rxdavicb) (formerly fluflu). Free for all use.

## ✨ Features

- **Draggable Window**: Smooth top-bar dragging with minimize/restore and shadow effects.
- **Animated Elements**: TweenService-powered transitions for all interactions.
- **Tabbed Navigation**: Dynamic tab switching with active state indicators.
- **Widgets**:
- Buttons: Ripple feedback on click.
- Labels: Static text for sections/info.
- Toggles: Animated switches with state callbacks.
- Sliders: Draggable handles, value snapping, min/max bounds.
- Dropdowns: Single-select with expandable lists.
- Multi-Dropdowns: Checkbox-style multi-select.
- **Notifications**: Toast popups with progress bars and type variants (success, default).
- **Responsive Design**: Optimized for PC and mobile Roblox clients.

## 📦 Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/FluentUI/main/FluentUI.lua"))()
```

## 🚀 Quick Start

### Window & Tabs
```lua
local Window = Library:CreateWindow({ Name = "My Hub" })
local Tab1 = Window:CreateTab({ Name = "Main" })
local Tab2 = Window:CreateTab({ Name = "Settings" })
```

### Widgets
```lua
-- Button
Tab1:AddButton({ Name = "Action", Callback = function() print("Clicked!") end })

-- Label
Tab1:AddLabel({ Text = "Features" })

-- Toggle
local Toggle = Tab1:AddToggle({ Name = "Enabled", Default = false, Callback = function(value) end })
Toggle:Set(true)  -- Programmatic update

-- Slider
local Slider = Tab1:AddSlider({ Name = "Value", Min = 0, Max = 100, Default = 50, Increment = 5, Callback = function(value) end })
Slider:Set(75)

-- Dropdown
local Dropdown = Tab1:AddDropdown({ Name = "Select", Options = {"Opt1", "Opt2"}, Default = "Opt1", Callback = function(value) end })
Dropdown:Set("Opt2")
Dropdown:Refresh({"NewOpt1", "NewOpt2"}, true)

-- Multi-Dropdown
local Multi = Tab2:AddMultiDropdown({ Name = "Multi", Options = {"A", "B", "C"}, Default = {"A"}, Callback = function(values) end })
Multi:Set({"B", "C"})

-- Notification
Window:Notify({ Title = "Alert", Content = "Message", Type = "Success", Duration = 3 })
```

## 💡 Full Example

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/FluentUI/main/FluentUI.lua"))()

local Window = Library:CreateWindow({ Name = "Example Hub" })
local Main = Window:CreateTab({ Name = "Main" })
local Settings = Window:CreateTab({ Name = "Settings" })

Main:AddLabel({ Text = "Controls" })
Main:AddButton({ Name = "Reset", Callback = function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end })
local Speed = Main:AddSlider({ Name = "Speed", Min = 16, Max = 100, Default = 16, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end })

Settings:AddLabel({ Text = "Options" })
local ThemeToggle = Settings:AddToggle({ Name = "Dark Mode", Default = true, Callback = function(v) -- Theme logic end })
local Targets = Settings:AddMultiDropdown({ Name = "Targets", Options = {"Player1", "Player2"}, Callback = function(values) print(table.concat(values, ", ")) end })

Window:Notify({ Title = "Loaded", Content = "Example ready.", Type = "Success" })
```



## 🤝 Contributing & License

Fork and PR for improvements. MIT License. Credits: rxdavidcb  (formerly fluflu; original). Maintained by [rxdavidcb](https://github.com/rxdavidcb).
