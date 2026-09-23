# SmoothFluent Documentation

SmoothFluent is an independent Luau UI library inspired by the API style and feature goals of Fluent-modded.

Install:
local Fluent=loadstring(game:HttpGet("https://raw.githubusercontent.com/taithedev/SmoothFluent/main/src/Fluent.lua"))()

Window:
local Window=Fluent:CreateWindow({Title="My UI",SubTitle="SmoothFluent",Size=UDim2.fromOffset(620,470),Search=true})

Tab and section:
local Tab=Window:AddTab({Title="Main"})
local Section=Tab:AddSection("Controls")

Supported elements:
AddButton, AddParagraph, AddToggle, AddSlider, AddInput, AddDropdown,
AddColorpicker, AddKeybind, AddDivider, AddSpace, AddCode, AddImage,
AddVideo, AddAudio, AddGroup, AddSocial, AddDiscord and AddViewport.

Window methods:
Show, Hide, Toggle, SelectTab and Dialog.

Themes:
Fluent:SetTheme("AMOLED")
Fluent:RegisterCustomTheme("Custom",theme)

Notifications:
Fluent:Notify({Title="Done",Content="Completed",Type="Success",Duration=4})

Managers are separated under src/Managers so future releases can improve systems without changing the main API.

Every requested update should bump the semantic version and publish a new v* tag.
