--[[
- Created by fluflu
- used for Xeric Hub
- this UI is free to use for everyone else
]]--
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Library = {}
local ScreenGui
local MainFrame
local ContentFrame
local TabContainer
local NotificationHolder
local isMinimized = false
local titleAnimation
local currentTab = nil
local ORIGINAL_SIZE = UDim2.new(0, 700, 0, 500)
local MINIMIZED_SIZE = UDim2.new(0, 250, 0, 50)
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
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end
local function Ripple(object, x, y)
    local circle = Instance.new("Frame")
    circle.Name = "Ripple"
    circle.Parent = object
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.5
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0, x, 0, y)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.ZIndex = 10
  
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
  
    local size = math.max(object.AbsoluteSize.X, object.AbsoluteSize.Y) * 2
  
    CreateTween(circle, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
  
    task.delay(0.5, function()
        circle:Destroy()
    end)
end
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
  
    local function AnimateTitle(shouldAnimate)
        if shouldAnimate then
            if titleAnimation then titleAnimation:Disconnect() end
          
            local title = MainFrame.TopBar.Title
            local loop = true
          
            titleAnimation = RunService.Heartbeat:Connect(function(dt)
                if not loop then return end
              
                local color1 = Theme.TextDark
                local color2 = Theme.Primary
                local cycleTime = 1.5
              
                local t = (tick() % cycleTime) / cycleTime
              
                local progress = t * 2
              
                local tweenColor
                if progress <= 1 then
                  
                    tweenColor = color1:Lerp(color2, progress)
                else
                  
                    tweenColor = color2:Lerp(color1, progress - 1)
                end
              
                title.TextColor3 = tweenColor
            end)
          
        else
            if titleAnimation then
                titleAnimation:Disconnect()
                titleAnimation = nil
            end
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
    MainFrame.Position = UDim2.new(0.5, -ORIGINAL_SIZE.X.Offset / 2, 0.5, -ORIGINAL_SIZE.Y.Offset / 2)
    MainFrame.Size = ORIGINAL_SIZE
    MainFrame.ClipsDescendants = true
  
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
        local oldHalfX = MainFrame.Size.X.Offset / 2
        local targetHalfX = targetSize.X.Offset / 2
        local deltaX = oldHalfX - targetHalfX
        local oldHalfY = MainFrame.Size.Y.Offset / 2
        local targetHalfY = targetSize.Y.Offset / 2
        local deltaY = oldHalfY - targetHalfY
        local currentPos = MainFrame.Position
        local newPos = UDim2.new(currentPos.X.Scale, currentPos.X.Offset + deltaX, currentPos.Y.Scale, currentPos.Y.Offset + deltaY)
        if not isMinimized then
            ContentFrame.Visible = false
            TabContainer.Visible = false
            local tween = CreateTween(MainFrame, {Size = MINIMIZED_SIZE, Position = newPos}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            minimizeBtn.Text = "⬜"
            isMinimized = true
            AnimateTitle(true)
            local minimizedBar = Instance.new("Frame")
            minimizedBar.Name = "MinimizedBar"
            minimizedBar.Parent = MainFrame
            minimizedBar.BackgroundColor3 = Theme.Primary
            minimizedBar.BorderSizePixel = 0
            minimizedBar.Position = UDim2.new(0, -75, 1, 0)
            minimizedBar.Size = UDim2.new(0, 200, 0, 3)
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 1.5)
            barCorner.Parent = minimizedBar
        else
            local minimizedBar = MainFrame:FindFirstChild("MinimizedBar")
            if minimizedBar then minimizedBar:Destroy() end
            local tween = CreateTween(MainFrame, {Size = ORIGINAL_SIZE, Position = newPos}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tween.Completed:Connect(function()
                ContentFrame.Visible = true
                TabContainer.Visible = true
            end)
            minimizeBtn.Text = "_"
            isMinimized = false
            AnimateTitle(true)
        end
    end)
  
    minimizeBtn.MouseEnter:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
    end)
  
    minimizeBtn.MouseLeave:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
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
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
  
    closeBtn.MouseEnter:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
    end)
  
    closeBtn.MouseLeave:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
    end)
  
  
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = ContentFrame
  
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
  
    local dragging = false
    local dragInput, mousePos, framePos
  
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
          
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
  
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
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
      
        sectionFrame.ChildAdded:Connect(function()
            sectionFrame.Size = UDim2.new(1, 0, 0, sectionContent.AbsoluteSize.Y + 30)
        end)
      
        return {
            AddLabel = function(labelConfig)
                labelConfig = labelConfig or {}
                local labelText = labelConfig.Text or "Label"
              
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = sectionContent
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 20)
                label.Font = Enum.Font.Gotham
                label.Text = labelText
                label.TextColor3 = Theme.TextDark
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center
              
                return label
            end,
            AddButton = function(buttonConfig)
                buttonConfig = buttonConfig or {}
                local buttonName = buttonConfig.Name or "Button"
                local callback = buttonConfig.Callback or function() end
              
                local button = Instance.new("TextButton")
                button.Name = buttonName
                button.Parent = sectionContent
                button.BackgroundColor3 = Theme.Tertiary
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, 0, 0, 35)
                button.Font = Enum.Font.GothamSemibold
                button.Text = buttonName
                button.TextColor3 = Theme.Text
                button.TextSize = 14
                button.AutoButtonColor = false
              
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 8)
                buttonCorner.Parent = button
              
                button.MouseButton1Click:Connect(function()
                    Ripple(button, button.AbsoluteSize.X / 2, button.AbsoluteSize.Y / 2)
                    callback()
                end)
              
                button.MouseEnter:Connect(function()
                    CreateTween(button, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
                end)
              
                button.MouseLeave:Connect(function()
                    CreateTween(button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                end)
              
                return button
            end,
            AddToggle = function(toggleConfig)
                toggleConfig = toggleConfig or {}
                local toggleName = toggleConfig.Name or "Toggle"
                local default = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end
              
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = toggleName
                toggleFrame.Parent = sectionContent
                toggleFrame.BackgroundColor3 = Theme.Tertiary
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
              
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 8)
                toggleCorner.Parent = toggleFrame
              
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "Label"
                toggleLabel.Parent = toggleFrame
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Position = UDim2.new(0, 15, 0, 0)
                toggleLabel.Size = UDim2.new(1, -60, 1, 0)
                toggleLabel.Font = Enum.Font.GothamSemibold
                toggleLabel.Text = toggleName
                toggleLabel.TextColor3 = Theme.Text
                toggleLabel.TextSize = 14
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
              
                local toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Parent = toggleFrame
                toggleButton.BackgroundColor3 = default and Theme.Primary or Theme.Border
                toggleButton.BorderSizePixel = 0
                toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
                toggleButton.Size = UDim2.new(0, 20, 0, 20)
                toggleButton.Font = Enum.Font.GothamBold
                toggleButton.Text = ""
                toggleButton.TextColor3 = Theme.Text
                toggleButton.AutoButtonColor = false
              
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "Circle"
                toggleCircle.Parent = toggleButton
                toggleCircle.BackgroundColor3 = Theme.Text
                toggleCircle.BorderSizePixel = 0
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -5)
                toggleCircle.Size = UDim2.new(0, 16, 0, 16)
                toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
              
                local toggleButtonCorner = Instance.new("UICorner")
                toggleButtonCorner.CornerRadius = UDim.new(0, 10)
                toggleButtonCorner.Parent = toggleButton
              
                local toggleCircleCorner = Instance.new("UICorner")
                toggleCircleCorner.CornerRadius = UDim.new(0, 8)
                toggleCircleCorner.Parent = toggleCircle
              
                local toggled = default
              
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        CreateTween(toggleButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                        CreateTween(toggleCircle, {Position = UDim2.new(1, -2, 0.5, -5)}, 0.2)
                    else
                        CreateTween(toggleButton, {BackgroundColor3 = Theme.Border}, 0.2)
                        CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -5)}, 0.2)
                    end
                    callback(toggled)
                end)
              
                return {
                    Set = function(state)
                        toggled = state
                        if toggled then
                            CreateTween(toggleButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                            CreateTween(toggleCircle, {Position = UDim2.new(1, -2, 0.5, -5)}, 0.2)
                        else
                            CreateTween(toggleButton, {BackgroundColor3 = Theme.Border}, 0.2)
                            CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -5)}, 0.2)
                        end
                        callback(toggled)
                    end,
                    Get = function()
                        return toggled
                    end
                }
            end,
            AddSlider = function(sliderConfig)
                sliderConfig = sliderConfig or {}
                local sliderName = sliderConfig.Name or "Slider"
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local increment = sliderConfig.Increment or 1
                local callback = sliderConfig.Callback or function() end
              
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = sliderName
                sliderFrame.Parent = sectionContent
                sliderFrame.BackgroundColor3 = Theme.Tertiary
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
              
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = sliderFrame
              
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "Label"
                sliderLabel.Parent = sliderFrame
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Position = UDim2.new(0, 15, 0, 5)
                sliderLabel.Size = UDim2.new(1, -60, 0, 20)
                sliderLabel.Font = Enum.Font.GothamSemibold
                sliderLabel.Text = sliderName
                sliderLabel.TextColor3 = Theme.Text
                sliderLabel.TextSize = 14
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
              
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Parent = sliderFrame
                sliderBar.BackgroundColor3 = Theme.Border
                sliderBar.BorderSizePixel = 0
                sliderBar.Position = UDim2.new(0, 15, 0, 30)
                sliderBar.Size = UDim2.new(1, -30, 0, 6)
              
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(0, 3)
                sliderBarCorner.Parent = sliderBar
              
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Parent = sliderBar
                sliderFill.BackgroundColor3 = Theme.Primary
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.ZIndex = 2
              
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(0, 3)
                sliderFillCorner.Parent = sliderFill
              
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.Parent = sliderFrame
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(1, -45, 0, 5)
                sliderValue.Size = UDim2.new(0, 40, 0, 20)
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.Text = tostring(default)
                sliderValue.TextColor3 = Theme.TextDark
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
              
                local draggingSlider = false
              
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = true
                    end
                end)
              
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)
              
                UserInputService.InputChanged:Connect(function(input)
                    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * percent / increment) * increment
                        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        sliderValue.Text = tostring(value)
                        callback(value)
                    end
                end)
              
                return {
                    Set = function(value)
                        value = math.clamp(value, min, max)
                        local percent = (value - min) / (max - min)
                        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        sliderValue.Text = tostring(value)
                        callback(value)
                    end
                }
            end,
            AddDropdown = function(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                local dropdownName = dropdownConfig.Name or "Dropdown"
                local options = dropdownConfig.Options or {}
                local default = dropdownConfig.Default or ""
                local callback = dropdownConfig.Callback or function() end
                local multi = dropdownConfig.MultipleOptions or false
              
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = dropdownName
                dropdownFrame.Parent = sectionContent
                dropdownFrame.BackgroundColor3 = Theme.Tertiary
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
              
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 8)
                dropdownCorner.Parent = dropdownFrame
              
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "Label"
                dropdownLabel.Parent = dropdownFrame
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                dropdownLabel.Size = UDim2.new(1, -60, 0.5, 0)
                dropdownLabel.Font = Enum.Font.GothamSemibold
                dropdownLabel.Text = dropdownName
                dropdownLabel.TextColor3 = Theme.Text
                dropdownLabel.TextSize = 14
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
              
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.Parent = dropdownFrame
                dropdownButton.BackgroundColor3 = Theme.Border
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Position = UDim2.new(0, 15, 0.5, 0)
                dropdownButton.Size = UDim2.new(1, -30, 0.5, 0)
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.Text = default ~= "" and default or "Select..."
                dropdownButton.TextColor3 = Theme.TextDark
                dropdownButton.TextSize = 12
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.AutoButtonColor = false
              
                local dropdownArrow = Instance.new("TextLabel")
                dropdownArrow.Name = "Arrow"
                dropdownArrow.Parent = dropdownButton
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
                dropdownArrow.Size = UDim2.new(0, 16, 0, 16)
                dropdownArrow.Font = Enum.Font.GothamBold
                dropdownArrow.Text = "▼"
                dropdownArrow.TextColor3 = Theme.TextDark
                dropdownArrow.TextSize = 12
                dropdownArrow.TextXAlignment = Enum.TextXAlignment.Center
                dropdownArrow.TextYAlignment = Enum.TextYAlignment.Center
              
                local dropdownList = Instance.new("Frame")
                dropdownList.Name = "List"
                dropdownList.Parent = dropdownFrame
                dropdownList.BackgroundColor3 = Theme.Secondary
                dropdownList.BorderSizePixel = 0
                dropdownList.Position = UDim2.new(0, 0, 1, 0)
                dropdownList.Size = UDim2.new(1, 0, 0, 0)
                dropdownList.Visible = false
                dropdownList.ClipsDescendants = true
              
                local dropdownListCorner = Instance.new("UICorner")
                dropdownListCorner.CornerRadius = UDim.new(0, 8)
                dropdownListCorner.Parent = dropdownList
              
                local dropdownListLayout = Instance.new("UIListLayout")
                dropdownListLayout.Parent = dropdownList
                dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropdownListLayout.Padding = UDim.new(0, 0)
              
                local selected = multi and {} or default
              
                local function updateButtonText()
                    if multi then
                        dropdownButton.Text = #selected > 0 and table.concat(selected, ", ") or "Select..."
                    else
                        dropdownButton.Text = selected or "Select..."
                    end
                end
              
                updateButtonText()
              
                local function createOption(optionName, index)
                    local option = Instance.new("TextButton")
                    option.Name = optionName
                    option.Parent = dropdownList
                    option.BackgroundColor3 = Theme.Secondary
                    option.BorderSizePixel = 0
                    option.Size = UDim2.new(1, 0, 0, 30)
                    option.Font = Enum.Font.Gotham
                    option.Text = optionName
                    option.TextColor3 = Theme.TextDark
                    option.TextSize = 12
                    option.AutoButtonColor = false
                  
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 6)
                    optionCorner.Parent = option
                  
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
                                if opt:IsA("TextButton") then
                                    opt.BackgroundColor3 = Theme.Secondary
                                end
                            end
                            option.BackgroundColor3 = Theme.Primary
                            dropdownList.Visible = false
                        end
                        updateButtonText()
                        callback(selected)
                    end)
                  
                    option.MouseEnter:Connect(function()
                        if multi and table.find(selected, optionName) then return end
                        CreateTween(option, {BackgroundColor3 = Theme.Tertiary}, 0.1)
                    end)
                  
                    option.MouseLeave:Connect(function()
                        if multi and table.find(selected, optionName) then
                            option.BackgroundColor3 = Theme.Primary
                        else
                            CreateTween(option, {BackgroundColor3 = Theme.Secondary}, 0.1)
                        end
                    end)
                  
                    if multi and table.find(selected, optionName) then
                        option.BackgroundColor3 = Theme.Primary
                    end
                end
              
                for i, option in ipairs(options) do
                    createOption(option, i)
                end
              
                dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.Size = UDim2.new(1, 0, 0, dropdownListLayout.AbsoluteContentSize.Y)
                end)
              
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdownList.Visible = not dropdownList.Visible
                    CreateTween(dropdownList, {Size = dropdownList.Visible and UDim2.new(1, 0, 0, dropdownListLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)}, 0.2)
                end)
              
                dropdownButton.MouseEnter:Connect(function()
                    CreateTween(dropdownButton, {BackgroundColor3 = Theme.Tertiary}, 0.1)
                end)
              
                dropdownButton.MouseLeave:Connect(function()
                    CreateTween(dropdownButton, {BackgroundColor3 = Theme.Border}, 0.1)
                end)
              
                return {
                    Refresh = function(newOptions, keepDefault)
                        for _, child in ipairs(dropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        selected = multi and {} or (keepDefault and default or "")
                        for _, option in ipairs(newOptions) do
                            createOption(option)
                        end
                        updateButtonText()
                        callback(selected)
                    end
                }
            end,
            AddMultiDropdown = function(multiDropdownConfig)
                multiDropdownConfig = multiDropdownConfig or {}
                multiDropdownConfig.MultipleOptions = true
                return self:AddDropdown(multiDropdownConfig)
            end
        }
    end
  
    function Library:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
      
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.TextDark
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
      
        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton
      
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = false
      
        tabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = Theme.TextDark
                end
            end
            tabButton.TextColor3 = Theme.Primary
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("Frame") and child.Name:find("Content") then
                    child.Visible = false
                end
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
        notif.Name = "Notification"
        notif.Parent = NotificationHolder
        notif.BackgroundColor3 = type == "Success" and Theme.Success or type == "Error" and Color3.fromRGB(255, 85, 85) or Theme.Primary
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(1, 0, 0, 80)
      
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notif
      
        local notifTitle = Instance.new("TextLabel")
        notifTitle.Name = "Title"
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
        notifContent.Name = "Content"
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
            CreateTween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3):Completed:Connect(function()
                notif:Destroy()
            end)
        end)
    end
  
    AnimateTitle(true)
  
    return Library
end

return Library
