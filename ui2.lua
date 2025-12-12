local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Library = {}
local ScreenGui
local MainFrame
local ContentFrame
local TabContainer
local NotificationHolder
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(20, 20, 20),
    Tertiary = Color3.fromRGB(25, 25, 25),
    Primary = Color3.fromRGB(30, 144, 255),
    PrimaryDark = Color3.fromRGB(0, 100, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 255, 0),
    Border = Color3.fromRGB(40, 40, 40)
}
local themeFile = "fluentui_theme.cfg"
local function saveTheme()
    local r = math.floor(Theme.Primary.R * 255 + 0.5)
    local g = math.floor(Theme.Primary.G * 255 + 0.5)
    local b = math.floor(Theme.Primary.B * 255 + 0.5)
    writefile(themeFile, string.format("R=%d G=%d B=%d", r, g, b))
end
local function loadTheme()
    if isfile and isfile(themeFile) then
        local data = readfile(themeFile)
        local r, g, b = data:match("R=(%d+)%s*G=(%d+)%s*B=(%d+)")
        if r then
            local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            Theme.Primary = color
            local dr = math.floor(tonumber(r) * 0.7)
            local dg = math.floor(tonumber(g) * 0.7)
            local db = math.floor(tonumber(b) * 0.7)
            Theme.PrimaryDark = Color3.fromRGB(dr, dg, db)
        end
    end
