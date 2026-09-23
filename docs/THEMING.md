# Fluent-style Theming

SmoothFluent uses a shared theme table for the entire renderer.

A theme can define:

- Accent
- Background
- Surface
- Surface2
- Border
- Text
- SubText
- Hover
- Success
- Warning
- Error
- Info

Use:

Fluent:SetTheme("Dark")

or:

Fluent:RegisterCustomTheme("MyTheme", {
    Accent = Color3.fromRGB(168, 85, 247),
    Background = Color3.fromRGB(8, 8, 10),
})

The window and its descendants refresh when the theme changes.
