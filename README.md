# SmoothFluent

A modern, independent Luau UI framework for Roblox with a Fluent-style API, modular architecture, a large preset theme system, and polished runtime controls.

## 0.3.0-beta

- Expanded the built-in theme catalog to 20+ presets.
- Added safer custom-theme registration with Dark-theme fallbacks.
- Added theme inspection and reset helpers.
- Fixed SafeCall and Tween helper scope issues.
- Improved theme refresh behavior across window descendants.
- Added a larger preset theme module for Rojo/module-based projects.

## Built-in themes

Dark, AMOLED, Ocean, Midnight, Rose, Emerald, Graphite, Violet, Cyber, NeonPink, Crimson, Sunset, Gold, Mint, Forest, Arctic, Lavender, Sapphire, Ruby, Plasma, Bubblegum, Coffee, Slate, and Aurora.

## Quick start

```lua
local Fluent=loadstring(game:HttpGet("https://raw.githubusercontent.com/taithedev/SmoothFluent/main/src/Fluent.lua"))()
local Window=Fluent:CreateWindow({Title="My UI",SubTitle="Powered by SmoothFluent",Size=UDim2.fromOffset(650,500)})
local Tab=Window:AddTab({Title="Main"})
local Section=Tab:AddSection("Controls")
Section:AddButton({Title="Hello",Callback=function() Fluent:Notify({Title="SmoothFluent",Content="Hello!",Type="Success"}) end})
Section:AddToggle("Enabled",{Title="Enabled",Default=true})
Section:AddMultiDropdown("Features",{Title="Features",Values={"A","B","C"}})
Fluent:SetTheme("Cyber")
```

## Theme API

```lua
Fluent:SetTheme("Violet")
Fluent:ListThemes()
Fluent:HasTheme("Aurora")
Fluent:ResetTheme()
Fluent:RegisterCustomTheme("MyTheme",{Accent=Color3.fromRGB(120,80,255)})
```

Custom themes inherit missing values from the Dark preset.

## Compatibility

The public API is intentionally close to Fluent-modded where practical, while the implementation is independent. The reference Fluent-modded project documents extra themes, multi-pack icon support, and quality-of-life changes. 

## Development

Rojo project files and optional modules live in `src/`. Use `example/Showcase.lua` to explore the API.

See `docs/API.md` for the current API reference.