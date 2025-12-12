--[[
- Created by fluflu
- used for Xeric Hub
- this UI is free to use for everyone else
]]--
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Library = {}
-- UI Variables
local ScreenGui
local MainFrame
local ContentFrame
local TabContainer
local NotificationHolder
-- Theme Colors
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
-- Utility Functions
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
-- Create Main Window
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
   
    -- Create ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
   
    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.ClipsDescendants = true
   
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
   
    -- Shadow Effect
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
   
    -- Top Bar
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
   
    -- Title
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
   
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Parent = topBar
    minimizeBtn.BackgroundColor3 = Theme.Primary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -80, 0.5, -15)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 16
    minimizeBtn.AutoButtonColor = false
   
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minimizeBtn
   
    -- Close Button
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
   
    -- Minimize Button Events
    minimizeBtn.MouseEnter:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
    end)
   
    minimizeBtn.MouseLeave:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
    end)
   
    -- Close Button Events
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
   
    -- Minimize Icon
    local Icon = Instance.new("TextButton")
    Icon.Name = "MinimizeIcon"
    Icon.Parent = ScreenGui
    Icon.BackgroundColor3 = Theme.Primary
    Icon.BorderSizePixel = 0
    Icon.Position = UDim2.new(1, -60, 1, -60)
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Font = Enum.Font.GothamBold
    Icon.Text = "UI"
    Icon.TextColor3 = Theme.Text
    Icon.TextSize = 12
    Icon.Visible = false
   
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = Icon
   
    -- Icon Draggable
    local minimized = false
    local windowPos = MainFrame.Position
    local iconDragging = false
    local iconDragInput, iconMousePos, iconFramePos
   
    Icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            iconDragging = true
            iconMousePos = input.Position
            iconFramePos = Icon.Position
           
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    iconDragging = false
                end
            end)
        end
    end)
   
    Icon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            iconDragInput = input
        end
    end)
   
    UserInputService.InputChanged:Connect(function(input)
        if input == iconDragInput and iconDragging then
            local delta = input.Position - iconMousePos
            Icon.Position = UDim2.new(
                iconFramePos.X.Scale,
                iconFramePos.X.Offset + delta.X,
                iconFramePos.Y.Scale,
                iconFramePos.Y.Offset + delta.Y
            )
        end
    end)
   
    -- Icon Click to Open
    Icon.MouseButton1Click:Connect(function()
        if minimized then
            minimized = false
            Icon.Visible = false
            MainFrame.Position = windowPos
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
            MainFrame.AnchorPoint = Vector2.new(0, 0)
        end
    end)
   
    -- Minimize Logic
    minimizeBtn.MouseButton1Click:Connect(function()
        if not minimized then
            minimized = true
            windowPos = MainFrame.Position
            local iconPosX = windowPos.X.Scale
            local iconPosY = windowPos.Y.Scale
            local iconPosOffsetX = windowPos.X.Offset + 650
            local iconPosOffsetY = windowPos.Y.Offset
            Icon.Position = UDim2.new(iconPosX, iconPosOffsetX, iconPosY, iconPosOffsetY)
            MainFrame.Visible = false
            Icon.Visible = true
        end
    end)
   
    -- Tab Container
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
   
    -- Content Frame
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
   
    -- Notification Holder
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "Notifications"
    NotificationHolder.Parent = ScreenGui
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -320, 0, 20)
    NotificationHolder.Size = UDim2.new(0, 300, 1, -40)
   
    local notifList = Instance.new("UIListLayout")
    notifList.Parent = NotificationHolder
    notifList.SortOrder = Enum.SortOrder.LayoutOrder
    notifList.Padding = UDim.new(0, 10)
    notifList.VerticalAlignment = Enum.VerticalAlignment.Top
   
    -- Make draggable
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
            MainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
            windowPos = MainFrame.Position
        end
    end)
   
    -- Intro Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
   
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
   
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local notifTitle = config.Title or "Notification"
        local notifContent = config.Content or "This is a notification"
        local notifDuration = config.Duration or 3
        local notifType = config.Type or "Default"
       
        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.Parent = NotificationHolder
        notif.BackgroundColor3 = Theme.Tertiary
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(1, 0, 0, 80)
        notif.ClipsDescendants = true
        notif.Position = UDim2.new(0, 300, 0, 0)
       
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif
       
        local notifBar = Instance.new("Frame")
        notifBar.Name = "Bar"
        notifBar.Parent = notif
        notifBar.BackgroundColor3 = notifType == "Success" and Theme.Success or Theme.Primary
        notifBar.BorderSizePixel = 0
        notifBar.Size = UDim2.new(0, 4, 1, 0)
       
        local notifTitleLabel = Instance.new("TextLabel")
        notifTitleLabel.Parent = notif
        notifTitleLabel.BackgroundTransparency = 1
        notifTitleLabel.Position = UDim2.new(0, 15, 0, 10)
        notifTitleLabel.Size = UDim2.new(1, -30, 0, 20)
        notifTitleLabel.Font = Enum.Font.GothamBold
        notifTitleLabel.Text = notifTitle
        notifTitleLabel.TextColor3 = Theme.Text
        notifTitleLabel.TextSize = 14
        notifTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
       
        local notifContentLabel = Instance.new("TextLabel")
        notifContentLabel.Parent = notif
        notifContentLabel.BackgroundTransparency = 1
        notifContentLabel.Position = UDim2.new(0, 15, 0, 35)
        notifContentLabel.Size = UDim2.new(1, -30, 1, -45)
        notifContentLabel.Font = Enum.Font.Gotham
        notifContentLabel.Text = notifContent
        notifContentLabel.TextColor3 = Theme.TextDark
        notifContentLabel.TextSize = 12
        notifContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        notifContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        notifContentLabel.TextWrapped = true
       
        -- Animate in
        CreateTween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
       
        -- Animate out
        task.delay(notifDuration, function()
            CreateTween(notif, {Position = UDim2.new(0, 300, 0, 0)}, 0.3)
            task.wait(0.3)
            notif:Destroy()
        end)
    end
   
    -- Create Tab
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or ""
       
        local Tab = {}
        Tab.Elements = {}
       
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.TextDark
        tabButton.TextSize = 13
        tabButton.AutoButtonColor = false
       
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
       
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.Primary
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
       
        local contentList = Instance.new("UIListLayout")
        contentList.Parent = tabContent
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 10)
       
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
        end)
       
        local contentPadding = Instance.new("UIPadding")
        contentPadding.Parent = tabContent
        contentPadding.PaddingTop = UDim.new(0, 15)
        contentPadding.PaddingLeft = UDim.new(0, 15)
        contentPadding.PaddingRight = UDim.new(0, 15)
        contentPadding.PaddingBottom = UDim.new(0, 15)
       
        tabButton.MouseButton1Click:Connect(function()
            Ripple(tabButton, tabButton.AbsoluteSize.X / 2, tabButton.AbsoluteSize.Y / 2)
           
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Theme.Tertiary
                tab.Button.TextColor3 = Theme.TextDark
                tab.Content.Visible = false
            end
           
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.Text
            tabContent.Visible = true
            Window.CurrentTab = Tab
        end)
       
        tabButton.MouseEnter:Connect(function()
            if tabButton.BackgroundColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
            end
        end)
       
        tabButton.MouseLeave:Connect(function()
            if tabButton.BackgroundColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end
        end)
       
        Tab.Button = tabButton
        Tab.Content = tabContent
        table.insert(Window.Tabs, Tab)
       
        if #Window.Tabs == 1 then
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.Text
            tabContent.Visible = true
            Window.CurrentTab = Tab
        end
       
        -- Add Button
        function Tab:AddButton(config)
            config = config or {}
            local btnName = config.Name or "Button"
            local btnCallback = config.Callback or function() end
           
            local button = Instance.new("TextButton")
            button.Name = btnName
            button.Parent = tabContent
            button.BackgroundColor3 = Theme.Tertiary
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 40)
            button.Font = Enum.Font.GothamBold
            button.Text = btnName
            button.TextColor3 = Theme.Text
            button.TextSize = 13
            button.AutoButtonColor = false
           
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = button
           
            button.MouseButton1Click:Connect(function()
                Ripple(button, button.AbsoluteSize.X / 2, button.AbsoluteSize.Y / 2)
                pcall(btnCallback)
            end)
           
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
            end)
           
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end)
           
            return button
        end
       
        -- Add Toggle
        function Tab:AddToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDefault = config.Default or false
            local toggleCallback = config.Callback or function() end
           
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = toggleName
            toggleFrame.Parent = tabContent
            toggleFrame.BackgroundColor3 = Theme.Tertiary
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
           
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = toggleFrame
           
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.Size = UDim2.new(1, -70, 1, 0)
            toggleLabel.Font = Enum.Font.GothamBold
            toggleLabel.Text = toggleName
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.TextSize = 13
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
           
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.BackgroundColor3 = toggleDefault and Theme.Primary or Theme.Border
            toggleButton.BorderSizePixel = 0
            toggleButton.Position = UDim2.new(1, -55, 0.5, -10)
            toggleButton.Size = UDim2.new(0, 45, 0, 20)
            toggleButton.Text = ""
            toggleButton.AutoButtonColor = false
           
            local toggleBtnCorner = Instance.new("UICorner")
            toggleBtnCorner.CornerRadius = UDim.new(1, 0)
            toggleBtnCorner.Parent = toggleButton
           
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleButton
            toggleCircle.BackgroundColor3 = Theme.Text
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Position = toggleDefault and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            toggleCircle.Size = UDim2.new(0, 16, 0, 16)
           
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
           
            local toggled = toggleDefault
           
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
               
                if toggled then
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    CreateTween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2, Enum.EasingStyle.Quad)
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Theme.Border}, 0.2)
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2, Enum.EasingStyle.Quad)
                end
               
                pcall(toggleCallback, toggled)
            end)
           
            toggleFrame.MouseEnter:Connect(function()
                CreateTween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
            end)
           
            toggleFrame.MouseLeave:Connect(function()
                CreateTween(toggleFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end)
           
            return {
                Set = function(self, value)
                    toggled = value
                    if value then
                        toggleButton.BackgroundColor3 = Theme.Primary
                        toggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
                    else
                        toggleButton.BackgroundColor3 = Theme.Border
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                    end
                end
            }
        end
       
        -- Add Slider
        function Tab:AddSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local sliderMin = config.Min or 0
            local sliderMax = config.Max or 100
            local sliderDefault = config.Default or 50
            local sliderIncrement = config.Increment or 1
            local sliderCallback = config.Callback or function() end
           
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = sliderName
            sliderFrame.Parent = tabContent
            sliderFrame.BackgroundColor3 = Theme.Tertiary
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
           
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 8)
            sliderCorner.Parent = sliderFrame
           
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 15, 0, 5)
            sliderLabel.Size = UDim2.new(1, -80, 0, 20)
            sliderLabel.Font = Enum.Font.GothamBold
            sliderLabel.Text = sliderName
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.TextSize = 13
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
           
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Parent = sliderFrame
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(1, -70, 0, 5)
            sliderValue.Size = UDim2.new(0, 55, 0, 20)
            sliderValue.Font = Enum.Font.GothamBold
            sliderValue.Text = tostring(sliderDefault)
            sliderValue.TextColor3 = Theme.Primary
            sliderValue.TextSize = 13
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
           
            local sliderBar = Instance.new("Frame")
            sliderBar.Parent = sliderFrame
            sliderBar.BackgroundColor3 = Theme.Border
            sliderBar.BorderSizePixel = 0
            sliderBar.Position = UDim2.new(0, 15, 1, -20)
            sliderBar.Size = UDim2.new(1, -30, 0, 6)
           
            local sliderBarCorner = Instance.new("UICorner")
            sliderBarCorner.CornerRadius = UDim.new(1, 0)
            sliderBarCorner.Parent = sliderBar
           
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBar
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
           
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
           
            local sliderButton = Instance.new("TextButton")
            sliderButton.Parent = sliderBar
            sliderButton.BackgroundColor3 = Theme.Text
            sliderButton.BorderSizePixel = 0
            sliderButton.Position = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), -6, 0.5, -6)
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Text = ""
            sliderButton.AutoButtonColor = false
           
            local sliderBtnCorner = Instance.new("UICorner")
            sliderBtnCorner.CornerRadius = UDim.new(1, 0)
            sliderBtnCorner.Parent = sliderButton
           
            local currentValue = sliderDefault
            local dragging = false
           
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor((sliderMin + (sliderMax - sliderMin) * pos) / sliderIncrement + 0.5) * sliderIncrement
                value = math.clamp(value, sliderMin, sliderMax)
               
                currentValue = value
                sliderValue.Text = tostring(value)
               
                CreateTween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                CreateTween(sliderButton, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
               
                pcall(sliderCallback, value)
            end
           
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
                CreateTween(sliderButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
            end)
           
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    CreateTween(sliderButton, {Size = UDim2.new(0, 12, 0, 12)}, 0.1)
                end
            end)
           
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
           
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                end
            end)
           
            return {
                Set = function(self, value)
                    currentValue = math.clamp(value, sliderMin, sliderMax)
                    sliderValue.Text = tostring(currentValue)
                    local pos = (currentValue - sliderMin) / (sliderMax - sliderMin)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderButton.Position = UDim2.new(pos, -6, 0.5, -6)
                end
            }
        end
       
        -- Add Dropdown
        function Tab:AddDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local dropdownOptions = config.Options or {"Option 1", "Option 2", "Option 3"}
            local dropdownDefault = config.Default or dropdownOptions[1]
            local dropdownCallback = config.Callback or function() end
           
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = dropdownName
            dropdownFrame.Parent = tabContent
            dropdownFrame.BackgroundColor3 = Theme.Tertiary
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.ZIndex = 5
           
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 8)
            dropdownCorner.Parent = dropdownFrame
           
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Parent = dropdownFrame
            dropdownButton.BackgroundTransparency = 1
            dropdownButton.Size = UDim2.new(1, 0, 0, 40)
            dropdownButton.Font = Enum.Font.GothamBold
            dropdownButton.Text = ""
            dropdownButton.TextColor3 = Theme.Text
            dropdownButton.TextSize = 13
            dropdownButton.AutoButtonColor = false
           
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Parent = dropdownButton
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            dropdownLabel.Size = UDim2.new(1, -60, 1, 0)
            dropdownLabel.Font = Enum.Font.GothamBold
            dropdownLabel.Text = dropdownName .. ": " .. dropdownDefault
            dropdownLabel.TextColor3 = Theme.Text
            dropdownLabel.TextSize = 13
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
           
            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.Parent = dropdownButton
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Position = UDim2.new(1, -35, 0, 0)
            dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            dropdownArrow.Font = Enum.Font.GothamBold
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Theme.Primary
            dropdownArrow.TextSize = 12
           
            local dropdownList = Instance.new("ScrollingFrame")
            dropdownList.Parent = dropdownFrame
            dropdownList.BackgroundColor3 = Theme.Background
            dropdownList.BorderSizePixel = 0
            dropdownList.Position = UDim2.new(0, 5, 0, 45)
            dropdownList.Size = UDim2.new(1, -10, 0, 0)
            dropdownList.ScrollBarThickness = 4
            dropdownList.ScrollBarImageColor3 = Theme.Primary
            dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            dropdownList.Visible = false
           
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 6)
            listCorner.Parent = dropdownList
           
            local dropdownListLayout = Instance.new("UIListLayout")
            dropdownListLayout.Parent = dropdownList
            dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownListLayout.Padding = UDim.new(0, 2)
           
            dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownListLayout.AbsoluteContentSize.Y + 5)
            end)
           
            local listPadding = Instance.new("UIPadding")
            listPadding.Parent = dropdownList
            listPadding.PaddingTop = UDim.new(0, 5)
            listPadding.PaddingLeft = UDim.new(0, 5)
            listPadding.PaddingRight = UDim.new(0, 5)
            listPadding.PaddingBottom = UDim.new(0, 5)
           
            local opened = false
            local currentValue = dropdownDefault
           
            for _, option in ipairs(dropdownOptions) do
                local optionButton = Instance.new("TextButton")
                optionButton.Parent = dropdownList
                optionButton.BackgroundColor3 = Theme.Tertiary
                optionButton.BorderSizePixel = 0
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Font = Enum.Font.Gotham
                optionButton.Text = option
                optionButton.TextColor3 = Theme.Text
                optionButton.TextSize = 12
                optionButton.AutoButtonColor = false
               
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = optionButton
               
                if option == currentValue then
                    optionButton.BackgroundColor3 = Theme.Primary
                end
               
                optionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    dropdownLabel.Text = dropdownName .. ": " .. option
                   
                    for _, btn in ipairs(dropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            CreateTween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                        end
                    end
                   
                    CreateTween(optionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    pcall(dropdownCallback, option)
                end)
               
                optionButton.MouseEnter:Connect(function()
                    if option ~= currentValue then
                        CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
                    end
                end)
               
                optionButton.MouseLeave:Connect(function()
                    if option ~= currentValue then
                        CreateTween(optionButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    end
                end)
            end
           
            dropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
               
                if opened then
                    dropdownList.Visible = true
                    local targetHeight = math.min(#dropdownOptions * 32 + 10, 150)
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 45 + targetHeight)}, 0.3)
                    CreateTween(dropdownList, {Size = UDim2.new(1, -10, 0, targetHeight)}, 0.3)
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.3)
                else
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    CreateTween(dropdownList, {Size = UDim2.new(1, -10, 0, 0)}, 0.3)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                    task.wait(0.3)
                    dropdownList.Visible = false
                end
            end)
           
            return {
                Set = function(self, value)
                    if table.find(dropdownOptions, value) then
                        currentValue = value
                        dropdownLabel.Text = dropdownName .. ": " .. value
                    end
                end,
                Refresh = function(self, newOptions, keepCurrent)
                    dropdownOptions = newOptions
                    for _, child in ipairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                   
                    if not keepCurrent or not table.find(newOptions, currentValue) then
                        currentValue = newOptions[1]
                        dropdownLabel.Text = dropdownName .. ": " .. currentValue
                    end
                   
                    for _, option in ipairs(newOptions) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Parent = dropdownList
                        optionButton.BackgroundColor3 = option == currentValue and Theme.Primary or Theme.Tertiary
                        optionButton.BorderSizePixel = 0
                        optionButton.Size = UDim2.new(1, 0, 0, 30)
                        optionButton.Font = Enum.Font.Gotham
                        optionButton.Text = option
                        optionButton.TextColor3 = Theme.Text
                        optionButton.TextSize = 12
                        optionButton.AutoButtonColor = false
                       
                        local optionCorner = Instance.new("UICorner")
                        optionCorner.CornerRadius = UDim.new(0, 6)
                        optionCorner.Parent = optionButton
                       
                        optionButton.MouseButton1Click:Connect(function()
                            currentValue = option
                            dropdownLabel.Text = dropdownName .. ": " .. option
                           
                            for _, btn in ipairs(dropdownList:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    CreateTween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                                end
                            end
                           
                            CreateTween(optionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                            pcall(dropdownCallback, option)
                        end)
                    end
                end
            }
        end
       
        -- Add Multi-Dropdown
        function Tab:AddMultiDropdown(config)
            config = config or {}
            local multiName = config.Name or "Multi Dropdown"
            local multiOptions = config.Options or {"Option 1", "Option 2", "Option 3"}
            local multiDefault = config.Default or {}
            local multiCallback = config.Callback or function() end
           
            local multiFrame = Instance.new("Frame")
            multiFrame.Name = multiName
            multiFrame.Parent = tabContent
            multiFrame.BackgroundColor3 = Theme.Tertiary
            multiFrame.BorderSizePixel = 0
            multiFrame.Size = UDim2.new(1, 0, 0, 40)
            multiFrame.ClipsDescendants = true
            multiFrame.ZIndex = 5
           
            local multiCorner = Instance.new("UICorner")
            multiCorner.CornerRadius = UDim.new(0, 8)
            multiCorner.Parent = multiFrame
           
            local multiButton = Instance.new("TextButton")
            multiButton.Parent = multiFrame
            multiButton.BackgroundTransparency = 1
            multiButton.Size = UDim2.new(1, 0, 0, 40)
            multiButton.Font = Enum.Font.GothamBold
            multiButton.Text = ""
            multiButton.TextColor3 = Theme.Text
            multiButton.TextSize = 13
            multiButton.AutoButtonColor = false
           
            local multiLabel = Instance.new("TextLabel")
            multiLabel.Parent = multiButton
            multiLabel.BackgroundTransparency = 1
            multiLabel.Position = UDim2.new(0, 15, 0, 0)
            multiLabel.Size = UDim2.new(1, -60, 1, 0)
            multiLabel.Font = Enum.Font.GothamBold
            multiLabel.Text = multiName .. ": " .. (#multiDefault > 0 and table.concat(multiDefault, ", ") or "None")
            multiLabel.TextColor3 = Theme.Text
            multiLabel.TextSize = 13
            multiLabel.TextXAlignment = Enum.TextXAlignment.Left
            multiLabel.TextTruncate = Enum.TextTruncate.AtEnd
           
            local multiArrow = Instance.new("TextLabel")
            multiArrow.Parent = multiButton
            multiArrow.BackgroundTransparency = 1
            multiArrow.Position = UDim2.new(1, -35, 0, 0)
            multiArrow.Size = UDim2.new(0, 20, 1, 0)
            multiArrow.Font = Enum.Font.GothamBold
            multiArrow.Text = "▼"
            multiArrow.TextColor3 = Theme.Primary
            multiArrow.TextSize = 12
           
            local multiList = Instance.new("ScrollingFrame")
            multiList.Parent = multiFrame
            multiList.BackgroundColor3 = Theme.Background
            multiList.BorderSizePixel = 0
            multiList.Position = UDim2.new(0, 5, 0, 45)
            multiList.Size = UDim2.new(1, -10, 0, 0)
            multiList.ScrollBarThickness = 4
            multiList.ScrollBarImageColor3 = Theme.Primary
            multiList.CanvasSize = UDim2.new(0, 0, 0, 0)
            multiList.Visible = false
           
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 6)
            listCorner.Parent = multiList
           
            local multiListLayout = Instance.new("UIListLayout")
            multiListLayout.Parent = multiList
            multiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            multiListLayout.Padding = UDim.new(0, 2)
           
            multiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                multiList.CanvasSize = UDim2.new(0, 0, 0, multiListLayout.AbsoluteContentSize.Y + 5)
            end)
           
            local listPadding = Instance.new("UIPadding")
            listPadding.Parent = multiList
            listPadding.PaddingTop = UDim.new(0, 5)
            listPadding.PaddingLeft = UDim.new(0, 5)
            listPadding.PaddingRight = UDim.new(0, 5)
            listPadding.PaddingBottom = UDim.new(0, 5)
           
            local opened = false
            local selectedValues = {}
            for _, v in ipairs(multiDefault) do
                selectedValues[v] = true
            end
           
            local function updateLabel()
                local selected = {}
                for option, isSelected in pairs(selectedValues) do
                    if isSelected then
                        table.insert(selected, option)
                    end
                end
                multiLabel.Text = multiName .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")
            end
           
            for _, option in ipairs(multiOptions) do
                local optionFrame = Instance.new("Frame")
                optionFrame.Parent = multiList
                optionFrame.BackgroundColor3 = Theme.Tertiary
                optionFrame.BorderSizePixel = 0
                optionFrame.Size = UDim2.new(1, 0, 0, 30)
               
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = optionFrame
               
                local optionLabel = Instance.new("TextLabel")
                optionLabel.Parent = optionFrame
                optionLabel.BackgroundTransparency = 1
                optionLabel.Position = UDim2.new(0, 10, 0, 0)
                optionLabel.Size = UDim2.new(1, -40, 1, 0)
                optionLabel.Font = Enum.Font.Gotham
                optionLabel.Text = option
                optionLabel.TextColor3 = Theme.Text
                optionLabel.TextSize = 12
                optionLabel.TextXAlignment = Enum.TextXAlignment.Left
               
                local checkbox = Instance.new("Frame")
                checkbox.Parent = optionFrame
                checkbox.BackgroundColor3 = selectedValues[option] and Theme.Primary or Theme.Border
                checkbox.BorderSizePixel = 0
                checkbox.Position = UDim2.new(1, -25, 0.5, -8)
                checkbox.Size = UDim2.new(0, 16, 0, 16)
               
                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 4)
                checkCorner.Parent = checkbox
               
                local checkmark = Instance.new("TextLabel")
                checkmark.Parent = checkbox
                checkmark.BackgroundTransparency = 1
                checkmark.Size = UDim2.new(1, 0, 1, 0)
                checkmark.Font = Enum.Font.GothamBold
                checkmark.Text = selectedValues[option] and "✓" or ""
                checkmark.TextColor3 = Theme.Text
                checkmark.TextSize = 12
               
                local optionButton = Instance.new("TextButton")
                optionButton.Parent = optionFrame
                optionButton.BackgroundTransparency = 1
                optionButton.Size = UDim2.new(1, 0, 1, 0)
                optionButton.Text = ""
                optionButton.AutoButtonColor = false
               
                optionButton.MouseButton1Click:Connect(function()
                    selectedValues[option] = not selectedValues[option]
                   
                    if selectedValues[option] then
                        CreateTween(checkbox, {BackgroundColor3 = Theme.Primary}, 0.2)
                        checkmark.Text = "✓"
                    else
                        CreateTween(checkbox, {BackgroundColor3 = Theme.Border}, 0.2)
                        checkmark.Text = ""
                    end
                   
                    updateLabel()
                   
                    local selected = {}
                    for opt, isSelected in pairs(selectedValues) do
                        if isSelected then
                            table.insert(selected, opt)
                        end
                    end
                    pcall(multiCallback, selected)
                end)
               
                optionFrame.MouseEnter:Connect(function()
                    CreateTween(optionFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
                end)
               
                optionFrame.MouseLeave:Connect(function()
                    CreateTween(optionFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                end)
            end
           
            multiButton.MouseButton1Click:Connect(function()
                opened = not opened
               
                if opened then
                    multiList.Visible = true
                    local targetHeight = math.min(#multiOptions * 32 + 10, 150)
                    CreateTween(multiFrame, {Size = UDim2.new(1, 0, 0, 45 + targetHeight)}, 0.3)
                    CreateTween(multiList, {Size = UDim2.new(1, -10, 0, targetHeight)}, 0.3)
                    CreateTween(multiArrow, {Rotation = 180}, 0.3)
                else
                    CreateTween(multiFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    CreateTween(multiList, {Size = UDim2.new(1, -10, 0, 0)}, 0.3)
                    CreateTween(multiArrow, {Rotation = 0}, 0.3)
                    task.wait(0.3)
                    multiList.Visible = false
                end
            end)
           
            return {
                Set = function(self, values)
                    selectedValues = {}
                    for _, v in ipairs(values) do
                        selectedValues[v] = true
                    end
                    updateLabel()
                end
            }
        end
       
        -- Add Label
        function Tab:AddLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"
           
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Parent = tabContent
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Font = Enum.Font.Gotham
            label.Text = labelText
            label.TextColor3 = Theme.TextDark
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
           
            return label
        end
       
        return Tab
    end
   
    return Window
end
return Library
