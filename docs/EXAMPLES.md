# Examples

## Button

Section:AddButton({Title = "Click me", Callback = function() print("Clicked") end})

## Toggle

local Toggle = Section:AddToggle("Enabled", {Title = "Enabled", Default = true})
Toggle:OnChanged(function(value) print("Value:", value) end)

## Slider

Section:AddSlider("Volume", {Title = "Volume", Default = 50, Min = 0, Max = 100, Rounding = 0})

## Dropdown

Section:AddDropdown("Mode", {Title = "Mode", Values = {"Safe", "Fast", "Custom"}, Default = "Safe"})

## Multi dropdown

Section:AddMultiDropdown("Features", {Title = "Features", Values = {"ESP", "Notifications", "Music"}})

## Keybind

Section:AddKeybind("ToggleUI", {Title = "Toggle UI", Default = "RightShift", Callback = function() print("Toggle UI") end})

## Custom theme

Fluent:RegisterCustomTheme("OceanPurple", {Accent = Color3.fromRGB(150,90,255)})
Fluent:SetTheme("OceanPurple")

## Window controls

Window:SetTitle("New Title")
Window:SetSubtitle("New subtitle")
Window:SetSize(UDim2.fromOffset(700,550))
Window:SelectTab("Main")