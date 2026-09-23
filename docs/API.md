# SmoothFluent API

## Core
- CreateWindow
- Notify
- SetTheme / RegisterCustomTheme / ListThemes
- GetTheme / GetVersion / Destroy
- SafeCall / Tween

## Window
- AddTab
- SelectTab(index or title)
- Show / Hide / Toggle / Destroy
- SetTitle / SetSubtitle
- SetSize / SetPosition / GetSize / GetPosition
- Dialog

## Components
Button, Label, Paragraph, Text, Toggle, Slider, Input, Dropdown, MultiDropdown, Colorpicker, Keybind, Divider, Space, Code, Image, Video, Audio, Group, Social, Discord.

## Option lifecycle
Options expose:
- GetValue()
- SetValue(value)
- OnChanged(callback)
- RemoveOnChanged(callback)
- Destroy()

## Optional modules
- Utilities/Signal.lua
- Utilities/Janitor.lua
- Managers/SaveManager.lua
- Managers/InterfaceManager.lua
- Managers/FloatingButtonManager.lua
- Managers/MediaManager.lua
- Managers/KeybindManager.lua
- Managers/PerformanceManager.lua
- Managers/CommandManager.lua
- Themes/Presets.lua
