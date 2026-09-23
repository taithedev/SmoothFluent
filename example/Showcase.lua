local Fluent=loadstring(game:HttpGet("https://raw.githubusercontent.com/taithedev/SmoothFluent/main/src/Fluent.lua"))()

local Window=Fluent:CreateWindow({
 Title="SmoothFluent 0.2",
 SubTitle="Modern Luau UI framework",
 Size=UDim2.fromOffset(760,540),
 Search=true,
 MinimizeKey=Enum.KeyCode.RightControl
})

local Main=Window:AddTab({Title="Showcase"})
local Controls=Main:AddSection("Controls")

local Toggle=Controls:AddToggle("Enabled",{Title="Enable system",Default=true,Callback=function(v)
 Fluent:Notify({Title="Toggle",Content=v and "Enabled" or "Disabled",Type=v and "Success" or "Warning"})
end})
Toggle:OnChanged(function(v) print("Changed:",v) end)

Controls:AddSlider("Intensity",{Title="Intensity",Min=0,Max=100,Default=50,Callback=function(v) print("Intensity:",v) end})
Controls:AddMultiDropdown("Features",{Title="Features",Values={"Particles","Blur","Sounds","Animations"},Default={Particles=true}})
Controls:AddInput("Name",{Title="Name",Placeholder="Type something..."})
Controls:AddColorpicker("Accent",{Title="Accent color",Default=Color3.fromRGB(124,92,255)})
Controls:AddKeybind("Open",{Title="Open/close",Default="RightControl",Mode="Toggle",Callback=function() Window:Toggle() end})

local More=Main:AddSection("Utilities")
More:AddLabel({Text="SmoothFluent is built around composable APIs and safe callbacks."})
More:AddButton({Title="Success notification",Callback=function()
 Fluent:Notify({Title="SmoothFluent",Content="Everything is connected.",Type="Success"})
end})

local Settings=Window:AddTab({Title="Settings"})
Settings:AddSection("Themes"):AddDropdown("Theme",{Title="Theme",Values=Fluent:ListThemes(),Default="Dark",Callback=function(v) Fluent:SetTheme(v) end})
Settings:AddSection("Window"):AddButton({Title="Hide window",Callback=function() Window:Hide() end})
