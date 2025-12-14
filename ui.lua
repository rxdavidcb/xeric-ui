--[[
- Created by fluflu
- used for Xeric Hub
- this UI is free to use for everyone else
]]--
--Xeric UI Library - Compact Edition
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lib = {}
local sg, mf, cf, tc, nh, isMin, tAnim
local isMob = UIS.TouchEnabled and not UIS.MouseEnabled
local oSize = isMob and UDim2.new(0, 450, 0, 600) or UDim2.new(0, 900, 0, 650)
local mSize = UDim2.new(0, 350, 0, 50)
local theme = {
    bg = Color3.fromRGB(15, 15, 15),
    sc = Color3.fromRGB(20, 20, 20),
    tr = Color3.fromRGB(25, 25, 25),
    pr = Color3.fromRGB(255, 0, 0),
    pd = Color3.fromRGB(180, 0, 0),
    tx = Color3.fromRGB(255, 255, 255),
    td = Color3.fromRGB(150, 150, 150),
    su = Color3.fromRGB(0, 255, 0),
    br = Color3.fromRGB(40, 40, 40)
}
local function tw(obj, props, dur, style, dir)
    local ti = TweenInfo.new(dur or .3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TS:Create(obj, ti, props)
    t:Play()
    return t
end
local function rip(obj, x, y)
    local c = Instance.new("Frame")
    c.Parent = obj
    c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    c.BackgroundTransparency = .5
    c.Size = UDim2.new(0, 0, 0, 0)
    c.Position = UDim2.new(0, x, 0, y)
    c.AnchorPoint = Vector2.new(.5, .5)
    c.ZIndex = 10
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
    local sz = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 2
    tw(c, {Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1}, .5)
    task.delay(
        .5,
        function()
            c:Destroy()
        end
    )
end
function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local wName = cfg.Name or "Fluent UI"
    local wIcon = cfg.Icon or nil
    local function animTitle(on)
        if on then
            if tAnim then
                tAnim:Disconnect()
            end
            tAnim =
                RS.Heartbeat:Connect(
                function()
                    local t = (tick() % 1.5) / 1.5 * 2
                    mf.TopBar.Title.TextColor3 = theme.td:Lerp(theme.pr, t <= 1 and t or 2 - t)
                end
            )
        else
            if tAnim then
                tAnim:Disconnect()
                tAnim = nil
            end
            mf.TopBar.Title.TextColor3 = theme.tx
        end
    end
    sg = Instance.new("ScreenGui")
    sg.Name = "Xeric-UI"
    sg.Parent = game.CoreGui
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn = false
    mf = Instance.new("Frame")
    mf.Name = "MainFrame"
    mf.Parent = sg
    mf.BackgroundColor3 = theme.bg
    mf.BorderSizePixel = 0
    mf.Position = UDim2.new(.5, -oSize.X.Offset / 2, .5, -oSize.Y.Offset / 2)
    mf.Size = oSize
    mf.ClipsDescendants = false
    mf.Active = true
    Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 12)
    local sh = Instance.new("ImageLabel")
    sh.Name = "Shadow"
    sh.Parent = mf
    sh.BackgroundTransparency = 1
    sh.Position = UDim2.new(0, -15, 0, -15)
    sh.Size = UDim2.new(1, 30, 1, 30)
    sh.ZIndex = 0
    sh.Image = "rbxassetid://6015897843"
    sh.ImageColor3 = Color3.new(0, 0, 0)
    sh.ImageTransparency = .5
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(49, 49, 450, 450)
    local dragLine = Instance.new("Frame")
    dragLine.Name = "DragLine"
    dragLine.Parent = mf
    dragLine.BackgroundColor3 = theme.sc
    dragLine.BorderSizePixel = 0
    dragLine.Position = UDim2.new(.5, -60, 1, 5)
    dragLine.Size = UDim2.new(0, 120, 0, 8)
    dragLine.ZIndex = 2
    local dlCorner = Instance.new("UICorner")
    dlCorner.CornerRadius = UDim.new(1, 0)
    dlCorner.Parent = dragLine
    tc = Instance.new("Frame")
    tc.Name = "TabContainer"
    tc.Parent = mf
    tc.BackgroundColor3 = theme.sc
    tc.BorderSizePixel = 0
    tc.Position = UDim2.new(0, 10, 0, 70)
    tc.Size = UDim2.new(0, 150, 1, -80)
    Instance.new("UICorner", tc).CornerRadius = UDim.new(0, 10)
    local tList = Instance.new("UIListLayout")
    tList.Parent = tc
    tList.SortOrder = Enum.SortOrder.LayoutOrder
    tList.Padding = UDim.new(0, 8)
    local tPad = Instance.new("UIPadding")
    tPad.Parent = tc
    tPad.PaddingTop = UDim.new(0, 10)
    tPad.PaddingLeft = UDim.new(0, 10)
    tPad.PaddingRight = UDim.new(0, 10)
    cf = Instance.new("Frame")
    cf.Name = "ContentFrame"
    cf.Parent = mf
    cf.BackgroundColor3 = theme.sc
    cf.BorderSizePixel = 0
    cf.Position = UDim2.new(0, 170, 0, 70)
    cf.Size = UDim2.new(1, -180, 1, -80)
    Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 10)
    local tb = Instance.new("Frame")
    tb.Name = "TopBar"
    tb.Parent = mf
    tb.BackgroundColor3 = theme.sc
    tb.BorderSizePixel = 0
    tb.Size = UDim2.new(1, 0, 0, 60)
    tb.Active = true
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 12)
    local tbCover = Instance.new("Frame")
    tbCover.Parent = tb
    tbCover.BackgroundColor3 = theme.sc
    tbCover.BorderSizePixel = 0
    tbCover.Position = UDim2.new(0, 0, 1, -10)
    tbCover.Size = UDim2.new(1, 0, 0, 10)
    local icon
    if wIcon then
        icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Parent = tb
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 15, 0, 15)
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Image = wIcon
        icon.ScaleType = Enum.ScaleType.Fit
    end
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = tb
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, wIcon and 55 or 20, 0, 0)
    title.Size = UDim2.new(1, wIcon and -165 or -130, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = wName
    title.TextColor3 = theme.tx
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextScaled = false
    title.TextWrapped = false
    title.TextTruncate = Enum.TextTruncate.AtEnd
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeButton"
    minBtn.Parent = tb
    minBtn.BackgroundColor3 = theme.tr
    minBtn.BorderSizePixel = 0
    minBtn.Position = UDim2.new(1, -85, .5, -15)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Text = "_"
    minBtn.TextColor3 = theme.tx
    minBtn.TextSize = 14
    minBtn.AutoButtonColor = false
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
    minBtn.MouseButton1Click:Connect(
        function()
            local tSize = isMin and oSize or mSize
            local dx = mf.Size.X.Offset / 2 - tSize.X.Offset / 2
            local dy = mf.Size.Y.Offset / 2 - tSize.Y.Offset / 2
            local np =
                UDim2.new(
                mf.Position.X.Scale,
                mf.Position.X.Offset + dx,
                mf.Position.Y.Scale,
                mf.Position.Y.Offset + dy
            )
            if not isMin then
                cf.Visible = false
                tc.Visible = false
                dragLine.Visible = false
                tw(title, {Size = UDim2.new(1, -130, 1, 0)}, .3)
                tw(mf, {Size = mSize, Position = np}, .3)
                minBtn.Text = "⬜"
                isMin = true
                animTitle(true)
            else
                tw(title, {Size = UDim2.new(1, wIcon and -165 or -130, 1, 0)}, .5)
                tw(mf, {Size = oSize, Position = np}, .5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                task.delay(
                    .5,
                    function()
                        cf.Visible = true
                        tc.Visible = true
                        dragLine.Visible = true
                    end
                )
                minBtn.Text = "_"
                isMin = false
                animTitle(true)
            end
        end
    )
    minBtn.MouseEnter:Connect(
        function()
            tw(minBtn, {BackgroundColor3 = theme.pd}, .2)
        end
    )
    minBtn.MouseLeave:Connect(
        function()
            tw(minBtn, {BackgroundColor3 = theme.tr}, .2)
        end
    )
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = tb
    closeBtn.BackgroundColor3 = theme.pr
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -50, .5, -15)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = theme.tx
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseButton1Click:Connect(
        function()
            tw(mf, {Size = UDim2.new(0, 0, 0, 0)}, .3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(.3)
            sg:Destroy()
        end
    )
    closeBtn.MouseEnter:Connect(
        function()
            tw(closeBtn, {BackgroundColor3 = theme.pd}, .2)
        end
    )
    closeBtn.MouseLeave:Connect(
        function()
            tw(closeBtn, {BackgroundColor3 = theme.pr}, .2)
        end
    )
    nh = Instance.new("Frame")
    nh.Name = "Notifications"
    nh.Parent = sg
    nh.BackgroundTransparency = 1
    nh.Position = UDim2.new(1, -320, 1, -420)
    nh.Size = UDim2.new(0, 300, 0, 400)
    local nList = Instance.new("UIListLayout")
    nList.Parent = nh
    nList.SortOrder = Enum.SortOrder.LayoutOrder
    nList.Padding = UDim.new(0, 10)
    nList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    local drag, dragIn, mouseP, frameP = false
    local function setupDrag(obj)
        obj.InputBegan:Connect(
            function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    drag = true
                    mouseP = inp.Position
                    frameP = mf.Position
                    inp.Changed:Connect(
                        function()
                            if inp.UserInputState == Enum.UserInputState.End then
                                drag = false
                            end
                        end
                    )
                end
            end
        )
        obj.InputChanged:Connect(
            function(inp)
                if
                    inp.UserInputType == Enum.UserInputType.MouseMovement or
                        inp.UserInputType == Enum.UserInputType.Touch
                 then
                    dragIn = inp
                end
            end
        )
    end
    setupDrag(tb)
    setupDrag(mf)
    setupDrag(dragLine)
    UIS.InputChanged:Connect(
        function(inp)
            if inp == dragIn and drag then
                local d = inp.Position - mouseP
                mf.Position = UDim2.new(frameP.X.Scale, frameP.X.Offset + d.X, frameP.Y.Scale, frameP.Y.Offset + d.Y)
            end
        end
    )
    mf.Size = UDim2.new(0, 0, 0, 0)
    mf.AnchorPoint = Vector2.new(.5, .5)
    tw(mf, {Size = oSize}, .5, Enum.EasingStyle.Back)
    animTitle(true)
    local Win = {Tabs = {}, CurrentTab = nil}
    function Win:Notify(c)
        c = c or {}
        local nTitle = c.Title or "Notification"
        local nContent = c.Content or "Notification"
        local nDur = c.Duration or 3
        local nType = c.Type or "Default"
        local n = Instance.new("Frame")
        n.Parent = nh
        n.BackgroundColor3 = theme.tr
        n.BorderSizePixel = 0
        n.Size = UDim2.new(1, 0, 0, 90)
        n.ClipsDescendants = true
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
        local tColors = {
            Default = theme.pr,
            Success = theme.su,
            Warning = Color3.fromRGB(255, 165, 0),
            Error = Color3.fromRGB(255, 0, 0)
        }
        local icons = {Default = "ℹ", Success = "✓", Warning = "⚠", Error = "✗"}
        local barC = tColors[nType] or theme.pr
        local bar = Instance.new("Frame")
        bar.Parent = n
        bar.BackgroundColor3 = barC
        bar.BorderSizePixel = 0
        bar.Size = UDim2.new(0, 6, 1, 0)
        local ico = Instance.new("TextLabel")
        ico.Parent = n
        ico.BackgroundTransparency = 1
        ico.Position = UDim2.new(0, 15, 0, 10)
        ico.Size = UDim2.new(0, 20, 0, 20)
        ico.Font = Enum.Font.GothamBold
        ico.Text = icons[nType] or "ℹ"
        ico.TextColor3 = barC
        ico.TextSize = 14
        ico.TextXAlignment = Enum.TextXAlignment.Center
        local tLbl = Instance.new("TextLabel")
        tLbl.Parent = n
        tLbl.BackgroundTransparency = 1
        tLbl.Position = UDim2.new(0, 40, 0, 10)
        tLbl.Size = UDim2.new(1, -50, 0, 20)
        tLbl.Font = Enum.Font.GothamBold
        tLbl.Text = nTitle
        tLbl.TextColor3 = theme.tx
        tLbl.TextSize = 14
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        local cLbl = Instance.new("TextLabel")
        cLbl.Parent = n
        cLbl.BackgroundTransparency = 1
        cLbl.Position = UDim2.new(0, 40, 0, 35)
        cLbl.Size = UDim2.new(1, -50, 1, -55)
        cLbl.Font = Enum.Font.Gotham
        cLbl.Text = nContent
        cLbl.TextColor3 = theme.td
        cLbl.TextSize = 12
        cLbl.TextXAlignment = Enum.TextXAlignment.Left
        cLbl.TextYAlignment = Enum.TextYAlignment.Top
        cLbl.TextWrapped = true
        local dHolder = Instance.new("Frame")
        dHolder.Parent = n
        dHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        dHolder.BackgroundTransparency = .5
        dHolder.BorderSizePixel = 0
        dHolder.Size = UDim2.new(1, 0, 0, 2)
        dHolder.Position = UDim2.new(0, 0, 1, -2)
        local dFill = Instance.new("Frame")
        dFill.Parent = dHolder
        dFill.BackgroundColor3 = barC
        dFill.BorderSizePixel = 0
        dFill.Size = UDim2.new(1, 0, 1, 0)
        local function dismiss()
            tw(n, {Position = UDim2.new(1, 300, n.Position.Y.Scale, n.Position.Y.Offset)}, .3)
            tw(dFill, {Size = UDim2.new(0, 0, 1, 0)}, .3)
            task.delay(
                .3,
                function()
                    n:Destroy()
                end
            )
        end
        tw(dFill, {Size = UDim2.new(0, 0, 1, 0)}, nDur, Enum.EasingStyle.Linear)
        task.wait()
        n.Position = UDim2.new(1, 300, n.Position.Y.Scale, n.Position.Y.Offset)
        tw(
            n,
            {Position = UDim2.new(0, 0, n.Position.Y.Scale, n.Position.Y.Offset)},
            .4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        )
        task.delay(nDur, dismiss)
    end
    function Win:CreateTab(c)
        c = c or {}
        local tName = c.Name or "Tab"
        local Tab = {Elements = {}, Flags = {}}
        local tBtn = Instance.new("TextButton")
        tBtn.Name = tName
        tBtn.Parent = tc
        tBtn.BackgroundColor3 = theme.tr
        tBtn.BorderSizePixel = 0
        tBtn.Size = UDim2.new(1, 0, 0, 40)
        tBtn.Font = Enum.Font.GothamBold
        tBtn.Text = tName
        tBtn.TextColor3 = theme.td
        tBtn.TextSize = 13
        tBtn.AutoButtonColor = false
        Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 8)
        local tContent = Instance.new("ScrollingFrame")
        tContent.Name = tName .. "Content"
        tContent.Parent = cf
        tContent.BackgroundTransparency = 1
        tContent.BorderSizePixel = 0
        tContent.Size = UDim2.new(1, 0, 1, 0)
        tContent.ScrollBarThickness = 4
        tContent.ScrollBarImageColor3 = theme.pr
        tContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tContent.Visible = false
        local cList = Instance.new("UIListLayout")
        cList.Parent = tContent
        cList.SortOrder = Enum.SortOrder.LayoutOrder
        cList.Padding = UDim.new(0, 10)
        cList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                tContent.CanvasSize = UDim2.new(0, 0, 0, cList.AbsoluteContentSize.Y + 20)
            end
        )
        local cPad = Instance.new("UIPadding")
        cPad.Parent = tContent
        cPad.PaddingTop = UDim.new(0, 15)
        cPad.PaddingLeft = UDim.new(0, 15)
        cPad.PaddingRight = UDim.new(0, 15)
        cPad.PaddingBottom = UDim.new(0, 15)
        tBtn.MouseButton1Click:Connect(
            function()
                rip(tBtn, tBtn.AbsoluteSize.X / 2, tBtn.AbsoluteSize.Y / 2)
                for _, t in pairs(Win.Tabs) do
                    t.Button.BackgroundColor3 = theme.tr
                    t.Button.TextColor3 = theme.td
                    t.Content.Visible = false
                end
                tBtn.BackgroundColor3 = theme.pr
                tBtn.TextColor3 = theme.tx
                tContent.Visible = true
                Win.CurrentTab = Tab
            end
        )
        tBtn.MouseEnter:Connect(
            function()
                if tBtn.BackgroundColor3 ~= theme.pr then
                    tw(tBtn, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                end
            end
        )
        tBtn.MouseLeave:Connect(
            function()
                if tBtn.BackgroundColor3 ~= theme.pr then
                    tw(tBtn, {BackgroundColor3 = theme.tr}, .2)
                end
            end
        )
        Tab.Button = tBtn
        Tab.Content = tContent
        table.insert(Win.Tabs, Tab)
        if #Win.Tabs == 1 then
            tBtn.BackgroundColor3 = theme.pr
            tBtn.TextColor3 = theme.tx
            tContent.Visible = true
            Win.CurrentTab = Tab
        end
        function Tab:AddButton(c)
            c = c or {}
            local btn = Instance.new("TextButton")
            btn.Parent = tContent
            btn.BackgroundColor3 = theme.tr
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Font = Enum.Font.GothamBold
            btn.Text = c.Name or "Button"
            btn.TextColor3 = theme.tx
            btn.TextSize = 13
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            btn.MouseButton1Click:Connect(
                function()
                    rip(btn, btn.AbsoluteSize.X / 2, btn.AbsoluteSize.Y / 2)
                    pcall(
                        c.Callback or function()
                            end
                    )
                end
            )
            btn.MouseEnter:Connect(
                function()
                    tw(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                end
            )
            btn.MouseLeave:Connect(
                function()
                    tw(btn, {BackgroundColor3 = theme.tr}, .2)
                end
            )
            return btn
        end
        function Tab:AddLabel(c)
            c = c or {}
            local lbl = Instance.new("TextLabel")
            lbl.Parent = tContent
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 0, 25)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = c.Text or "Label"
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            return lbl
        end
        function Tab:AddDivider(c)
            c = c or {}
            local dv = Instance.new("Frame")
            dv.Parent = tContent
            dv.BackgroundTransparency = 1
            dv.Size = UDim2.new(1, 0, 0, c.Text and 30 or 20)
            if c.Text then
                local l1 = Instance.new("Frame")
                l1.Parent = dv
                l1.BackgroundColor3 = theme.br
                l1.BorderSizePixel = 0
                l1.Position = UDim2.new(0, 0, .5, -1)
                l1.Size = UDim2.new(.35, -5, 0, 2)
                local lbl = Instance.new("TextLabel")
                lbl.Parent = dv
                lbl.BackgroundTransparency = 1
                lbl.Position = UDim2.new(.35, 0, 0, 0)
                lbl.Size = UDim2.new(.3, 0, 1, 0)
                lbl.Font = Enum.Font.GothamBold
                lbl.Text = c.Text
                lbl.TextColor3 = theme.td
                lbl.TextSize = 12
                lbl.TextXAlignment = Enum.TextXAlignment.Center
                local l2 = Instance.new("Frame")
                l2.Parent = dv
                l2.BackgroundColor3 = theme.br
                l2.BorderSizePixel = 0
                l2.Position = UDim2.new(.65, 5, .5, -1)
                l2.Size = UDim2.new(.35, -5, 0, 2)
            else
                local ln = Instance.new("Frame")
                ln.Parent = dv
                ln.BackgroundColor3 = theme.br
                ln.BorderSizePixel = 0
                ln.Position = UDim2.new(0, 0, .5, -1)
                ln.Size = UDim2.new(1, 0, 0, 2)
            end
            return dv
        end
        function Tab:AddTextInput(c)
            c = c or {}
            local fr = Instance.new("Frame")
            fr.Parent = tContent
            fr.BackgroundColor3 = theme.tr
            fr.BorderSizePixel = 0
            fr.Size = UDim2.new(1, 0, 0, 60)
            Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = fr
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 15, 0, 5)
            lbl.Size = UDim2.new(1, -30, 0, 20)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = c.Name or "Text Input"
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local inp = Instance.new("TextBox")
            inp.Parent = fr
            inp.BackgroundColor3 = theme.bg
            inp.BorderSizePixel = 0
            inp.Position = UDim2.new(0, 15, 0, 30)
            inp.Size = UDim2.new(1, -30, 0, 25)
            inp.Font = Enum.Font.Gotham
            inp.PlaceholderText = c.Placeholder or "Enter text..."
            inp.PlaceholderColor3 = theme.td
            inp.Text = c.Default or ""
            inp.TextColor3 = theme.tx
            inp.TextSize = 12
            inp.TextXAlignment = Enum.TextXAlignment.Left
            inp.ClearTextOnFocus = c.ClearTextOnFocus or false
            inp.ClipsDescendants = true
            Instance.new("UICorner", inp).CornerRadius = UDim.new(0, 6)
            local pd = Instance.new("UIPadding")
            pd.Parent = inp
            pd.PaddingLeft = UDim.new(0, 10)
            pd.PaddingRight = UDim.new(0, 10)
            if c.Flag then
                Tab.Flags[c.Flag] = inp.Text
            end
            inp.Focused:Connect(
                function()
                    tw(inp, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .2)
                end
            )
            inp.FocusLost:Connect(
                function(ent)
                    tw(inp, {BackgroundColor3 = theme.bg}, .2)
                    if ent then
                        if c.Flag then
                            Tab.Flags[c.Flag] = inp.Text
                        end
                        pcall(
                            c.Callback or function()
                                end,
                            inp.Text
                        )
                    end
                end
            )
            inp:GetPropertyChangedSignal("Text"):Connect(
                function()
                    if c.Flag then
                        Tab.Flags[c.Flag] = inp.Text
                    end
                end
            )
            fr.MouseEnter:Connect(
                function()
                    tw(fr, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                end
            )
            fr.MouseLeave:Connect(
                function()
                    tw(fr, {BackgroundColor3 = theme.tr}, .2)
                end
            )
            return {
                Set = function(s, t)
                    inp.Text = t
                    if c.Flag then
                        Tab.Flags[c.Flag] = t
                    end
                end,
                Get = function()
                    return inp.Text
                end
            }
        end
        function Tab:AddToggle(c)
            c = c or {}
            local fr = Instance.new("Frame")
            fr.Parent = tContent
            fr.BackgroundColor3 = theme.tr
            fr.BorderSizePixel = 0
            fr.Size = UDim2.new(1, 0, 0, 40)
            Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = fr
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = c.Name or "Toggle"
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local tBtn = Instance.new("TextButton")
            tBtn.Parent = fr
            tBtn.BackgroundColor3 = c.Default and theme.pr or theme.br
            tBtn.BorderSizePixel = 0
            tBtn.Position = UDim2.new(1, -55, .5, -10)
            tBtn.Size = UDim2.new(0, 45, 0, 20)
            tBtn.Text = ""
            tBtn.AutoButtonColor = false
            Instance.new("UICorner", tBtn).CornerRadius = UDim.new(1, 0)
            local circ = Instance.new("Frame")
            circ.Parent = tBtn
            circ.BackgroundColor3 = theme.tx
            circ.BorderSizePixel = 0
            circ.Position = c.Default and UDim2.new(1, -18, .5, -8) or UDim2.new(0, 2, .5, -8)
            circ.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)
            local val = c.Default or false
            if c.Flag then
                Tab.Flags[c.Flag] = val
            end
            tBtn.MouseButton1Click:Connect(
                function()
                    val = not val
                    tw(tBtn, {BackgroundColor3 = val and theme.pr or theme.br}, .2)
                    tw(circ, {Position = val and UDim2.new(1, -18, .5, -8) or UDim2.new(0, 2, .5, -8)}, .2)
                    if c.Flag then
                        Tab.Flags[c.Flag] = val
                    end
                    pcall(
                        c.Callback or function()
                            end,
                        val
                    )
                end
            )
            fr.MouseEnter:Connect(
                function()
                    tw(fr, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                end
            )
            fr.MouseLeave:Connect(
                function()
                    tw(fr, {BackgroundColor3 = theme.tr}, .2)
                end
            )
            return {
                Set = function(s, v)
                    val = v
                    tBtn.BackgroundColor3 = v and theme.pr or theme.br
                    circ.Position = v and UDim2.new(1, -18, .5, -8) or UDim2.new(0, 2, .5, -8)
                    if c.Flag then
                        Tab.Flags[c.Flag] = v
                    end
                end
            }
        end
        function Tab:AddSlider(c)
            c = c or {}
            local fr = Instance.new("Frame")
            fr.Parent = tContent
            fr.BackgroundColor3 = theme.tr
            fr.BorderSizePixel = 0
            fr.Size = UDim2.new(1, 0, 0, 60)
            Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = fr
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 15, 0, 5)
            lbl.Size = UDim2.new(1, -80, 0, 20)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = c.Name or "Slider"
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local vLbl = Instance.new("TextLabel")
            vLbl.Parent = fr
            vLbl.BackgroundTransparency = 1
            vLbl.Position = UDim2.new(1, -70, 0, 5)
            vLbl.Size = UDim2.new(0, 55, 0, 20)
            vLbl.Font = Enum.Font.GothamBold
            vLbl.Text = tostring(c.Default or 50)
            vLbl.TextColor3 = theme.pr
            vLbl.TextSize = 13
            vLbl.TextXAlignment = Enum.TextXAlignment.Right
            local bar = Instance.new("Frame")
            bar.Parent = fr
            bar.BackgroundColor3 = theme.br
            bar.BorderSizePixel = 0
            bar.Position = UDim2.new(0, 15, 1, -20)
            bar.Size = UDim2.new(1, -30, 0, 6)
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame")
            fill.Parent = bar
            fill.BackgroundColor3 = theme.pr
            fill.BorderSizePixel = 0
            local min, max, def, inc = c.Min or 0, c.Max or 100, c.Default or 50, c.Increment or 1
            local pos = (def - min) / (max - min)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            local sBtn = Instance.new("TextButton")
            sBtn.Parent = bar
            sBtn.BackgroundColor3 = theme.tx
            sBtn.BorderSizePixel = 0
            sBtn.Position = UDim2.new(pos, -6, .5, -6)
            sBtn.Size = UDim2.new(0, 12, 0, 12)
            sBtn.Text = ""
            sBtn.AutoButtonColor = false
            Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)
            local val, drg = def, false
            if c.Flag then
                Tab.Flags[c.Flag] = val
            end
            local function upd(i)
                local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local v = math.floor((min + (max - min) * p) / inc + .5) * inc
                v = math.clamp(v, min, max)
                val = v
                vLbl.Text = tostring(v)
                local fp = (val - min) / (max - min)
                tw(fill, {Size = UDim2.new(fp, 0, 1, 0)}, .1)
                tw(sBtn, {Position = UDim2.new(fp, -6, .5, -6)}, .1)
                if c.Flag then
                    Tab.Flags[c.Flag] = v
                end
                pcall(
                    c.Callback or function()
                        end,
                    v
                )
            end
            sBtn.MouseButton1Down:Connect(
                function()
                    drg = true
                    tw(sBtn, {Size = UDim2.new(0, 16, 0, 16)}, .1)
                end
            )
            UIS.InputEnded:Connect(
                function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        drg = false
                        tw(sBtn, {Size = UDim2.new(0, 12, 0, 12)}, .1)
                    end
                end
            )
            UIS.InputChanged:Connect(
                function(i)
                    if drg and i.UserInputType == Enum.UserInputType.MouseMovement then
                        upd(i)
                    end
                end
            )
            bar.InputBegan:Connect(
                function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        upd(i)
                    end
                end
            )
            return {
                Set = function(s, v)
                    val = math.clamp(v, min, max)
                    vLbl.Text = tostring(val)
                    local p = (val - min) / (max - min)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    sBtn.Position = UDim2.new(p, -6, .5, -6)
                    if c.Flag then
                        Tab.Flags[c.Flag] = v
                    end
                end
            }
        end
        function Tab:AddDropdown(c)
            c = c or {}
            local opts = c.Options or {"Option 1", "Option 2"}
            local def = c.Default or opts[1]
            local fr = Instance.new("Frame")
            fr.Parent = tContent
            fr.BackgroundColor3 = theme.tr
            fr.BorderSizePixel = 0
            fr.Size = UDim2.new(1, 0, 0, 40)
            fr.ClipsDescendants = true
            fr.ZIndex = 5
            Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)
            local btn = Instance.new("TextButton")
            btn.Parent = fr
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Text = ""
            btn.AutoButtonColor = false
            local lbl = Instance.new("TextLabel")
            lbl.Parent = btn
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = (c.Name or "Dropdown") .. ": " .. def
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local arr = Instance.new("TextLabel")
            arr.Parent = btn
            arr.BackgroundTransparency = 1
            arr.Position = UDim2.new(1, -35, 0, 0)
            arr.Size = UDim2.new(0, 20, 1, 0)
            arr.Font = Enum.Font.GothamBold
            arr.Text = "▼"
            arr.TextColor3 = theme.pr
            arr.TextSize = 12
            local lst = Instance.new("ScrollingFrame")
            lst.Parent = fr
            lst.BackgroundColor3 = theme.bg
            lst.BorderSizePixel = 0
            lst.Position = UDim2.new(0, 5, 0, 45)
            lst.Size = UDim2.new(1, -10, 0, 0)
            lst.ScrollBarThickness = 4
            lst.ScrollBarImageColor3 = theme.pr
            lst.CanvasSize = UDim2.new(0, 0, 0, 0)
            lst.Visible = false
            Instance.new("UICorner", lst).CornerRadius = UDim.new(0, 6)
            local ll = Instance.new("UIListLayout")
            ll.Parent = lst
            ll.SortOrder = Enum.SortOrder.LayoutOrder
            ll.Padding = UDim.new(0, 2)
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    lst.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 5)
                end
            )
            local lp = Instance.new("UIPadding")
            lp.Parent = lst
            lp.PaddingTop = UDim.new(0, 5)
            lp.PaddingLeft = UDim.new(0, 5)
            lp.PaddingRight = UDim.new(0, 5)
            lp.PaddingBottom = UDim.new(0, 5)
            local open, val = false, def
            if c.Flag then
                Tab.Flags[c.Flag] = val
            end
            for _, opt in ipairs(opts) do
                local ob = Instance.new("TextButton")
                ob.Parent = lst
                ob.BackgroundColor3 = opt == val and theme.pr or theme.tr
                ob.BorderSizePixel = 0
                ob.Size = UDim2.new(1, 0, 0, 30)
                ob.Font = Enum.Font.Gotham
                ob.Text = opt
                ob.TextColor3 = theme.tx
                ob.TextSize = 12
                ob.AutoButtonColor = false
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)
                ob.MouseButton1Click:Connect(
                    function()
                        val = opt
                        lbl.Text = (c.Name or "Dropdown") .. ": " .. opt
                        for _, b in ipairs(lst:GetChildren()) do
                            if b:IsA("TextButton") then
                                tw(b, {BackgroundColor3 = theme.tr}, .2)
                            end
                        end
                        tw(ob, {BackgroundColor3 = theme.pr}, .2)
                        if c.Flag then
                            Tab.Flags[c.Flag] = opt
                        end
                        pcall(
                            c.Callback or function()
                                end,
                            opt
                        )
                    end
                )
                ob.MouseEnter:Connect(
                    function()
                        if opt ~= val then
                            tw(ob, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                        end
                    end
                )
                ob.MouseLeave:Connect(
                    function()
                        if opt ~= val then
                            tw(ob, {BackgroundColor3 = theme.tr}, .2)
                        end
                    end
                )
            end
            btn.MouseButton1Click:Connect(
                function()
                    open = not open
                    if open then
                        lst.Visible = true
                        local h = math.min(#opts * 32 + 10, 150)
                        tw(fr, {Size = UDim2.new(1, 0, 0, 45 + h)}, .3)
                        tw(lst, {Size = UDim2.new(1, -10, 0, h)}, .3)
                        tw(arr, {Rotation = 180}, .3)
                    else
                        tw(fr, {Size = UDim2.new(1, 0, 0, 40)}, .3)
                        tw(lst, {Size = UDim2.new(1, -10, 0, 0)}, .3)
                        tw(arr, {Rotation = 0}, .3)
                        task.wait(.3)
                        lst.Visible = false
                    end
                end
            )
            return {
                Set = function(s, v)
                    if table.find(opts, v) then
                        val = v
                        lbl.Text = (c.Name or "Dropdown") .. ": " .. v
                        if c.Flag then
                            Tab.Flags[c.Flag] = v
                        end
                    end
                end
            }
        end
        function Tab:AddMultiDropdown(c)
            c = c or {}
            local opts = c.Options or {"Option 1", "Option 2"}
            local def = c.Default or {}
            local fr = Instance.new("Frame")
            fr.Parent = tContent
            fr.BackgroundColor3 = theme.tr
            fr.BorderSizePixel = 0
            fr.Size = UDim2.new(1, 0, 0, 40)
            fr.ClipsDescendants = true
            fr.ZIndex = 5
            Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)
            local btn = Instance.new("TextButton")
            btn.Parent = fr
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Text = ""
            btn.AutoButtonColor = false
            local lbl = Instance.new("TextLabel")
            lbl.Parent = btn
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = (c.Name or "Multi") .. ": " .. (#def > 0 and table.concat(def, ", ") or "None")
            lbl.TextColor3 = theme.tx
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            local arr = Instance.new("TextLabel")
            arr.Parent = btn
            arr.BackgroundTransparency = 1
            arr.Position = UDim2.new(1, -35, 0, 0)
            arr.Size = UDim2.new(0, 20, 1, 0)
            arr.Font = Enum.Font.GothamBold
            arr.Text = "▼"
            arr.TextColor3 = theme.pr
            arr.TextSize = 12
            local lst = Instance.new("ScrollingFrame")
            lst.Parent = fr
            lst.BackgroundColor3 = theme.bg
            lst.BorderSizePixel = 0
            lst.Position = UDim2.new(0, 5, 0, 45)
            lst.Size = UDim2.new(1, -10, 0, 0)
            lst.ScrollBarThickness = 4
            lst.ScrollBarImageColor3 = theme.pr
            lst.CanvasSize = UDim2.new(0, 0, 0, 0)
            lst.Visible = false
            Instance.new("UICorner", lst).CornerRadius = UDim.new(0, 6)
            local ll = Instance.new("UIListLayout")
            ll.Parent = lst
            ll.SortOrder = Enum.SortOrder.LayoutOrder
            ll.Padding = UDim.new(0, 2)
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    lst.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 5)
                end
            )
            local lp = Instance.new("UIPadding")
            lp.Parent = lst
            lp.PaddingTop = UDim.new(0, 5)
            lp.PaddingLeft = UDim.new(0, 5)
            lp.PaddingRight = UDim.new(0, 5)
            lp.PaddingBottom = UDim.new(0, 5)
            local open, sel = false, {}
            for _, v in ipairs(def) do
                sel[v] = true
            end
            if c.Flag then
                Tab.Flags[c.Flag] = def
            end
            local function updLbl()
                local s = {}
                for o, i in pairs(sel) do
                    if i then
                        table.insert(s, o)
                    end
                end
                lbl.Text = (c.Name or "Multi") .. ": " .. (#s > 0 and table.concat(s, ", ") or "None")
                if c.Flag then
                    Tab.Flags[c.Flag] = s
                end
            end
            for _, opt in ipairs(opts) do
                local of = Instance.new("Frame")
                of.Parent = lst
                of.BackgroundColor3 = theme.tr
                of.BorderSizePixel = 0
                of.Size = UDim2.new(1, 0, 0, 30)
                Instance.new("UICorner", of).CornerRadius = UDim.new(0, 6)
                local ol = Instance.new("TextLabel")
                ol.Parent = of
                ol.BackgroundTransparency = 1
                ol.Position = UDim2.new(0, 10, 0, 0)
                ol.Size = UDim2.new(1, -40, 1, 0)
                ol.Font = Enum.Font.Gotham
                ol.Text = opt
                ol.TextColor3 = theme.tx
                ol.TextSize = 12
                ol.TextXAlignment = Enum.TextXAlignment.Left
                local cb = Instance.new("Frame")
                cb.Parent = of
                cb.BackgroundColor3 = sel[opt] and theme.pr or theme.br
                cb.BorderSizePixel = 0
                cb.Position = UDim2.new(1, -25, .5, -8)
                cb.Size = UDim2.new(0, 16, 0, 16)
                Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 4)
                local cm = Instance.new("TextLabel")
                cm.Parent = cb
                cm.BackgroundTransparency = 1
                cm.Size = UDim2.new(1, 0, 1, 0)
                cm.Font = Enum.Font.GothamBold
                cm.Text = sel[opt] and "✓" or ""
                cm.TextColor3 = theme.tx
                cm.TextSize = 12
                local ob = Instance.new("TextButton")
                ob.Parent = of
                ob.BackgroundTransparency = 1
                ob.Size = UDim2.new(1, 0, 1, 0)
                ob.Text = ""
                ob.AutoButtonColor = false
                ob.MouseButton1Click:Connect(
                    function()
                        sel[opt] = not sel[opt]
                        tw(cb, {BackgroundColor3 = sel[opt] and theme.pr or theme.br}, .2)
                        cm.Text = sel[opt] and "✓" or ""
                        updLbl()
                        local s = {}
                        for o, i in pairs(sel) do
                            if i then
                                table.insert(s, o)
                            end
                        end
                        pcall(
                            c.Callback or function()
                                end,
                            s
                        )
                    end
                )
                of.MouseEnter:Connect(
                    function()
                        tw(of, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, .2)
                    end
                )
                of.MouseLeave:Connect(
                    function()
                        tw(of, {BackgroundColor3 = theme.tr}, .2)
                    end
                )
            end
            btn.MouseButton1Click:Connect(
                function()
                    open = not open
                    if open then
                        lst.Visible = true
                        local h = math.min(#opts * 32 + 10, 150)
                        tw(fr, {Size = UDim2.new(1, 0, 0, 45 + h)}, .3)
                        tw(lst, {Size = UDim2.new(1, -10, 0, h)}, .3)
                        tw(arr, {Rotation = 180}, .3)
                    else
                        tw(fr, {Size = UDim2.new(1, 0, 0, 40)}, .3)
                        tw(lst, {Size = UDim2.new(1, -10, 0, 0)}, .3)
                        tw(arr, {Rotation = 0}, .3)
                        task.wait(.3)
                        lst.Visible = false
                    end
                end
            )
            return {
                Set = function(s, v)
                    sel = {}
                    for _, i in ipairs(v) do
                        sel[i] = true
                    end
                    updLbl()
                end
            }
        end
        return Tab
    end
    return Win
end
return Lib
