local Acrylic = {}

function Acrylic.CreateSurface(parent, transparency)
    local frame = Instance.new("Frame")
    frame.Name = "AcrylicSurface"
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BackgroundTransparency = transparency == nil and 0.18 or transparency
    frame.BorderSizePixel = 0
    frame.Size = UDim2.fromScale(1, 1)
    frame.Parent = parent

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 35
    gradient.Color = ColorSequence.new(Color3.fromRGB(18, 18, 24), Color3.fromRGB(30, 26, 42))
    gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0.32)})
    gradient.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 110)
    stroke.Transparency = 0.55
    stroke.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame
    return frame
end

function Acrylic.IsAvailable()
    return workspace.CurrentCamera ~= nil
end

return Acrylic
