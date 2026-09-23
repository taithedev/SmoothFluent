# Getting Started

## Raw source

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/taithedev/SmoothFluent/main/src/Fluent.lua"))()
local Window = Fluent:CreateWindow({Title = "My UI", SubTitle = "SmoothFluent", Size = UDim2.fromOffset(650,500)})
local Tab = Window:AddTab({Title = "Main"})
local Section = Tab:AddSection("Controls")
Section:AddButton({Title = "Test", Callback = function() print("SmoothFluent works") end})

## Rojo

rojo build default.project.json -o SmoothFluent.rbxm

## First theme

Fluent:SetTheme("Aurora")

Use Fluent:ListThemes() to inspect presets.