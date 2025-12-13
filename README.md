# Xeric UI Library 🎨

A modern, feature-rich UI library for Roblox with smooth animations, responsive design, and comprehensive components.

## Features ✨

- 🎯 **Responsive Design** - Automatically adapts to PC (900x650) and Mobile (450x600)
- 🌊 **Smooth Animations** - Ripple effects, tweens, and transitions
- 📱 **Touch Support** - Full mobile and tablet compatibility
- 🎨 **Modern Theme** - Sleek dark theme with red accents
- 🔔 **Notification System** - 4 notification types with customizable duration
- 🪟 **Minimizable Window** - Collapse UI to title bar with animated title

---

## Installation

```lua
local Library = loadstring(game:HttpGet("raw url here"))()
```

---

## Basic Setup

```lua
-- Create Window
local Window = Library:CreateWindow({
    Name = "My Hub"
})

-- Create Tab
local Tab = Window:CreateTab({
    Name = "Main"
})
```

---

## Components

### 1. Button

Creates a clickable button with ripple effect.

```lua
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

**Properties:**
- `Name` (string) - Button text
- `Callback` (function) - Function to execute on click

---

### 2. Label

Creates a non-interactive text label.

```lua
Tab:AddLabel({
    Text = "This is a label"
})
```

**Properties:**
- `Text` (string) - Label text

**Returns:** Label instance (can update `.Text` property)

---

### 3. Toggle

Creates a switch/toggle with on/off states.

```lua
local toggle = Tab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle is now:", value)
    end
})

-- Programmatic control
toggle:Set(true)  -- Set to enabled
```

**Properties:**
- `Name` (string) - Toggle label
- `Default` (boolean) - Initial state (default: false)
- `Callback` (function) - Called with boolean value on change

**Methods:**
- `:Set(value)` - Programmatically set toggle state

---

### 4. Slider

Creates a draggable slider for numeric values.

```lua
local slider = Tab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Programmatic control
slider:Set(50)  -- Set to specific value
```

**Properties:**
- `Name` (string) - Slider label
- `Min` (number) - Minimum value (default: 0)
- `Max` (number) - Maximum value (default: 100)
- `Default` (number) - Initial value (default: 50)
- `Increment` (number) - Step size (default: 1)
- `Callback` (function) - Called with number value on change

**Methods:**
- `:Set(value)` - Programmatically set slider value

---

### 5. Dropdown

Creates a single-select dropdown menu.

```lua
local dropdown = Tab:AddDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Bow", "Staff"},
    Default = "Sword",
    Callback = function(option)
        print("Selected:", option)
    end
})

-- Programmatic control
dropdown:Set("Bow")  -- Select specific option

-- Refresh options
dropdown:Refresh({"Sword", "Bow", "Staff", "Axe"}, true)  -- keepCurrent = true
```

**Properties:**
- `Name` (string) - Dropdown label
- `Options` (table) - Array of option strings
- `Default` (string) - Initially selected option (default: first option)
- `Callback` (function) - Called with selected string on change

**Methods:**
- `:Set(value)` - Select specific option
- `:Refresh(newOptions, keepCurrent)` - Update available options
  - `newOptions` (table) - New array of options
  - `keepCurrent` (boolean) - Keep current selection if it exists in new options

---

### 6. Multi Dropdown

Creates a multi-select dropdown with checkboxes.

```lua
local multiDropdown = Tab:AddMultiDropdown({
    Name = "Select Perks",
    Options = {"Speed", "Jump", "Damage", "Health"},
    Default = {"Speed", "Jump"},
    Callback = function(selected)
        print("Selected perks:")
        for _, perk in ipairs(selected) do
            print("  -", perk)
        end
    end
})

-- Programmatic control
multiDropdown:Set({"Damage", "Health"})  -- Set multiple selections
```

**Properties:**
- `Name` (string) - Multi-dropdown label
- `Options` (table) - Array of option strings
- `Default` (table) - Array of initially selected options (default: {})
- `Callback` (function) - Called with array of selected strings on change

**Methods:**
- `:Set(values)` - Set multiple selections (array of strings)

---

### 7. Text Input

Creates a text input field with Enter key support.

```lua
local input = Tab:AddTextInput({
    Name = "Username",
    Placeholder = "Enter your name...",
    Default = "",
    ClearTextOnFocus = false,
    Callback = function(text)
        print("You entered:", text)
    end
})

-- Programmatic control
input:Set("NewName")        -- Set text value
local value = input:Get()   -- Get current text
```

**Properties:**
- `Name` (string) - Input label
- `Placeholder` (string) - Placeholder text (default: "Enter text...")
- `Default` (string) - Initial text value (default: "")
- `ClearTextOnFocus` (boolean) - Clear text when focused (default: false)
- `Callback` (function) - Called with text string when Enter is pressed

**Methods:**
- `:Set(text)` - Programmatically set input text
- `:Get()` - Get current input text

---

### 8. Divider

Creates a horizontal line separator, optionally with text.

```lua
-- Simple divider (line only)
Tab:AddDivider()

