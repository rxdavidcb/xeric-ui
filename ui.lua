--[[
- Created by fluflu
- Enhanced version
- Used for Xeric Hub
- This UI is free to use for everyone
- 
- Improvements:
- + Decorative line under frame that moves with UI
- + Longer, more visible bar when minimized
- + Enhanced animations and visual effects
- + Better code structure
]]--

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

local function Ripple(obj, x, y)
    local circle = Instance.new("Frame")
    circle.Name = "Ripple"
    circle.Parent = obj
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.5
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0, x, 0, y)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.ZIndex = 10
  
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
  
    local size = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 2
    CreateTween(circle, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() circle:Destroy() end)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
  
    local function AnimateTitle(shouldAnimate)
        if shouldAnimate then
            if titleAnimation then titleAnimation:Disconnect() end
            local title = MainFrame.TopBar.Title
            titleAnimation = RunService.Heartbeat:Connect(function()
                local t = (tick() % 1.5) / 1.5 * 2
                local color = t <= 1 and Theme.TextDark:Lerp(Theme.Primary, t) or Theme.Primary:Lerp(Theme.TextDark, t - 1)
                title.TextColor3 = color
            end)
        else
            if titleAnimation then titleAnimation:Disconnect() titleAnimation = nil end
            MainFrame.TopBar.Title.TextColor3 = Theme.Text
        end
    end
  
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
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = ORIGINAL_SIZE
    MainFrame.ClipsDescendants = false
  
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
  
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = MainFrame
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
  
    DecorativeLine = Instance.new("Frame")
    DecorativeLine.Name = "DecorativeLine"
    DecorativeLine.Parent = MainFrame
    DecorativeLine.BackgroundColor3 = Theme.Primary
    DecorativeLine.BorderSizePixel = 0
    DecorativeLine.Position = UDim2.new(0.5, -100, 1, 8)
    DecorativeLine.Size = UDim2.new(0, 200, 0, 2)
    DecorativeLine.AnchorPoint = Vector2.new(0.5, 0)
    DecorativeLine.ZIndex = 5
  
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(0, 1)
    lineCorner.Parent = DecorativeLine
  
    local lineGlow = Instance.new("Frame")
    lineGlow.Name = "Glow"
    lineGlow.Parent = DecorativeLine
    lineGlow.BackgroundColor3 = Theme.Primary
    lineGlow.BackgroundTransparency = 0.7
    lineGlow.BorderSizePixel = 0
    lineGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    lineGlow.Size = UDim2.new(1, 6, 1, 6)
    lineGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    lineGlow.ZIndex = 4
  
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 2)
    glowCorner.Parent = lineGlow
  
    spawn(function()
        while task.wait(1) do
            CreateTween(lineGlow, {BackgroundTransparency = 0.3}, 1, Enum.EasingStyle.Sine)
            task.wait(1)
            CreateTween(lineGlow, {BackgroundTransparency = 0.7}, 1, Enum.EasingStyle.Sine)
        end
    end)
  
    TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 150, 1, -70)
  
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = TabContainer
  
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = TabContainer
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 8)
  
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Parent = TabContainer
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
  
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "TabIndicator"
    tabIndicator.Parent = TabContainer
    tabIndicator.BackgroundColor3 = Theme.Primary
    tabIndicator.BorderSizePixel = 0
    tabIndicator.AnchorPoint = Vector2.new(1, 0)
    tabIndicator.Position = UDim2.new(1, -3, 0, 10)
    tabIndicator.Size = UDim2.new(0, 3, 0, 40)
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 1.5)
    indicatorCorner.Parent = tabIndicator
  
    ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Theme.Secondary
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 170, 0, 60)
    ContentFrame.Size = UDim2.new(1, -180, 1, -70)
  
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = ContentFrame
  
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = MainFrame
    topBar.BackgroundColor3 = Theme.Secondary
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 50)
  
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
  
    local topCover = Instance.new("Frame")
    topCover.Parent = topBar
    topCover.BackgroundColor3 = Theme.Secondary
    topCover.BorderSizePixel = 0
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.Size = UDim2.new(1, 0, 0, 10)
  
    local title = Instance.new("TextLabel")
    title.Name = "Title"
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
    minimizeBtn.Name = "MinimizeButton"
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
  
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
  
    minimizeBtn.MouseButton1Click:Connect(function()
        local targetSize = isMinimized and ORIGINAL_SIZE or MINIMIZED_SIZE
        local oldHalfX, targetHalfX = MainFrame.Size.X.Offset / 2, targetSize.X.Offset / 2
        local oldHalfY, targetHalfY = MainFrame.Size.Y.Offset / 2, targetSize.Y.Offset / 2
        local deltaX, deltaY = oldHalfX - targetHalfX, oldHalfY - targetHalfY
        local currentPos = MainFrame.Position
        local newPos = UDim2.new(currentPos.X.Scale, currentPos.X.Offset + deltaX, currentPos.Y.Scale, currentPos.Y.Offset + deltaY)
        
        if not isMinimized then
            ContentFrame.Visible = false
            TabContainer.Visible = false
            CreateTween(MainFrame, {Size = MINIMIZED_SIZE, Position = newPos}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            CreateTween(DecorativeLine, {Position = UDim2.new(0.5, -MINIMIZED_BAR_WIDTH/2, 1, 8), Size = UDim2.new(0, MINIMIZED_BAR_WIDTH, 0, 4)}, 0.3)
            minimizeBtn.Text = "⬜"
            isMinimized = true
            AnimateTitle(true)
        else
            CreateTween(MainFrame, {Size = ORIGINAL_SIZE, Position = newPos}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            CreateTween(DecorativeLine, {Position = UDim2.new(0.5, -100, 1, 8), Size = UDim2.new(0, 200, 0, 2)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.wait(0.3)
            ContentFrame.Visible = true
            TabContainer.Visible = true
            minimizeBtn.Text = "_"
            isMinimized = false
            AnimateTitle(true)
        end
    end)
  
    minimizeBtn.MouseEnter:Connect(function() CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2) end)
    minimizeBtn.MouseLeave:Connect(function() CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2) end)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
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
  
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
  
    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        CreateTween(DecorativeLine, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
  
    closeBtn.MouseEnter:Connect(function() CreateTween(closeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2) end)
    closeBtn.MouseLeave:Connect(function() CreateTween(closeBtn, {BackgroundColor3 = Theme.Primary}, 0.2) end)
  
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "Notifications"
    NotificationHolder.Parent = ScreenGui
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -320, 1, -420)
    NotificationHolder.Size = UDim2.new(0, 300, 0, 400)
  
    local notifList = Instance.new("UIListLayout")
    notifList.Parent = NotificationHolder
    notifList.SortOrder = Enum.SortOrder.LayoutOrder
    notifList.Padding = UDim.new(0, 10)
    notifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
  
    local dragging, dragInput, mousePos, framePos = false
  
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
  
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
  
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
  
    local TabMethods = {}
  
    function TabMethods:CreateSection(config)
        config = config or {}
        local sectionName = config.Name or "Section"
      
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = sectionName
        sectionFrame.Parent = ContentFrame
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Size = UDim2.new(1, 0, 0, 0)
        sectionFrame.Visible = false
      
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Parent = sectionFrame
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, 0, 0, 30)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = sectionName
        sectionTitle.TextColor3 = Theme.Text
        sectionTitle.TextSize = 16
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
      
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.Parent = sectionTitle
        sectionPadding.PaddingLeft = UDim.new(0, 15)
      
        local sectionContent = Instance.new("Frame")
        sectionContent.Name = "Content"
        sectionContent.Parent = sectionFrame
        sectionContent.BackgroundTransparency = 1
        sectionContent.Position = UDim2.new(0, 0, 0, 30)
        sectionContent.Size = UDim2.new(1, 0, 1, -30)
      
        local contentList = Instance.new("UIListLayout")
        contentList.Parent = sectionContent
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 10)
      
        local contentPadding = Instance.new("UIPadding")
        contentPadding.Parent = sectionContent
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 15)
        contentPadding.PaddingRight = UDim.new(0, 15)
        contentPadding.PaddingBottom = UDim.new(0, 15)
      
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sectionFrame.Size = UDim2.new(1, 0, 0, contentList.AbsoluteContentSize.Y + 40)
        end)
      
        return {
            AddLabel = function(labelConfig)
                local label = Instance.new("TextLabel")
                label.Parent = sectionContent
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 20)
                label.Font = Enum.Font.Gotham
                label.Text = (labelConfig or {}).Text or "Label"
                label.TextColor3 = Theme.TextDark
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                return label
            end,
            
            AddButton = function(buttonConfig)
                buttonConfig = buttonConfig or {}
                local button = Instance.new("TextButton")
                button.Parent = sectionContent
                button.BackgroundColor3 = Theme.Tertiary
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, 0, 0, 35)
                button.Font = Enum.Font.GothamSemibold
                button.Text = buttonConfig.Name or "Button"
                button.TextColor3 = Theme.Text
                button.TextSize = 14
                button.AutoButtonColor = false
              
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = button
              
                button.MouseButton1Click:Connect(function()
                    Ripple(button, button.AbsoluteSize.X / 2, button.AbsoluteSize.Y / 2)
                    if buttonConfig.Callback then buttonConfig.Callback() end
                end)
              
                button.MouseEnter:Connect(function() CreateTween(button, {BackgroundColor3 = Theme.PrimaryDark}, 0.2) end)
                button.MouseLeave:Connect(function() CreateTween(button, {BackgroundColor3 = Theme.Tertiary}, 0.2) end)
                return button
            end,
            
            AddToggle = function(toggleConfig)
                toggleConfig = toggleConfig or {}
                local default = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end
              
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Parent = sectionContent
                toggleFrame.BackgroundColor3 = Theme.Tertiary
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
              
                Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
              
                local label = Instance.new("TextLabel")
                label.Parent = toggleFrame
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 15, 0, 0)
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = toggleConfig.Name or "Toggle"
                label.TextColor3 = Theme.Text
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
              
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Parent = toggleFrame
                toggleBtn.BackgroundColor3 = default and Theme.Primary or Theme.Border
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Position = UDim2.new(1, -40, 0.5, -10)
                toggleBtn.Size = UDim2.new(0, 35, 0, 20)
                toggleBtn.Text = ""
                toggleBtn.AutoButtonColor = false
              
                Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
              
                local circle = Instance.new("Frame")
                circle.Parent = toggleBtn
                circle.BackgroundColor3 = Theme.Text
                circle.BorderSizePixel = 0
                circle.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                circle.Size = UDim2.new(0, 16, 0, 16)
                circle.AnchorPoint = Vector2.new(0, 0.5)
              
                Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 8)
              
                local toggled = default
              
                toggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    CreateTween(toggleBtn, {BackgroundColor3 = toggled and Theme.Primary or Theme.Border}, 0.2)
                    CreateTween(circle, {Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                    callback(toggled)
                end)
              
                return {
                    Set = function(state)
                        toggled = state
                        CreateTween(toggleBtn, {BackgroundColor3 = toggled and Theme.Primary or Theme.Border}, 0.2)
                        CreateTween(circle, {Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
                        callback(toggled)
                    end,
                    Get = function() return toggled end
                }
            end,
            
            AddSlider = function(sliderConfig)
                sliderConfig = sliderConfig or {}
                local min, max = sliderConfig.Min or 0, sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local increment = sliderConfig.Increment or 1
                local callback = sliderConfig.Callback or function() end
              
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Parent = sectionContent
                sliderFrame.BackgroundColor3 = Theme.Tertiary
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
              
                local label = Instance.new("TextLabel")
                label.Parent = sliderFrame
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 15, 0, 5)
                label.Size = UDim2.new(1, -60, 0, 20)
                label.Font = Enum.Font.GothamSemibold
                label.Text = sliderConfig.Name or "Slider"
                label.TextColor3 = Theme.Text
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
              
                local bar = Instance.new("Frame")
                bar.Parent = sliderFrame
                bar.BackgroundColor3 = Theme.Border
                bar.BorderSizePixel = 0
                bar.Position = UDim2.new(0, 15, 0, 30)
                bar.Size = UDim2.new(1, -30, 0, 6)
                Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
              
                local fill = Instance.new("Frame")
                fill.Parent = bar
                fill.BackgroundColor3 = Theme.Primary
                fill.BorderSizePixel = 0
                fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                fill.ZIndex = 2
                Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
              
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = sliderFrame
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(1, -45, 0, 5)
                valueLabel.Size = UDim2.new(0, 40, 0, 20)
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Theme.TextDark
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
              
                local dragging = false
              
                bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
              
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
              
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * percent / increment) * increment
                        fill.Size = UDim2.new(percent, 0, 1, 0)
                        valueLabel.Text = tostring(value)
                        callback(value)
                    end
                end)
              
                return {
                    Set = function(value)
                        local clampedValue = math.max(min, math.min(max, value))
                        local percent = (clampedValue - min) / (max - min)
                        fill.Size = UDim2.new(percent, 0, 1, 0)
                        valueLabel.Text = tostring(clampedValue)
                        callback(clampedValue)
                    end
                }
            end,
            
            AddDropdown = function(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                local options = dropdownConfig.Options or {}
                local default = dropdownConfig.Default or ""
                local callback = dropdownConfig.Callback or function() end
                local multi = dropdownConfig.MultipleOptions or false
              
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Parent = sectionContent
                dropdownFrame.BackgroundColor3 = Theme.Tertiary
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)
              
                local label = Instance.new("TextLabel")
                label.Parent = dropdownFrame
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 15, 0, 0)
                label.Size = UDim2.new(1, -60, 0.5, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = dropdownConfig.Name or "Dropdown"
                label.TextColor3 = Theme.Text
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
              
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Parent = dropdownFrame
                dropdownBtn.BackgroundColor3 = Theme.Border
                dropdownBtn.BorderSizePixel = 0
                dropdownBtn.Position = UDim2.new(0, 15, 0.5, 0)
                dropdownBtn.Size = UDim2.new(1, -30, 0.5, 0)
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.Text = default ~= "" and default or "Select..."
                dropdownBtn.TextColor3 = Theme.TextDark
                dropdownBtn.TextSize = 12
                dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
                dropdownBtn.AutoButtonColor = false
              
                local arrow = Instance.new("TextLabel")
                arrow.Parent = dropdownBtn
                arrow.BackgroundTransparency = 1
                arrow.Position = UDim2.new(1, -20, 0.5, -8)
                arrow.Size = UDim2.new(0, 16, 0, 16)
                arrow.Font = Enum.Font.GothamBold
                arrow.Text = "▼"
                arrow.TextColor3 = Theme.TextDark
                arrow.TextSize = 12
                arrow.TextXAlignment = Enum.TextXAlignment.Center
              
                local dropdownList = Instance.new("Frame")
                dropdownList.Parent = dropdownFrame
                dropdownList.BackgroundColor3 = Theme.Secondary
                dropdownList.BorderSizePixel = 0
                dropdownList.Position = UDim2.new(0, 0, 1, 0)
                dropdownList.Size = UDim2.new(1, 0, 0, 0)
                dropdownList.Visible = false
                dropdownList.ClipsDescendants = true
                Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 8)
              
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropdownList
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
              
                local selected = multi and {} or default
              
                local function updateText()
                    dropdownBtn.Text = multi and (#selected > 0 and table.concat(selected, ", ") or "Select...") or (selected or "Select...")
                end
              
                local function createOption(optionName)
                    local option = Instance.new("TextButton")
                    option.Parent = dropdownList
                    option.BackgroundColor3 = Theme.Secondary
                    option.BorderSizePixel = 0
                    option.Size = UDim2.new(1, 0, 0, 30)
                    option.Font = Enum.Font.Gotham
                    option.Text = optionName
                    option.TextColor3 = Theme.TextDark
                    option.TextSize = 12
                    option.AutoButtonColor = false
                    Instance.new("UICorner", option).CornerRadius = UDim.new(0, 6)
                  
                    option.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(selected, optionName)
                            if idx then
                                table.remove(selected, idx)
                                option.BackgroundColor3 = Theme.Secondary
                            else
                                table.insert(selected, optionName)
                                option.BackgroundColor3 = Theme.Primary
                            end
                        else
                            selected = optionName
                            for _, opt in ipairs(dropdownList:GetChildren()) do
                                if opt:IsA("TextButton") then opt.BackgroundColor3 = Theme.Secondary end
                            end
                            option.BackgroundColor3 = Theme.Primary
                            dropdownList.Visible = false
                        end
                        updateText()
                        callback(selected)
                    end)
                  
                    option.MouseEnter:Connect(function()
                        if not (multi and table.find(selected, optionName)) then
                            CreateTween(option, {BackgroundColor3 = Theme.Tertiary}, 0.1)
                        end
                    end)
                  
                    option.MouseLeave:Connect(function()
                        option.BackgroundColor3 = (multi and table.find(selected, optionName)) and Theme.Primary or Theme.Secondary
                    end)
                  
                    if multi and table.find(selected, optionName) then option.BackgroundColor3 = Theme.Primary end
                end
              
                for _, option in ipairs(options) do createOption(option) end
              
                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y)
                end)
              
                dropdownBtn.MouseButton1Click:Connect(function()
                    dropdownList.Visible = not dropdownList.Visible
                    CreateTween(dropdownList, {Size = dropdownList.Visible and UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)}, 0.2)
                end)
              
                dropdownBtn.MouseEnter:Connect(function() CreateTween(dropdownBtn, {BackgroundColor3 = Theme.Tertiary}, 0.1) end)
                dropdownBtn.MouseLeave:Connect(function() CreateTween(dropdownBtn, {BackgroundColor3 = Theme.Border}, 0.1) end)
              
                return {
                    Refresh = function(newOptions, keepDefault)
                        for _, child in ipairs(dropdownList:GetChildren()) do
                            if child:IsA("TextButton") then child:Destroy() end
                        end
                        selected = multi and {} or (keepDefault and default or "")
                        for _, option in ipairs(newOptions) do createOption(option) end
                        updateText()
                        callback(selected)
                    end
                }
            end,
            
            AddMultiDropdown = function(multiDropdownConfig)
                multiDropdownConfig = multiDropdownConfig or {}
                multiDropdownConfig.MultipleOptions = true
                return TabMethods:CreateSection(config).AddDropdown(multiDropdownConfig)
            end
        }
    end
  
    function Library:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
      
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.TextDark
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)
      
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = false
      
        tabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = Theme.TextDark end
            end
            tabButton.TextColor3 = Theme.Primary
            
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("Frame") and child.Name:find("Content") then child.Visible = false end
            end
            tabContent.Visible = true
            
            CreateTween(tabIndicator, {
                Position = UDim2.new(1, -3, 0, tabButton.AbsolutePosition.Y - TabContainer.AbsolutePosition.Y),
                Size = UDim2.new(0, 3, 0, tabButton.AbsoluteSize.Y)
            }, 0.2)
            currentTab = tabButton
        end)
      
        if not currentTab then
            currentTab = tabButton
            tabButton.TextColor3 = Theme.Primary
            tabContent.Visible = true
            CreateTween(tabIndicator, {
                Position = UDim2.new(1, -3, 0, tabButton.AbsolutePosition.Y - TabContainer.AbsolutePosition.Y),
                Size = UDim2.new(0, 3, 0, tabButton.AbsoluteSize.Y)
            }, 0.2)
        end
      
        tabButton.MouseEnter:Connect(function()
            if tabButton.TextColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Theme.Border}, 0.1)
            end
        end)
      
        tabButton.MouseLeave:Connect(function()
            if tabButton.TextColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Theme.Tertiary}, 0.1)
            end
        end)
      
        return TabMethods
    end
  
    function Library:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "Content"
        local type = config.Type or "Info"
        local duration = config.Duration or 3
      
        local notif = Instance.new("Frame")
        notif.Parent = NotificationHolder
        notif.BackgroundColor3 = type == "Success" and Theme.Success or type == "Error" and Color3.fromRGB(255, 85, 85) or Theme.Primary
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(1, 0, 0, 80)
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
      
        local notifTitle = Instance.new("TextLabel")
        notifTitle.Parent = notif
        notifTitle.BackgroundTransparency = 1
        notifTitle.Position = UDim2.new(0, 15, 0, 10)
        notifTitle.Size = UDim2.new(1, -30, 0, 20)
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.Text = title
        notifTitle.TextColor3 = Theme.Text
        notifTitle.TextSize = 14
        notifTitle.TextXAlignment = Enum.TextXAlignment.Left
      
        local notifContent = Instance.new("TextLabel")
        notifContent.Parent = notif
        notifContent.BackgroundTransparency = 1
        notifContent.Position = UDim2.new(0, 15, 0, 35)
        notifContent.Size = UDim2.new(1, -30, 0, 35)
        notifContent.Font = Enum.Font.Gotham
        notifContent.Text = content
        notifContent.TextColor3 = Theme.Text
        notifContent.TextSize = 12
        notifContent.TextXAlignment = Enum.TextXAlignment.Left
        notifContent.TextWrapped = true
      
        CreateTween(notif, {Size = UDim2.new(1, 0, 1, 80)}, 0.3)
      
        task.delay(duration, function()
            CreateTween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3).Completed:Connect(function()
                notif:Destroy()
            end)
        end)
    end
  
    AnimateTitle(true)
    return Library
end

return Library
