# SmoothFluent

A modern, independent Luau UI framework for Roblox with a Fluent-style API, but a separate implementation and architecture.

## 0.2.0-beta

- Better option lifecycle APIs with OnChanged and Destroy.
- Single and multi-selection dropdowns.
- Label and Text components.
- Window runtime controls.
- Modular managers and utilities.
- Extra theme presets.
- Expanded documentation and showcase examples.
- Release workflow for versioned tags.

## Quick start

local Fluent=loadstring(game:HttpGet("https://raw.githubusercontent.com/taithedev/SmoothFluent/main/src/Fluent.lua"))()
local Window=Fluent:CreateWindow({Title="My UI",SubTitle="Powered by SmoothFluent",Size=UDim2.fromOffset(650,500)})
local Tab=Window:AddTab({Title="Main"})
local Section=Tab:AddSection("Controls")
Section:AddButton({Title="Hello",Callback=function() Fluent:Notify({Title="SmoothFluent",Content="Hello!",Type="Success"}) end})
Section:AddToggle("Enabled",{Title="Enabled",Default=true})
Section:AddMultiDropdown("Features",{Title="Features",Values={"A","B","C"}})

## Compatibility

The public API is intentionally close to Fluent-modded where practical, while the implementation is independent.

## Development

Rojo project files and optional modules live in src/. Use example/Showcase.lua to explore the API.

See docs/API.md for the current API reference.