-- Labeled divider (line with text)
Tab:AddDivider({
    Text = "Settings"
})
```

**Properties:**
- `Text` (string, optional) - Centered label text

---

## Notifications

Display temporary notifications in the bottom-right corner.

```lua
Window:Notify({
    Title = "Success!",
    Content = "Operation completed successfully",
    Duration = 3,
    Type = "Success"
})
```

**Properties:**
- `Title` (string) - Notification title (default: "Notification")
- `Content` (string) - Notification message (default: "This is a notification")
- `Duration` (number) - Display time in seconds (default: 3)
- `Type` (string) - Notification type:
  - `"Default"` - Red theme with info icon (ℹ)
  - `"Success"` - Green theme with check icon (✓)
  - `"Warning"` - Orange theme with warning icon (⚠)
  - `"Error"` - Red theme with X icon (✗)

---

## Complete Example

```lua
local Library = loadstring(game:HttpGet("your-library-url"))()

-- Create window
local Window = Library:CreateWindow({
    Name = "My Awesome Hub"
})

-- Welcome notification
Window:Notify({
    Title = "Welcome!",
    Content = "Hub loaded successfully",
    Duration = 5,
    Type = "Success"
})

-- Create tabs
local MainTab = Window:CreateTab({Name = "Main"})
local SettingsTab = Window:CreateTab({Name = "Settings"})

-- Add components to Main tab
MainTab:AddLabel({Text = "Welcome to the hub!"})

MainTab:AddButton({
    Name = "Test Button",
    Callback = function()
        print("Button works!")
    end
})

MainTab:AddDivider({Text = "Options"})

local toggle = MainTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

MainTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Add components to Settings tab
SettingsTab:AddTextInput({
    Name = "Username",
    Placeholder = "Enter name...",
    Default = "",
    Callback = function(text)
        print("Username set to:", text)
    end
})

SettingsTab:AddDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Blue"},
    Default = "Dark",
    Callback = function(option)
        print("Theme:", option)
    end
})

SettingsTab:AddMultiDropdown({
    Name = "Features",
    Options = {"ESP", "Aimbot", "Speed", "Flight"},
    Default = {"ESP"},
    Callback = function(selected)
        print("Enabled:", table.concat(selected, ", "))
    end
})
```

---

## Advanced Usage

### Programmatic Control

```lua
-- Store component references
local myToggle = Tab:AddToggle({Name = "Feature", Default = false})
local mySlider = Tab:AddSlider({Name = "Value", Min = 0, Max = 100})
local myInput = Tab:AddTextInput({Name = "Text"})
local myDropdown = Tab:AddDropdown({Name = "Options", Options = {"A", "B"}})

-- Control them programmatically
myToggle:Set(true)
mySlider:Set(75)
myInput:Set("Hello")
myDropdown:Set("B")

-- Get values
local inputValue = myInput:Get()
print("Current input:", inputValue)

-- Refresh dropdown
myDropdown:Refresh({"A", "B", "C", "D"}, true)
```

### Notification Examples

```lua
-- Default notification
Window:Notify({
    Title = "Info",
    Content = "This is information",
    Type = "Default"
})

-- Success notification
Window:Notify({
    Title = "Success!",
    Content = "Action completed",
    Type = "Success"
})

-- Warning notification
Window:Notify({
    Title = "Warning",
    Content = "Be careful!",
    Type = "Warning"
})

-- Error notification
Window:Notify({
    Title = "Error",
    Content = "Something went wrong",
    Type = "Error"
})

-- Custom duration
Window:Notify({
    Title = "Quick Message",
    Content = "This disappears in 1 second",
    Duration = 1,
    Type = "Default"
})
```

---

## Device Support

The library automatically detects device type and adjusts:

- **PC/Desktop**: 900×650 window size
- **Mobile/Touch**: 450×600 window size
- **Touch Controls**: Full touch support for dragging and interactions

---

## Features

### Window Features
- ✅ Draggable by title bar
- ✅ Minimizable to title bar (with animated title)
- ✅ Closeable with animation
- ✅ Multiple tabs support
- ✅ Scrollable content areas
- ✅ Shadow and rounded corners

### Component Features
- ✅ Hover animations
- ✅ Ripple effects on buttons/tabs
- ✅ Smooth transitions
- ✅ Programmatic control
- ✅ Callback support
- ✅ Error handling with pcall

---

## Credits

- **Created by**: fluflu
- **Enhanced by**: Community contributions
- **License**: Free to use

---

## Tips

1. **Always store references** to components if you need to control them later
2. **Use dividers** to organize your UI into sections
3. **Test on both PC and mobile** to ensure compatibility
4. **Use appropriate notification types** for better UX
5. **Wrap callbacks in pcall** for error handling (already done internally)

---

## Troubleshooting

**Issue**: Components not appearing
- Make sure you're adding them to a tab, not the window
- Check that the tab is created before adding components

**Issue**: Callbacks not firing
- Verify your callback function syntax
- Check the console for errors

**Issue**: UI too small/large
- The library auto-detects device type
- Window size adjusts automatically for PC vs Mobile

---

## Support

For issues, suggestions, or contributions, please visit the repository or contact the creator.

**Enjoy using Xeric UI!** 🎉
