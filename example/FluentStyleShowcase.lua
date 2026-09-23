local Fluent = require(script.Parent.Parent.src.Fluent)

local Window = Fluent:CreateWindow({
    Title = "SmoothFluent Showcase",
    SubTitle = "Fluent-style UI",
    Size = UDim2.fromOffset(680, 500),
    TabWidth = 155,
    Acrylic = true,
    Search = true,
    MinimizeKey = Enum.KeyCode.RightControl,
})

local Main = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://7733960981",
})

local Settings = Window:AddTab({
    Title = "Settings",
    Icon = "rbxassetid://7734052335",
})

local Components = Window:AddTab({
    Title = "Components",
    Icon = "rbxassetid://10723415903",
})

local mainSection = Main:AddSection("Welcome")

mainSection:AddParagraph({
    Title = "SmoothFluent 0.5",
    Content = "A Fluent-style Roblox UI library with a polished dark renderer, animated controls, themes, search, dialogs, and configuration managers.",
})

mainSection:AddButton({
    Title = "Notification",
    Description = "Show a SmoothFluent notification.",
    Callback = function()
        Fluent:Notify({
            Title = "SmoothFluent",
            Content = "Everything is working.",
            Type = "Success",
            Duration = 3,
        })
    end,
})

mainSection:AddToggle("DemoToggle", {
    Title = "Demo Toggle",
    Description = "Test the animated Fluent-style switch.",
    Default = true,
})

mainSection:AddSlider("DemoSlider", {
    Title = "Demo Slider",
    Description = "Drag the accent rail.",
    Min = 0,
    Max = 100,
    Default = 50,
})

local settingsSection = Settings:AddSection("Interface")

settingsSection:AddDropdown("Theme", {
    Title = "Theme",
    Values = Fluent:ListThemes(),
    Default = "Dark",
    Callback = function(value)
        Fluent:SetTheme(value)
    end,
})

settingsSection:AddKeybind("MenuKey", {
    Title = "Toggle Window",
    Default = "RightControl",
    Mode = "Toggle",
    Callback = function()
        Window:Toggle()
    end,
})

local componentsSection = Components:AddSection("Elements")

componentsSection:AddInput("DemoInput", {
    Title = "Input",
    Placeholder = "Type something...",
})

componentsSection:AddMultiDropdown("DemoMulti", {
    Title = "Multi Dropdown",
    Values = {"One", "Two", "Three", "Four"},
})

componentsSection:AddColorpicker("DemoColor", {
    Title = "Color",
    Default = Color3.fromRGB(139, 92, 246),
})

componentsSection:AddCode({
    Title = "Code",
    Code = 'print("SmoothFluent")',
})

return Window
