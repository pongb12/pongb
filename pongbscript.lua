local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Wait for character
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Main GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PongbHub"
gui.ResetOnSpawn = false

-- Settings
local lastCheckpoint = nil
local lang = "vi"
local isMinimized = false
local autoStealActive = false
local autoStealConnection = nil

-- UI Theme
local theme = {
    Background = Color3.fromRGB(40, 40, 45),
    Secondary = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(240, 240, 240),
    Warning = Color3.fromRGB(255, 100, 100),
    Success = Color3.fromRGB(100, 255, 100)
}

-- Helper functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.Parent = parent
    return stroke
end

local function createLabel(parent, text, size, position)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(parent, text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = theme.Accent
    button.TextColor3 = theme.Text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    
    createCorner(button, 5)
    createStroke(button, 1, Color3.fromRGB(20, 20, 25))
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(
            math.floor(theme.Accent.R * 255 + 20),
            math.floor(theme.Accent.G * 255 + 20),
            math.floor(theme.Accent.B * 255 + 20)
        )
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = theme.Accent
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    button.Parent = parent
    return button
end

-- Main window
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = theme.Background
createCorner(main, 10)
createStroke(main, 2, Color3.fromRGB(60, 60, 65))

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = theme.Secondary
createCorner(titleBar, 10, 10, 0, 0)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Text = "PongbHub"
title.TextColor3 = theme.Text
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Padding.Left = UDim.new(0, 10)

-- Minimize button
local toggleBtn = createButton(titleBar, "-", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0.5, -15), function()
    isMinimized = not isMinimized
    if isMinimized then
        content.Visible = false
        tabList.Visible = false
        main.Size = UDim2.new(0, 500, 0, 35)
        toggleBtn.Text = "+"
    else
        content.Visible = true
        tabList.Visible = true
        main.Size = UDim2.new(0, 500, 0, 400)
        toggleBtn.Text = "-"
    end
end)

-- Tab list
local tabList = Instance.new("Frame", main)
tabList.Size = UDim2.new(0, 120, 1, -35)
tabList.Position = UDim2.new(0, 0, 0, 35)
tabList.BackgroundColor3 = theme.Secondary

-- Content area
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -120, 1, -35)
content.Position = UDim2.new(0, 120, 0, 35)
content.BackgroundColor3 = theme.Background
content.BackgroundTransparency = 0.05

-- Tab system
local tabs = {}
local function createTab(name)
    local tab = {}
    
    -- Tab button
    tab.button = createButton(tabList, name, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 5 + (#tabs * 45)), function()
        for _, t in pairs(tabs) do
            t.frame.Visible = false
            t.button.BackgroundColor3 = theme.Secondary
        end
        tab.frame.Visible = true
        tab.button.BackgroundColor3 = theme.Accent
    end)
    
    tab.button.BackgroundColor3 = theme.Secondary
    
    -- Tab content frame
    tab.frame = Instance.new("ScrollingFrame", content)
    tab.frame.Size = UDim2.new(1, 0, 1, 0)
    tab.frame.BackgroundTransparency = 1
    tab.frame.Visible = false
    tab.frame.ScrollBarThickness = 5
    tab.frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    table.insert(tabs, tab)
    return tab
end

-- Create tabs
local stealTab = createTab("Steal")
local miscTab = createTab("Misc")
local settingTab = createTab("Settings")

-- Steal Tab Content
local function addCheckpoint()
    lastCheckpoint = hrp.CFrame
    local notification = Instance.new("TextLabel", stealTab.frame)
    notification.Text = "✓ Checkpoint saved!"
    notification.TextColor3 = theme.Success
    notification.Size = UDim2.new(1, -20, 0, 25)
    notification.Position = UDim2.new(0, 10, 0, 10)
    notification.BackgroundTransparency = 1
    notification.Font = Enum.Font.GothamSemibold
    
    delay(3, function()
        notification:Destroy()
    end)
end

createButton(stealTab.frame, "Save Checkpoint", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 10), addCheckpoint)

createButton(stealTab.frame, "Teleport to Checkpoint", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 55), function()
    if lastCheckpoint then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.CFrame = lastCheckpoint
    else
        local warning = createLabel(stealTab.frame, "No checkpoint saved!", UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, 95))
        warning.TextColor3 = theme.Warning
        
        delay(3, function()
            warning:Destroy()
        end)
    end
