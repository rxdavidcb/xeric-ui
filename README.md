# Example Usage:
```lua
--[[
    Complete Usage Example for Enhanced Xeric UI Library
    Demonstrates ALL features available in the library
]]--

-- Load the library (replace with your actual library loading method)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rxdavidcb/xeric-ui/refs/heads/main/ui.lua"))()

-- Create the main window
local Window = Library:CreateWindow({
    Name = "Xeric Hub - Complete Demo"
})

-- Send a welcome notification
Window:Notify({
    Title = "Welcome!",
    Content = "Thanks for using Xeric UI. This demo shows all features!",
    Duration = 5,
    Type = "Success"
})

--[[ TAB 1: BASIC ELEMENTS ]]--
local MainTab = Window:CreateTab({
    Name = "Main"
})

-- Label
MainTab:AddLabel({
    Text = "Welcome to the complete UI library demo!"
})

-- Button
MainTab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
        Window:Notify({
            Title = "Button Pressed",
            Content = "You clicked the button!",
            Duration = 3,
            Type = "Default"
        })
    end
})

-- Divider with text
MainTab:AddDivider({
    Text = "Toggle Options"
})

-- Toggle
local myToggle = MainTab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle is now: " .. tostring(value))
    end
})

-- Another toggle
MainTab:AddToggle({
    Name = "Auto Farm",
    Default = true,
    Callback = function(value)
        if value then
            print("Auto Farm enabled!")
        else
            print("Auto Farm disabled!")
        end
    end
})

-- Simple divider (no text)
MainTab:AddDivider()

-- Slider
local speedSlider = MainTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        print("Walk speed set to: " .. value)
        -- Example: game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Another slider
MainTab:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 90,
    Increment = 5,
    Callback = function(value)
        print("FOV set to: " .. value)
        -- Example: workspace.CurrentCamera.FieldOfView = value
    end
})

--[[ TAB 2: DROPDOWNS & INPUTS ]]--
local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

-- Text Input
local usernameInput = SettingsTab:AddTextInput({
    Name = "Username",
    Placeholder = "Enter your username...",
    Default = "Player123",
    ClearTextOnFocus = false,
    Callback = function(text)
        print("Username entered: " .. text)
        Window:Notify({
            Title = "Username Set",
            Content = "Your username is: " .. text,
            Duration = 3,
            Type = "Success"
        })
    end
})

-- Another text input
local codeInput = SettingsTab:AddTextInput({
    Name = "Redeem Code",
    Placeholder = "Enter code here...",
    Default = "",
    ClearTextOnFocus = true,
    Callback = function(text)
        if text ~= "" then
            print("Attempting to redeem code: " .. text)
            Window:Notify({
                Title = "Code Redeemed",
                Content = "Code '" .. text .. "' has been redeemed!",
                Duration = 3,
                Type = "Success"
            })
        end
    end
})

SettingsTab:AddDivider({Text = "Dropdown Options"})

-- Regular Dropdown
local weaponDropdown = SettingsTab:AddDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    Default = "Sword",
    Callback = function(option)
        print("Selected weapon: " .. option)
    end
})

-- Another dropdown
local themeDropdown = SettingsTab:AddDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "Blue", "Purple", "Green"},
    Default = "Dark",
    Callback = function(option)
        print("Theme changed to: " .. option)
        Window:Notify({
            Title = "Theme Changed",
            Content = "UI theme set to " .. option,
            Duration = 2,
            Type = "Default"
        })
    end
})

SettingsTab:AddDivider()

-- Multi Dropdown
local perksDropdown = SettingsTab:AddMultiDropdown({
    Name = "Select Perks",
    Options = {"Speed Boost", "Jump Height", "Damage Up", "Health Regen", "Invisibility"},
    Default = {"Speed Boost", "Jump Height"},
    Callback = function(options)
        print("Selected perks:")
        for _, perk in ipairs(options) do
            print("  - " .. perk)
        end
    end
})

--[[ TAB 3: ADVANCED FEATURES ]]--
local AdvancedTab = Window:CreateTab({
    Name = "Advanced"
})

AdvancedTab:AddLabel({
    Text = "This tab demonstrates advanced features and methods."
})

AdvancedTab:AddDivider({Text = "Programmatic Control"})

-- Button to programmatically set toggle
AdvancedTab:AddButton({
    Name = "Enable Main Toggle",
    Callback = function()
        myToggle:Set(true)
        print("Programmatically enabled toggle!")
    end
})

-- Button to programmatically set slider
AdvancedTab:AddButton({
    Name = "Set Speed to Max",
    Callback = function()
        speedSlider:Set(100)
        print("Speed set to maximum!")
    end
})

-- Button to programmatically set dropdown
AdvancedTab:AddButton({
    Name = "Change Weapon to Bow",
    Callback = function()
        weaponDropdown:Set("Bow")
        print("Weapon changed to Bow!")
    end
})

-- Button to get text input value
AdvancedTab:AddButton({
    Name = "Get Username",
    Callback = function()
        local currentUsername = usernameInput:Get()
        Window:Notify({
            Title = "Current Username",
            Content = "Username is: " .. currentUsername,
            Duration = 3,
            Type = "Default"
        })
    end
})

AdvancedTab:AddDivider({Text = "Refresh Dropdown"})

-- Button to refresh dropdown options
local newWeapons = {"Sword", "Bow", "Staff", "Dagger", "Axe", "Hammer", "Spear", "Crossbow"}
AdvancedTab:AddButton({
    Name = "Add More Weapons",
    Callback = function()
        weaponDropdown:Refresh(newWeapons, true)
        Window:Notify({
            Title = "Weapons Updated",
            Content = "More weapons added to the list!",
            Duration = 3,
            Type = "Success"
        })
    end
})

--[[ TAB 4: NOTIFICATIONS ]]--
local NotifTab = Window:CreateTab({
    Name = "Notifications"
})

NotifTab:AddLabel({
    Text = "Test different notification types:"
})

NotifTab:AddDivider()

-- Default Notification
NotifTab:AddButton({
    Name = "Default Notification",
    Callback = function()
        Window:Notify({
            Title = "Information",
            Content = "This is a default notification with info icon.",
            Duration = 4,
            Type = "Default"
        })
    end
})

-- Success Notification
NotifTab:AddButton({
    Name = "Success Notification",
    Callback = function()
        Window:Notify({
            Title = "Success!",
            Content = "Operation completed successfully!",
            Duration = 4,
            Type = "Success"
        })
    end
})

-- Warning Notification
NotifTab:AddButton({
    Name = "Warning Notification",
    Callback = function()
        Window:Notify({
            Title = "Warning",
            Content = "This action may have consequences!",
            Duration = 4,
            Type = "Warning"
        })
    end
})

-- Error Notification
NotifTab:AddButton({
    Name = "Error Notification",
    Callback = function()
        Window:Notify({
            Title = "Error!",
            Content = "Something went wrong. Please try again.",
            Duration = 4,
            Type = "Error"
        })
    end
})

NotifTab:AddDivider({Text = "Custom Duration"})

-- Long notification
NotifTab:AddButton({
    Name = "Long Notification (8s)",
    Callback = function()
        Window:Notify({
            Title = "Extended Notice",
            Content = "This notification will stay for 8 seconds!",
            Duration = 8,
            Type = "Default"
        })
    end
})

-- Short notification
NotifTab:AddButton({
    Name = "Quick Notification (1s)",
    Callback = function()
        Window:Notify({
            Title = "Quick!",
            Content = "Gone in 1 second!",
            Duration = 1,
            Type = "Success"
        })
    end
})

--[[ TAB 5: EXAMPLES & INFO ]]--
local InfoTab = Window:CreateTab({
    Name = "Info"
})

InfoTab:AddLabel({
    Text = "Xeric UI Library - Complete Feature Demo"
})

InfoTab:AddDivider({Text = "Features"})

InfoTab:AddLabel({
    Text = "✓ Buttons with ripple effects"
})

InfoTab:AddLabel({
    Text = "✓ Toggles with smooth animations"
})

InfoTab:AddLabel({
    Text = "✓ Sliders with drag support"
})

InfoTab:AddLabel({
    Text = "✓ Dropdowns (single & multi-select)"
})

InfoTab:AddLabel({
    Text = "✓ Text inputs with callbacks"
})

InfoTab:AddLabel({
    Text = "✓ Dividers (plain & labeled)"
})

InfoTab:AddLabel({
    Text = "✓ Notifications (4 types)"
})

InfoTab:AddDivider({Text = "Device Support"})

InfoTab:AddLabel({
    Text = "✓ PC/Desktop optimized (900x650)"
})

InfoTab:AddLabel({
    Text = "✓ Mobile/Touch optimized (450x600)"
})

InfoTab:AddLabel({
    Text = "✓ Auto-detection of device type"
})

InfoTab:AddDivider()

InfoTab:AddButton({
    Name = "GitHub Repository",
    Callback = function()
        Window:Notify({
            Title = "GitHub",
            Content = "Check out the repository for updates!",
            Duration = 5,
            Type = "Default"
        })
        -- You can add a link copy function here
        print("Repository: [Your GitHub URL]")
    end
})

InfoTab:AddButton({
    Name = "Credits",
    Callback = function()
        Window:Notify({
            Title = "Credits",
            Content = "Created by fluflu • Enhanced with new features",
            Duration = 5,
            Type = "Success"
        })
    end
})

--[[ EXAMPLES OF PROGRAMMATIC METHODS ]]--

-- Example: Set text input value after 5 seconds
task.spawn(function()
    task.wait(5)
    usernameInput:Set("AutoSetName")
    print("Username automatically set!")
end)

-- Example: Toggle the main toggle after 3 seconds
task.spawn(function()
    task.wait(3)
    myToggle:Set(false)
    print("Toggle automatically disabled!")
end)

-- Example: Set multi-dropdown values
task.spawn(function()
    task.wait(7)
    perksDropdown:Set({"Damage Up", "Health Regen", "Invisibility"})
    print("Perks automatically updated!")
end)

print("Xeric UI Demo loaded successfully!")
print("All features are now available for testing.")
print("The UI is responsive and will adapt to your device type.")
```
