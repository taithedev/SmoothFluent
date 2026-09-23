# Themes

SmoothFluent ships with a large dark-theme preset catalog.

## Presets

Dark, AMOLED, Ocean, Midnight, Rose, Emerald, Graphite, Violet, Cyber, NeonPink, Crimson, Sunset, Gold, Mint, Forest, Arctic, Lavender, Sapphire, Ruby, Plasma, Bubblegum, Coffee, Slate, Aurora.

## Switching

Fluent:SetTheme("Cyber")

## Listing

for _, name in ipairs(Fluent:ListThemes()) do print(name) end

## Custom themes

Fluent:RegisterCustomTheme("MyTheme", {Accent = Color3.fromRGB(255,90,190)})

Missing custom properties inherit from Dark.

## Reset

Fluent:ResetTheme()