end
loadTheme()
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
}
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
}
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
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
    MainFrame.Position = UDim2.new(0.5, -350, 0, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.ClipsDescendants = true
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.Visible = false
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
    minimizeBtn.BackgroundColor3 = Theme.PrimaryDark
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
    minimizeBtn.MouseEnter:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
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
    closeBtn.MouseEnter:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
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
    local pfpFrame = Instance.new("Frame")
    pfpFrame.Name = "PfpDivider"
    pfpFrame.Parent = TabContainer
    pfpFrame.BackgroundTransparency = 1
    pfpFrame.Size = UDim2.new(1, 0, 0, 60)
    pfpFrame.LayoutOrder = 0
    local pfp = Instance.new("ImageLabel")
    pfp.Name = "Pfp"
    pfp.Parent = pfpFrame
    pfp.BackgroundColor3 = Theme.Primary
    pfp.Position = UDim2.new(0, 5, 0.5, -20)
    pfp.Size = UDim2.new(0, 40, 0, 40)
    pfp.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
    pfp.ScaleType = Enum.ScaleType.Fit
    local pfpCorner = Instance.new("UICorner")
    pfpCorner.CornerRadius = UDim.new(0.5, 0)
    pfpCorner.Parent = pfp
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
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "MinimizedIcon"
    toggleButton.Parent = ScreenGui
    toggleButton.BackgroundColor3 = Theme.Primary
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "−"
    toggleButton.TextColor3 = Theme.Text
    toggleButton.TextSize = 30
    toggleButton.AutoButtonColor = false
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleButton
    local toggleDragging = false
    local toggleDragInput, toggleMousePos, toggleFramePos
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDragging = true
            toggleMousePos = input.Position
            toggleFramePos = toggleButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    toggleDragging = false
                end
            end)
        end
    end)
    toggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            toggleDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == toggleDragInput and toggleDragging then
            local delta = input.Position - toggleMousePos
            toggleButton.Position = UDim2.new(
                toggleFramePos.X.Scale,
                toggleFramePos.X.Offset + delta.X,
                toggleFramePos.Y.Scale,
                toggleFramePos.Y.Offset + delta.Y
            )
        end
    end)
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
        end
    end)
    local isOpen = false
    local function toggleUI()
        isOpen = not isOpen
        if isOpen then
            MainFrame.Visible = true
            CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
            toggleButton.Visible = false
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.3)
            MainFrame.Visible = false
            toggleButton.Visible = true
        end
    end
    toggleButton.MouseButton1Click:Connect(function()
        Ripple(toggleButton, toggleButton.AbsoluteSize.X / 2, toggleButton.AbsoluteSize.Y / 2)
        toggleUI()
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        toggleUI()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    local function updateElements()
        closeBtn.BackgroundColor3 = Theme.Primary
        minimizeBtn.BackgroundColor3 = Theme.PrimaryDark
        if Window.CurrentTab then
            Window.CurrentTab.Button.BackgroundColor3 = Theme.Primary
            Window.CurrentTab.Button.TextColor3 = Theme.Text
        end
        for _, tab in pairs(Window.Tabs) do
            if tab.Button ~= Window.CurrentTab.Button then
                tab.Button.BackgroundColor3 = Theme.Tertiary
                tab.Button.TextColor3 = Theme.TextDark
            end
        end
        pfp.BackgroundColor3 = Theme.Primary
    end
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
        CreateTween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        task.delay(notifDuration, function()
            CreateTween(notif, {Position = UDim2.new(0, 300, 0, 0)}, 0.3)
            task.wait(0.3)
            notif:Destroy()
        end)
    end
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
        tabButton.LayoutOrder = #Window.Tabs + 1
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
        function Tab:AddLabel(config)
            config = config or {}
            local labelText = config.Text or "Section Title"
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Parent = tabContent
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 0, 0, 0)
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Font = Enum.Font.GothamBold
            label.Text = labelText
            label.TextColor3 = Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Center
            return label
        end
        function Tab:AddColorPicker(config)
            config = config or {}
            local pickerName = config.Name or "Color Picker"
            local defaultColor = config.Default or Color3.fromRGB(255, 255, 255)
            local pickerCallback = config.Callback or function() end
            local pickerFrame = Instance.new("Frame")
            pickerFrame.Name = pickerName
            pickerFrame.Parent = tabContent
            pickerFrame.BackgroundColor3 = Theme.Tertiary
            pickerFrame.BorderSizePixel = 0
            pickerFrame.Size = UDim2.new(1, 0, 0, 120)
            local pickerCorner = Instance.new("UICorner")
            pickerCorner.CornerRadius = UDim.new(0, 8)
            pickerCorner.Parent = pickerFrame
            local pickerLabel = Instance.new("TextLabel")
            pickerLabel.Parent = pickerFrame
            pickerLabel.BackgroundTransparency = 1
            pickerLabel.Position = UDim2.new(0, 15, 0, 5)
            pickerLabel.Size = UDim2.new(1, -80, 0, 20)
            pickerLabel.Font = Enum.Font.GothamBold
            pickerLabel.Text = pickerName
            pickerLabel.TextColor3 = Theme.Text
            pickerLabel.TextSize = 13
            pickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            local preview = Instance.new("Frame")
            preview.Name = "Preview"
            preview.Parent = pickerFrame
            preview.BackgroundColor3 = defaultColor
            preview.Position = UDim2.new(1, -65, 0, 5)
            preview.Size = UDim2.new(0, 40, 0, 20)
            local previewCorner = Instance.new("UICorner")
            previewCorner.CornerRadius = UDim.new(0, 4)
            previewCorner.Parent = preview
            local subFrame = Instance.new("Frame")
            subFrame.Parent = pickerFrame
            subFrame.BackgroundTransparency = 1
            subFrame.Position = UDim2.new(0, 0, 0, 30)
            subFrame.Size = UDim2.new(1, 0, 1, -30)
            local subList = Instance.new("UIListLayout")
            subList.Parent = subFrame
            subList.SortOrder = Enum.SortOrder.LayoutOrder
            subList.Padding = UDim.new(0, 5)
            local subPadding = Instance.new("UIPadding")
            subPadding.Parent = subFrame
            subPadding.PaddingLeft = UDim.new(0, 15)
            subPadding.PaddingRight = UDim.new(0, 15)
            local channels = {"R", "G", "B"}
            local values = {math.floor(defaultColor.R * 255), math.floor(defaultColor.G * 255), math.floor(defaultColor.B * 255)}
            local channelSliders = {}
            for i, ch in ipairs(channels) do
                local chFrame = Instance.new("Frame")
                chFrame.Name = ch
                chFrame.Parent = subFrame
                chFrame.BackgroundTransparency = 1
                chFrame.Size = UDim2.new(1, 0, 0, 20)
                local chLabel = Instance.new("TextLabel")
                chLabel.Parent = chFrame
                chLabel.BackgroundTransparency = 1
                chLabel.Position = UDim2.new(0, 0, 0, 0)
                chLabel.Size = UDim2.new(0, 15, 1, 0)
                chLabel.Font = Enum.Font.Gotham
                chLabel.Text = ch
                chLabel.TextColor3 = Theme.Text
                chLabel.TextSize = 12
                chLabel.TextXAlignment = Enum.TextXAlignment.Left
                local chValue = Instance.new("TextLabel")
                chValue.Parent = chFrame
                chValue.BackgroundTransparency = 1
                chValue.Position = UDim2.new(0, 25, 0, 0)
                chValue.Size = UDim2.new(0, 30, 1, 0)
                chValue.Font = Enum.Font.Gotham
                chValue.Text = tostring(values[i])
                chValue.TextColor3 = Theme.Primary
                chValue.TextSize = 12
                chValue.TextXAlignment = Enum.TextXAlignment.Left
                local chBar = Instance.new("Frame")
                chBar.Parent = chFrame
                chBar.BackgroundColor3 = Theme.Border
                chBar.BorderSizePixel = 0
                chBar.Position = UDim2.new(0, 60, 0.5, -3)
                chBar.Size = UDim2.new(0.5, 0, 0, 6)
                local chBarCorner = Instance.new("UICorner")
                chBarCorner.CornerRadius = UDim.new(1, 0)
                chBarCorner.Parent = chBar
                local chFill = Instance.new("Frame")
                chFill.Parent = chBar
                chFill.BackgroundColor3 = Theme.Primary
                chFill.Size = UDim2.new(values[i] / 255, 0, 1, 0)
                local chFillCorner = Instance.new("UICorner")
                chFillCorner.CornerRadius = UDim.new(1, 0)
                chFillCorner.Parent = chFill
                local chButton = Instance.new("TextButton")
                chButton.Parent = chBar
                chButton.BackgroundColor3 = Theme.Text
                chButton.BorderSizePixel = 0
                chButton.Position = UDim2.new(values[i] / 255, -6, 0.5, -6)
                chButton.Size = UDim2.new(0, 12, 0, 12)
                chButton.Text = ""
                chButton.AutoButtonColor = false
                local chBtnCorner = Instance.new("UICorner")
                chBtnCorner.CornerRadius = UDim.new(1, 0)
                chBtnCorner.Parent = chButton
                local chDragging = false
                local function updateChSlider(input)
                    local pos = math.clamp((input.Position.X - chBar.AbsolutePosition.X) / chBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(pos * 255)
                    values[i] = value
                    chValue.Text = tostring(value)
                    CreateTween(chFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    CreateTween(chButton, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                    local r, g, b = values[1], values[2], values[3]
                    local newColor = Color3.fromRGB(r, g, b)
                    preview.BackgroundColor3 = newColor
                    pcall(pickerCallback, newColor)
                end
                chButton.MouseButton1Down:Connect(function()
                    chDragging = true
                    CreateTween(chButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        chDragging = false
                        CreateTween(chButton, {Size = UDim2.new(0, 12, 0, 12)}, 0.1)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if chDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateChSlider(input)
                    end
                end)
                chBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateChSlider(input)
                    end
                end)
                channelSliders[ch] = {
                    valueLabel = chValue,
                    fill = chFill,
                    button = chButton
                }
            end
            return {
                Set = function(self, color)
                    values = {math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)}
                    for i, ch in ipairs(channels) do
                        local slider = channelSliders[ch]
                        local value = values[i]
                        local pos = value / 255
                        slider.valueLabel.Text = tostring(value)
                        slider.fill.Size = UDim2.new(pos, 0, 1, 0)
                        slider.button.Position = UDim2.new(pos, -6, 0.5, -6)
                    end
                    preview.BackgroundColor3 = color
                end
            }
        end
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
                    opened = false
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    CreateTween(dropdownList, {Size = UDim2.new(1, -10, 0, 0)}, 0.3)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                    task.delay(0.3, function() dropdownList.Visible = false end)
                    pcall(dropdownCallback, option)
                end)
                optionButton.MouseEnter:Connect(function()
                    if optionButton.BackgroundColor3 ~= Theme.Primary then
                        CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
                    end
                end)
                optionButton.MouseLeave:Connect(function()
                    if optionButton.BackgroundColor3 ~= Theme.Primary then
                        CreateTween(optionButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    end
                end)
            end
            dropdownButton.MouseButton1Click:Connect(function()
                Ripple(dropdownButton, dropdownButton.AbsoluteSize.X / 2, dropdownButton.AbsoluteSize.Y / 2)
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
                        for _, btn in ipairs(dropdownList:GetChildren()) do
                            if btn:IsA("TextButton") then
                                if btn.Text == value then
                                    CreateTween(btn, {BackgroundColor3 = Theme.Primary}, 0.2)
                                else
                                    CreateTween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                                end
                            end
                        end
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
                            opened = false
                            CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                            CreateTween(dropdownList, {Size = UDim2.new(1, -10, 0, 0)}, 0.3)
                            CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                            task.delay(0.3, function() dropdownList.Visible = false end)
                            pcall(dropdownCallback, option)
                        end)
                    end
                end
            }
        end
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
            updateLabel()
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
                optionLabel.Position = UDim2.new(0, 15, 0, 0)
                optionLabel.Size = UDim2.new(1, -60, 1, 0)
                optionLabel.Font = Enum.Font.Gotham
                optionLabel.Text = option
                optionLabel.TextColor3 = Theme.Text
                optionLabel.TextSize = 12
                optionLabel.TextXAlignment = Enum.TextXAlignment.Left
                local checkbox = Instance.new("Frame")
                checkbox.Name = "Checkbox"
                checkbox.Parent = optionFrame
                checkbox.BackgroundColor3 = selectedValues[option] and Theme.Primary or Theme.Border
                checkbox.BorderSizePixel = 0
                checkbox.Position = UDim2.new(1, -30, 0.5, -7)
                checkbox.Size = UDim2.new(0, 14, 0, 14)
                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 4)
                checkCorner.Parent = checkbox
                local checkmark = Instance.new("TextLabel")
                checkmark.Parent = checkbox
                checkmark.BackgroundTransparency = 1
                checkmark.Position = UDim2.new(0, 0, 0, 0)
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
                Ripple(multiButton, multiButton.AbsoluteSize.X / 2, multiButton.AbsoluteSize.Y / 2)
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
                    for _, child in ipairs(multiList:GetChildren()) do
                        if child:IsA("Frame") then
                            local optionText = child:FindFirstChild("TextLabel").Text
                            local checkbox = child:FindFirstChild("Checkbox")
                            local checkmark = checkbox:FindFirstChild("TextLabel")
                            if selectedValues[optionText] then
                                CreateTween(checkbox, {BackgroundColor3 = Theme.Primary}, 0.2)
                                checkmark.Text = "✓"
                            else
                                CreateTween(checkbox, {BackgroundColor3 = Theme.Border}, 0.2)
                                checkmark.Text = ""
                            end
                        end
                    end
                    updateLabel()
                end
            }
        end
        function Tab:AddTextBox(config)
            warn("AddTextBox function is incomplete in the provided source.")
            return {}
        end
        function Tab:AddBind(config)
            warn("AddBind function is incomplete in the provided source.")
            return {}
        end
        function Tab:AddKeybind(config)
            warn("AddKeybind function is incomplete in the provided source.")
            return {}
        end
        return Tab
    end
    local configTab = Window:CreateTab({Name = "Config"})
    local presets = {
        Blue = Color3.fromRGB(30, 144, 255),
        Red = Color3.fromRGB(255, 0, 0),
        DarkBlue = Color3.fromRGB(0, 0, 200),
        Cyan = Color3.fromRGB(0, 255, 255),
        Magenta = Color3.fromRGB(255, 0, 255),
        Green = Color3.fromRGB(0, 255, 0),
        Orange = Color3.fromRGB(255, 165, 0)
    }
    local presetDrop = configTab:AddDropdown({
        Name = "Theme Preset",
        Options = {"Blue", "Red", "Dark Blue", "Cyan", "Magenta", "Green", "Orange"},
        Default = "Blue",
        Callback = function(value)
            Theme.Primary = presets[value]
            local r = math.floor(Theme.Primary.R * 255 * 0.7 + 0.5)
            local g = math.floor(Theme.Primary.G * 255 * 0.7 + 0.5)
            local b = math.floor(Theme.Primary.B * 255 * 0.7 + 0.5)
            Theme.PrimaryDark = Color3.fromRGB(r, g, b)
            updateElements()
            saveTheme()
            Window:Notify({
                Title = "Preset Loaded",
                Content = value .. " theme applied!",
                Duration = 2
            })
        end
    })
    local primaryPicker = configTab:AddColorPicker({
        Name = "Primary Color",
        Default = Theme.Primary,
        Callback = function(color)
            Theme.Primary = color
            local r = math.floor(color.R * 255 * 0.7 + 0.5)
            local g = math.floor(color.G * 255 * 0.7 + 0.5)
            local b = math.floor(color.B * 255 * 0.7 + 0.5)
            Theme.PrimaryDark = Color3.fromRGB(r, g, b)
            updateElements()
            saveTheme()
            Window:Notify({
                Title = "Color Changed",
                Content = "Primary color updated!",
                Duration = 1
            })
        end
    })
    local playersTab = Window:CreateTab({Name = "Players"})
    local playerSearch = playersTab:AddTextBox({
        Name = "Search Player",
        Placeholder = "Enter player name...",
        Callback = function(text)
            warn("Player search for: " .. text)
        end
    })
    playersTab:AddLabel({Text = "All Players"})
    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Name = "PlayerList"
    playerListFrame.Parent = playersTab.Content
    playerListFrame.BackgroundTransparency = 1
    playerListFrame.Size = UDim2.new(1, 0, 0, 300)
    playerListFrame.ScrollBarThickness = 4
    playerListFrame.ScrollBarImageColor3 = Theme.Primary
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    local playerListLayout = Instance.new("UIListLayout")
    playerListLayout.Parent = playerListFrame
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerListLayout.Padding = UDim.new(0, 5)
    playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
    end)
    function Library:SetSize(value)
        CreateTween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, value)}, 0.3)
    end
    return Window
end
return Library