end)

local autoStealBtn = createButton(stealTab.frame, "Auto Steal (Speed: 32)", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 100), function()
    autoStealActive = not autoStealActive
    
    if autoStealActive then
        autoStealBtn.Text = "Stop Auto Steal"
        humanoid.WalkSpeed = 32
        
        if autoStealConnection then
            autoStealConnection:Disconnect()
        end
        
        autoStealConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local spawn = workspace:FindFirstChild("SpawnLocation")
            if spawn and humanoid.Health > 0 then
                local tween = TweenService:Create(hrp, TweenInfo.new(5), {
                    CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
                })
                tween:Play()
            end
        end)
    else
        autoStealBtn.Text = "Auto Steal (Speed: 32)"
        humanoid.WalkSpeed = 16
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
    end
end)

createLabel(stealTab.frame, "⚠️ Only use when you have brainrot", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 145)).TextColor3 = theme.Warning

-- Misc Tab Content
createButton(miscTab.frame, "Rejoin Server", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 10), function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

createButton(miscTab.frame, "Server Hop", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 55), function()
    -- This should be replaced with actual server hopping logic
    local fakeId = "00000000000000000000000000000000"
    TeleportService:TeleportToPlaceInstance(109983668079237, fakeId)
end)

local jobInput = Instance.new("TextBox", miscTab.frame)
jobInput.PlaceholderText = "Enter Job ID"
jobInput.Size = UDim2.new(1, -20, 0, 35)
jobInput.Position = UDim2.new(0, 10, 0, 100)
jobInput.BackgroundColor3 = theme.Secondary
jobInput.TextColor3 = theme.Text
jobInput.Font = Enum.Font.Gotham
createCorner(jobInput, 5)
createStroke(jobInput, 1, Color3.fromRGB(60, 60, 65))

createButton(miscTab.frame, "Join Job ID", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 145), function()
    local id = jobInput.Text
    if id and id ~= "" then
        TeleportService:TeleportToPlaceInstance(109983668079237, id)
    end
end)

createButton(miscTab.frame, "Destroy GUI", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 190), function()
    gui:Destroy()
end)

-- Settings Tab Content
createLabel(settingTab.frame, "Language:", UDim2.new(0.5, -10, 0, 25), UDim2.new(0, 10, 0, 10))

local langBtn = createButton(settingTab.frame, "Tiếng Việt / English", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 40), function()
    lang = (lang == "vi") and "en" or "vi"
    langBtn.Text = (lang == "vi") and "Tiếng Việt / English" or "English / Tiếng Việt"
    
    -- Here you would add logic to change all text in the GUI
    -- This is just a placeholder for the functionality
end)

-- Keybind system
createLabel(settingTab.frame, "Keybinds:", UDim2.new(0.5, -10, 0, 25), UDim2.new(0, 10, 0, 90))

local keybinds = {
    {name = "Save Checkpoint", key = Enum.KeyCode.F1, func = addCheckpoint},
    {name = "Toggle GUI", key = Enum.KeyCode.RightShift, func = function()
        gui.Enabled = not gui.Enabled
    end}
}

local keybindFrame = Instance.new("Frame", settingTab.frame)
keybindFrame.Size = UDim2.new(1, -20, 0, 100)
keybindFrame.Position = UDim2.new(0, 10, 0, 120)
keybindFrame.BackgroundColor3 = theme.Secondary
createCorner(keybindFrame, 5)

local keybindLayout = Instance.new("UIListLayout", keybindFrame)
keybindLayout.Padding = UDim.new(0, 5)

for _, bind in ipairs(keybinds) do
    local bindFrame = Instance.new("Frame", keybindFrame)
    bindFrame.Size = UDim2.new(1, -10, 0, 30)
    bindFrame.BackgroundTransparency = 1
    
    createLabel(bindFrame, bind.name, UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    createLabel(bindFrame, bind.key.Name, UDim2.new(0.4, 0, 1, 0), UDim2.new(0.6, 0, 0, 0)).TextXAlignment = Enum.TextXAlignment.Right
    
    -- Set up the actual keybind
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == bind.key then
            bind.func()
        end
    end)
end

-- Initialize first tab
tabs[1].button.BackgroundColor3 = theme.Accent
tabs[1].frame.Visible = true

-- Make window draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
