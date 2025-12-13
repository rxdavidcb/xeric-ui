--[[
- Created by fluflu
- Enhanced version
- Used for Xeric Hub
- This UI is free to use for everyone
]]--

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Library = {}
local ScreenGui, MainFrame, ContentFrame, TabContainer, NotificationHolder, DecorativeLine
local isMinimized, titleAnimation, currentTab = false, nil, nil

local ORIGINAL_SIZE = UDim2.new(0, 700, 0, 500)
local MINIMIZED_SIZE = UDim2.new(0, 350, 0, 50)
local MINIMIZED_BAR_WIDTH = 400

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(20, 20, 20),
    Tertiary = Color3.fromRGB(25, 25, 25),
    Primary = Color3.fromRGB(255, 0, 0),
    PrimaryDark = Color3.fromRGB(180, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 255, 0),
    Border = Color3.fromRGB(40, 40, 40)
}

local function CreateTween(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function UpdateDecorativeLine()
    if DecorativeLine then
        DecorativeLine.AnchorPoint = Vector2.new(0.5, 0)
        DecorativeLine.Position = UDim2.new(0.5, 0, 1, 8)
    end
end

local function ApplyMobileScaling()
    local v = Camera.ViewportSize
    local scale = math.clamp(v.X / 1920, 0.75, 1)
    ORIGINAL_SIZE = UDim2.new(0, 700 * scale, 0, 500 * scale)
    MINIMIZED_SIZE = UDim2.new(0, ORIGINAL_SIZE.X.Offset * 0.5, 0, 50)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"

    ApplyMobileScaling()

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -ORIGINAL_SIZE.X.Offset / 2, 0.5, -ORIGINAL_SIZE.Y.Offset / 2)
    MainFrame.Size = ORIGINAL_SIZE
    MainFrame.ClipsDescendants = false

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame

    DecorativeLine = Instance.new("Frame")
    DecorativeLine.Parent = MainFrame
    DecorativeLine.BackgroundColor3 = Theme.Primary
    DecorativeLine.BorderSizePixel = 0
    DecorativeLine.Size = UDim2.new(0, 200, 0, 2)
    DecorativeLine.ZIndex = 5
    Instance.new("UICorner", DecorativeLine).CornerRadius = UDim.new(0, 1)

    UpdateDecorativeLine()
    MainFrame:GetPropertyChangedSignal("Size"):Connect(UpdateDecorativeLine)
    MainFrame:GetPropertyChangedSignal("Position"):Connect(UpdateDecorativeLine)

    local topBar = Instance.new("Frame")
    topBar.Parent = MainFrame
    topBar.BackgroundColor3 = Theme.Secondary
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 50)
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Parent = topBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 20, 0, 0)
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = windowName
    title.TextColor3 = Theme.Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Parent = topBar
    minimizeBtn.BackgroundColor3 = Theme.Tertiary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 14
    minimizeBtn.AutoButtonColor = false
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = topBar
    closeBtn.BackgroundColor3 = Theme.Primary
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    minimizeBtn.MouseButton1Click:Connect(function()
        local targetSize = isMinimized and ORIGINAL_SIZE or MINIMIZED_SIZE
        CreateTween(MainFrame, {Size = targetSize}, 0.35)
        DecorativeLine.Visible = isMinimized
        ContentFrame.Visible = isMinimized
        TabContainer.Visible = isMinimized
        minimizeBtn.Text = isMinimized and "_" or "⬜"
        isMinimized = not isMinimized
    end)

    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local dragging = false
    local dragStart, startPos

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return Library
end

return Library
