# Fluent-style UI

SmoothFluent 0.5 focuses on matching the Fluent-modded developer experience without copying its implementation.

## Window

Create a window with:

- Title and subtitle
- Optional search
- Adjustable size and position
- Sidebar tab navigation
- Minimize button
- Close button
- Dragging
- Theme refresh
- Acrylic-style translucent surface
- Accent selection indicator

Example:

local Fluent = require(path.To.Fluent)

local Window = Fluent:CreateWindow({
    Title = "My Script",
    SubTitle = "SmoothFluent",
    TabWidth = 155,
    Size = UDim2.fromOffset(680, 500),
    Acrylic = true,
    Search = true,
    MinimizeKey = Enum.KeyCode.RightControl,
})
