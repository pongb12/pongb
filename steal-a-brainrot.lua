--PongbHub -
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PongbHub_"..HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false

-- === Language Settings ===
local lang = "vi"
local texts = {
    vi = {
        Title = "PongbHub",
        AutoSteal = "Tự động Steal",
        Rejoin = "Vào lại server",
        Hop = "Đổi server",
        Join = "Vào Job ID",
        DeleteGUI = "Xoá GUI",
        WalkSpeed = "Tốc độ di chuyển",
        NoClip = "Xuyên tường",
        CurrentSpeed = "Tốc độ hiện tại: ",
        SetSpeed = "Áp dụng tốc độ",
        SpeedUpdated = "Đã đặt tốc độ: ",
        ActiveFeature = "TÍNH NĂNG ĐANG BẬT: ",
        AutoStealComplete = "Steal hoàn thành!",
        Misc = "Khác",
        Settings = "Cài đặt",
        Language = "Ngôn ngữ",
        Theme = "Giao diện",
        MinimizeGUI = "Thu nhỏ GUI",
        MaximizeGUI = "Phóng to GUI",
        ESPPlayer = "ESP Người chơi",
        ESPBase = "ESP Base",
        AntiKick = "Chống Kick",
        AntiRagdoll = "Chống Ragdoll",
        EnterJobID = "Nhập Job ID:",
        JoinJob = "Vào Job",
        InfinityJump = "Nhảy vô hạn",
        StealButton = "STEAL",
        LockTime = "Thời gian khóa: ",
        PlayerName = "",
        MyBase = "Base của bạn",
        OtherBase = "Base khác",
        NoCheckpoint = "Không tìm thấy checkpoint!",
        CheckpointSaved = "Đã lưu checkpoint!"
    },
    en = {
        Title = "PongbHub",
        AutoSteal = "Auto Steal",
        Rejoin = "Rejoin Server",
        Hop = "Server Hop",
        Join = "Join Job ID",
        DeleteGUI = "Delete GUI",
        WalkSpeed = "Walk Speed",
        NoClip = "NoClip",
        CurrentSpeed = "Current speed: ",
        SetSpeed = "Set Speed",
        SpeedUpdated = "Speed set to: ",
        ActiveFeature = "ACTIVE FEATURE: ",
        AutoStealComplete = "Steal complete!",
        Misc = "Misc",
        Settings = "Settings",
        Language = "Language",
        Theme = "Theme",
        MinimizeGUI = "Minimize GUI",
        MaximizeGUI = "Maximize GUI",
        ESPPlayer = "ESP Players",
        ESPBase = "ESP Bases",
        AntiKick = "Anti-Kick",
        AntiRagdoll = "Anti-Ragdoll",
        EnterJobID = "Enter Job ID:",
        JoinJob = "Join Job",
        InfinityJump = "Infinity Jump",
        StealButton = "STEAL",
        LockTime = "Lock time: ",
        PlayerName = "",
        MyBase = "Your Base",
        OtherBase = "Other Base",
        NoCheckpoint = "Checkpoint not found!",
        CheckpointSaved = "Checkpoint saved!"
    }
}

-- === Global Variables ===
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local isGUIMaximized = true
local isGUIMinimized = false
local flySpeed = 45
local gameId = 109983668079237
local espPlayerActive = false
local espBaseActive = false
local antiKickActive = false
local antiRagdollActive = false
local nameChangeInterval = 300
local lastNameChange = 0
local playerHighlights = {}
local baseHighlights = {}
local infinityJumpEnabled = false
local isJumping = false
local checkpointPosition = nil
local antiRagdollConnection = nil

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 180, 0, 230)
local maximizedGUISize = UDim2.new(0, 350, 0, 370)
local minimizedGUISize = UDim2.new(0, 150, 0, 30)

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = maximizedGUISize
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
main.Visible = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(80, 80, 80)

-- Title Bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Name = "TitleBar"

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Minimize/Maximize/Close Buttons
local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2)
closeButton.Text = "X"
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.ZIndex = 2

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 4)

local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 2)
minimizeButton.Text = "─"
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.ZIndex = 2

local minimizeCorner = Instance.new("UICorner", minimizeButton)
minimizeCorner.CornerRadius = UDim.new(0, 4)

local maximizeButton = Instance.new("TextButton", titleBar)
maximizeButton.Size = UDim2.new(0, 25, 0, 25)
maximizeButton.Position = UDim2.new(1, -90, 0, 2)
maximizeButton.Text = "►"
maximizeButton.TextSize = 16
maximizeButton.Font = Enum.Font.GothamBold
maximizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
maximizeButton.TextColor3 = Color3.new(1, 1, 1)
maximizeButton.Visible = false
maximizeButton.ZIndex = 2

local maximizeCorner = Instance.new("UICorner", maximizeButton)
maximizeCorner.CornerRadius = UDim.new(0, 4)

-- Content Frame
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 1000)

-- Tab System
local tabContainer = Instance.new("Frame", content)
tabContainer.Size = UDim2.new(1, -10, 0, 30)
tabContainer.Position = UDim2.new(0, 5, 0, 5)
tabContainer.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 2)

-- Tab Contents
local mainTab = Instance.new("Frame", content)
mainTab.Size = UDim2.new(1, -10, 0, 500)
mainTab.Position = UDim2.new(0, 5, 0, 40)
mainTab.BackgroundTransparency = 1
mainTab.Visible = true

local miscTab = Instance.new("Frame", content)
miscTab.Size = UDim2.new(1, -10, 0, 400)
miscTab.Position = UDim2.new(0, 5, 0, 40)
miscTab.BackgroundTransparency = 1
miscTab.Visible = false

local settingsTab = Instance.new("Frame", content)
settingsTab.Size = UDim2.new(1, -10, 0, 200)
settingsTab.Position = UDim2.new(0, 5, 0, 40)
settingsTab.BackgroundTransparency = 1
settingsTab.Visible = false

-- Function to update all GUI text elements when language changes
local function updateLanguage()
    -- Update title
    title.Text = texts[lang].Title
    
    -- Update tab buttons
    for _, child in pairs(tabContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Text == texts["vi"].Title or child.Text == texts["en"].Title then
                child.Text = texts[lang].Title
            elseif child.Text == texts["vi"].Misc or child.Text == texts["en"].Misc then
                child.Text = texts[lang].Misc
            elseif child.Text == texts["vi"].Settings or child.Text == texts["en"].Settings then
                child.Text = texts[lang].Settings
            end
        end
    end
    
    -- Update buttons and labels
    for _, frame in pairs({mainTab, miscTab, settingsTab}) do
        for _, child in pairs(frame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                for key, value in pairs(texts[lang]) do
                    if child.Text == texts["vi"][key] or child.Text == texts["en"][key] then
                        child.Text = value
                        break
                    end
                end
            end
        end
    end
end

-- Function to create tab buttons
local function createTab(name, targetFrame, posX)
    local tab = Instance.new("TextButton", tabContainer)
    tab.Size = UDim2.new(0, 80, 0, 30)
    tab.Text = texts[lang][name] or name
    tab.TextSize = 12
    tab.Font = Enum.Font.Gotham
    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tab.TextColor3 = Color3.new(1, 1, 1)
    
    local tabCorner = Instance.new("UICorner", tab)
    tabCorner.CornerRadius = UDim.new(0, 4)
    
    tab.MouseButton1Click:Connect(function()
        -- Hide all tabs
        mainTab.Visible = false
        miscTab.Visible = false
        settingsTab.Visible = false
        
        -- Show selected tab
        targetFrame.Visible = true
        
        -- Update tab colors
        for _, child in pairs(tabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
        tab.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
    end)
    
    return tab
end

-- Create tabs
local mainTabBtn = createTab("Title", mainTab, 0)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
local miscTabBtn = createTab("Misc", miscTab, 1)
local settingsTabBtn = createTab("Settings", settingsTab, 2)

-- === Server Hopping Function ===
local function serverHop()
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=8"))
    end)
    
    if success and servers.data then
        local availableServers = {}
        for _, server in pairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(availableServers, server.id)
            end
        end
        
        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            TeleportService:TeleportToPlaceInstance(gameId, randomServer)
        else
            TeleportService:Teleport(gameId)
        end
    else
        TeleportService:Teleport(gameId)
    end
end

-- === Improved Auto Steal Function (Checkpoint System) ===
local function saveCheckpoint()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        checkpointPosition = player.Character.HumanoidRootPart.Position
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CheckpointSaved,
            Duration = 2
        })
    end
end

local function flyToCheckpoint()
    if not checkpointPosition then
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].NoCheckpoint,
            Duration = 2
        })
        return false
    end

    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end

    humanoid.PlatformStand = true
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)

    local startTime = tick()
    local distance = (hrp.Position - checkpointPosition).Magnitude

    while autoStealActive and (tick() - startTime < distance / flySpeed * 1.5) do
        if not player.Character or not hrp or not bodyVelocity then break end

        local direction = (checkpointPosition - hrp.Position).Unit
        bodyVelocity.Velocity = direction * flySpeed

        local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -3, 0))
        
        if ray then
             bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, math.min(0, bodyVelocity.Velocity.Y), bodyVelocity.Velocity.Z)
        else 
             bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, -5, bodyVelocity.Velocity.Z)
        end

        RunService.Heartbeat:Wait()
    end

    if bodyVelocity then bodyVelocity:Destroy() end
    if humanoid then humanoid.PlatformStand = false end

    if autoStealActive then
        autoStealActive = false
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].AutoStealComplete,
            Duration = 2
        })
    end
    
    return true
end

-- === Steal Button GUI ===
local stealGui = Instance.new("ScreenGui", CoreGui)
stealGui.Name = "StealButtonGUI"
stealGui.ResetOnSpawn = false

local stealButton = Instance.new("TextButton", stealGui)
stealButton.Size = UDim2.new(0, 100, 0, 40)
stealButton.Position = UDim2.new(1, -120, 0.5, -20)
stealButton.AnchorPoint = Vector2.new(1, 0.5)
stealButton.Text = texts[lang].StealButton
stealButton.TextSize = 14
stealButton.Font = Enum.Font.GothamBold
stealButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealButton.TextColor3 = Color3.new(1, 1, 1)
stealButton.Visible = false

local stealButtonCorner = Instance.new("UICorner", stealButton)
stealButtonCorner.CornerRadius = UDim.new(0, 8)

stealButton.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    if autoStealActive then
        stealButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        flyToCheckpoint()
    else
        stealButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- === Anti-Detection NoClip Function ===
local noClipConnection = nil

local function improvedNoClip()
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    
    if noClipActive then
        noClipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
                
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CanCollide = false
                    wait(0.01)
                    if hrp then
                        hrp.CanCollide = true
                    end
                end
            end
        end)
    end
end

-- === Anti-Ragdoll Function ===
local function toggleAntiRagdoll(active)
    antiRagdollActive = active
    
    if antiRagdollConnection then
        antiRagdollConnection:Disconnect()
        antiRagdollConnection = nil
    end
    
    if active then
        antiRagdollConnection = player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end)
        
        -- Apply to current character if exists
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.StateChanged:Connect(function(_, newState)
                    if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end
        end
    end
end

-- === Improved ESP Player Function ===
local function createPlayerHighlight(plr)
    if plr == player then return end
    
    local character = plr.Character
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_"..plr.Name
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    -- Create name label
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name_"..plr.Name
    billboard.Adornee = character:WaitForChild("Head") or character:WaitForChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.Name -- Chỉ hiển thị tên
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    playerHighlights[plr] = {highlight = highlight, label = billboard}
    
    -- Handle character changes
    plr.CharacterAdded:Connect(function(newChar)
        if playerHighlights[plr] then
            playerHighlights[plr].highlight:Destroy()
            playerHighlights[plr].label:Destroy()
        end
        
        local newHighlight = Instance.new("Highlight")
        newHighlight.Name = "ESP_"..plr.Name
        newHighlight.Adornee = newChar
        newHighlight.FillColor = Color3.fromRGB(255, 0, 0)
        newHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        newHighlight.FillTransparency = 0.5
        newHighlight.OutlineTransparency = 0
        newHighlight.Parent = newChar
        
        local newBillboard = Instance.new("BillboardGui")
        newBillboard.Name = "ESP_Name_"..plr.Name
        newBillboard.Adornee = newChar:WaitForChild("Head") or newChar:WaitForChild("HumanoidRootPart")
        newBillboard.Size = UDim2.new(0, 200, 0, 50)
        newBillboard.StudsOffset = Vector3.new(0, 3, 0)
        newBillboard.AlwaysOnTop = true
        newBillboard.Parent = newChar
        
        local newLabel = Instance.new("TextLabel", newBillboard)
        newLabel.Size = UDim2.new(1, 0, 1, 0)
        newLabel.BackgroundTransparency = 1
        newLabel.Text = plr.Name
        newLabel.TextColor3 = Color3.new(1, 1, 1)
        newLabel.TextScaled = true
        newLabel.Font = Enum.Font.GothamBold
        
        playerHighlights[plr] = {highlight = newHighlight, label = newBillboard}
    end)
end

local function toggleESPPlayers(active)
    espPlayerActive = active
    
    if active then
        -- Clear existing highlights
        for _, highlightData in pairs(playerHighlights) do
            highlightData.highlight:Destroy()
            highlightData.label:Destroy()
        end
        playerHighlights = {}
        
        -- Create highlights for existing players
        for _, plr in pairs(Players:GetPlayers()) do
            createPlayerHighlight(plr)
        end
        
        -- Connect to new players
        Players.PlayerAdded:Connect(function(plr)
            createPlayerHighlight(plr)
        end)
        
        -- Remove highlights when players leave
        Players.PlayerRemoving:Connect(function(plr)
            if playerHighlights[plr] then
                playerHighlights[plr].highlight:Destroy()
                playerHighlights[plr].label:Destroy()
                playerHighlights[plr] = nil
            end
        end)
    else
        -- Remove all highlights
        for _, highlightData in pairs(playerHighlights) do
            highlightData.highlight:Destroy()
            highlightData.label:Destroy()
        end
        playerHighlights = {}
    end
end

-- === Improved ESP Base Function ===
local function getLockTime(plot)
    local lockTimeValue = plot:FindFirstChild("LockTime")
    if lockTimeValue then
        return lockTimeValue.Value
    end
    return 0
end

local function getOwner(plot)
    local purchases = plot:FindFirstChild("Purchases")
    if purchases then
        for _, purchase in pairs(purchases:GetChildren()) do
            if purchase:FindFirstChild("Owner") then
                return purchase.Owner.Value
            end
        end
    end
    return nil
end

local function createBaseHighlight(plot)
    if not plot then return end
    
    local owner = getOwner(plot)
    local isPlayerPlot = owner == player
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Base_"..plot.Name
    highlight.Adornee = plot
    highlight.FillColor = isPlayerPlot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = plot
    
    -- Create label for the base with lock time
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label_"..plot.Name
    billboard.Adornee = plot
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = plot
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = (isPlayerPlot and texts[lang].MyBase or texts[lang].OtherBase).."\n"..texts[lang].LockTime..getLockTime(plot)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    -- Update lock time periodically
    local updateConnection
    updateConnection = RunService.Heartbeat:Connect(function()
        if not plot or not plot.Parent then
            updateConnection:Disconnect()
            return
        end
        label.Text = (isPlayerPlot and texts[lang].MyBase or texts[lang].OtherBase).."\n"..texts[lang].LockTime..getLockTime(plot)
    end)
    
    baseHighlights[plot] = {highlight = highlight, label = billboard, connection = updateConnection}
end

local function toggleESPBases(active)
    espBaseActive = active
    
    if active then
        -- Clear existing highlights
        for _, highlightData in pairs(baseHighlights) do
            if highlightData.connection then
                highlightData.connection:Disconnect()
            end
            highlightData.highlight:Destroy()
            highlightData.label:Destroy()
        end
        baseHighlights = {}
        
        -- Find and highlight all plots
        local plotsFolder = workspace:FindFirstChild("Plots")
        if plotsFolder then
            for _, plot in pairs(plotsFolder:GetChildren()) do
                if plot:IsA("BasePart") or plot:IsA("Model") then
                    createBaseHighlight(plot)
                end
            end
            
            -- Connect to new plots being added
            plotsFolder.ChildAdded:Connect(function(child)
                if child:IsA("BasePart") or child:IsA("Model") then
                    createBaseHighlight(child)
                end
            end)
        end
    else
        -- Remove all highlights
        for _, highlightData in pairs(baseHighlights) do
            if highlightData.connection then
                highlightData.connection:Disconnect()
            end
            highlightData.highlight:Destroy()
            highlightData.label:Destroy()
        end
        baseHighlights = {}
    end
end

-- === Infinity Jump Function ===
local function toggleInfinityJump(active)
    infinityJumpEnabled = active
    
    if active then
        UserInputService.JumpRequest:Connect(function()
            if infinityJumpEnabled and not isJumping then
                isJumping = true
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                wait(0.1)
                isJumping = false
            end
        end)
    end
end

-- === Anti-Kick Protection ===
local function changeGUIName()
    local randomName = "PongbHub_"..HttpService:GenerateGUID(false)
    gui.Name = randomName
    stealGui.Name = "StealButton_"..HttpService:GenerateGUID(false)
    lastNameChange = tick()
end

local function toggleAntiKick(active)
    antiKickActive = active
    
    if active then
        -- Change name immediately
        changeGUIName()
        
        -- Set up name change loop
        spawn(function()
            while antiKickActive do
                if tick() - lastNameChange >= nameChangeInterval then
                    changeGUIName()
                end
                wait(1)
            end
        end)
        
        -- Prevent remote event kicks
        for _, v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "FireServer") then
                local oldFireServer = v.FireServer
                rawset(v, "FireServer", function(_, ...)
                    if antiKickActive then
                        return nil
                    else
                        return oldFireServer(_, ...)
                    end
                end)
            end
        end
        
        -- Hook core kick function
        local oldKick = player.Kick
        player.Kick = function(_, reason)
            if antiKickActive then
                warn("Anti-Kick: Prevented kick with reason:", reason)
                return nil
            else
                return oldKick(_, reason)
            end
        end
        
        -- Hook core message function
        local oldMessage = player.DisplaySystemMessage
        player.DisplaySystemMessage = function(_, message, ...)
            if antiKickActive and message:lower():find("kick") then
                warn("Anti-Kick: Prevented system message:", message)
                return nil
            else
                return oldMessage(_, message, ...)
            end
        end
    else
        -- Restore original functions if possible
        if player.Kick and player.Kick ~= oldKick then
            player.Kick = oldKick
        end
        if player.DisplaySystemMessage and player.DisplaySystemMessage ~= oldMessage then
            player.DisplaySystemMessage = oldMessage
        end
    end
end

-- === Join Job ID Function ===
local function setupJoinJobUI(parent)
    local jobIdLabel = Instance.new("TextLabel", parent)
    jobIdLabel.Size = UDim2.new(1, -10, 0, 20)
    jobIdLabel.Position = UDim2.new(0, 5, 0, 120)
    jobIdLabel.Text = texts[lang].EnterJobID
    jobIdLabel.TextSize = 14
    jobIdLabel.Font = Enum.Font.Gotham
    jobIdLabel.BackgroundTransparency = 1
    jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
    jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local jobIdBox = Instance.new("TextBox", parent)
    jobIdBox.Size = UDim2.new(0.6, -5, 0, 30)
    jobIdBox.Position = UDim2.new(0, 5, 0, 145)
    jobIdBox.PlaceholderText = "Job ID"
    jobIdBox.Text = ""
    jobIdBox.TextSize = 14
    jobIdBox.Font = Enum.Font.Gotham
    jobIdBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jobIdBox.TextColor3 = Color3.new(1, 1, 1)
    
    local jobIdCorner = Instance.new("UICorner", jobIdBox)
    jobIdCorner.CornerRadius = UDim.new(0, 4)
    
    local joinJobBtn = Instance.new("TextButton", parent)
    joinJobBtn.Size = UDim2.new(0.4, -10, 0, 30)
    joinJobBtn.Position = UDim2.new(0.6, 5, 0, 145)
    joinJobBtn.Text = texts[lang].JoinJob
    joinJobBtn.TextSize = 14
    joinJobBtn.Font = Enum.Font.Gotham
    joinJobBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    joinJobBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local joinJobCorner = Instance.new("UICorner", joinJobBtn)
    joinJobCorner.CornerRadius = UDim.new(0, 4)
    
    joinJobBtn.MouseButton1Click:Connect(function()
        local jobId = jobIdBox.Text
        if jobId and jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(gameId, jobId)
        end
    end)
end

-- === Create Buttons ===
local function createButton(name, posY, callback, isToggle, parent)
    parent = parent or mainTab
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.Text = texts[lang][name] or name
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)

    if isToggle then
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            callback(active)
            btn.BackgroundColor3 = active and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(60, 60, 60)
            if name == "AutoSteal" then
                stealButton.Visible = active
            end
        end)
    else
        btn.MouseButton1Click:Connect(callback)
    end

    return btn
end

-- Main Tab Buttons
createButton("AutoSteal", 0, function(active)
    autoStealActive = active
    if active then
        if not checkpointPosition then
            saveCheckpoint()
        end
        flyToCheckpoint()
    end
end, true, mainTab)

createButton("InfinityJump", 40, toggleInfinityJump, true, mainTab)

createButton("NoClip", 80, function(active)
    noClipActive = active
    improvedNoClip()
end, true, mainTab)

-- Speed Control
local speedLabel = Instance.new("TextLabel", mainTab)
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 120)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("TextBox", mainTab)
speedSlider.Size = UDim2.new(0.6, -5, 0, 30)
speedSlider.Position = UDim2.new(0, 5, 0, 140)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-10000"
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)

local speedSliderCorner = Instance.new("UICorner", speedSlider)
speedSliderCorner.CornerRadius = UDim.new(0, 4)

local speedBtn = createButton("SetSpeed", 140, function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 10000 then
        walkSpeed = newSpeed
        speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].SpeedUpdated..walkSpeed,
            Duration = 2
        })
    end
end, false, mainTab)
speedBtn.Size = UDim2.new(0.4, -10, 0, 30)
speedBtn.Position = UDim2.new(0.6, 5, 0, 140)

-- Misc Tab Content
createButton("Rejoin", 0, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end, false, miscTab)

createButton("Hop", 40, function()
    serverHop()
end, false, miscTab)

createButton("DeleteGUI", 80, function()
    gui:Destroy()
    stealGui:Destroy()
end, false, miscTab)

-- ESP Player Button
createButton("ESPPlayer", 120, toggleESPPlayers, true, miscTab)

-- ESP Base Button
createButton("ESPBase", 160, toggleESPBases, true, miscTab)

-- Anti-Ragdoll Button
createButton("AntiRagdoll", 200, toggleAntiRagdoll, true, miscTab)

-- Join Job ID UI
setupJoinJobUI(settingsTab)

-- Settings Tab Content
local langLabel = Instance.new("TextLabel", settingsTab)
langLabel.Size = UDim2.new(1, -10, 0, 20)
langLabel.Position = UDim2.new(0, 5, 0, 0)
langLabel.Text = texts[lang].Language..": "..string.upper(lang)
langLabel.TextSize = 14
langLabel.Font = Enum.Font.Gotham
langLabel.BackgroundTransparency = 1
langLabel.TextColor3 = Color3.new(1, 1, 1)
langLabel.TextXAlignment = Enum.TextXAlignment.Left

local langToggle = Instance.new("TextButton", settingsTab)
langToggle.Size = UDim2.new(0, 80, 0, 30)
langToggle.Position = UDim2.new(0, 5, 0, 25)
langToggle.Text = "VI/EN"
langToggle.TextSize = 14
langToggle.Font = Enum.Font.Gotham
langToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
langToggle.TextColor3 = Color3.new(1, 1, 1)

local langToggleCorner = Instance.new("UICorner", langToggle)
langToggleCorner.CornerRadius = UDim.new(0, 4)

langToggle.MouseButton1Click:Connect(function()
    lang = (lang == "vi") and "en" or "vi"
    updateLanguage()
    langLabel.Text = texts[lang].Language..": "..string.upper(lang)
    stealButton.Text = texts[lang].StealButton
end)

-- Anti-Kick Button
createButton("AntiKick", 60, toggleAntiKick, true, settingsTab)

-- GUI Toggle Functions
local function toggleGUI()
    isGUIMaximized = not isGUIMaximized
    local targetSize = isGUIMaximized and maximizedGUISize or originalGUISize
    local tween = TweenService:Create(main, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
end

local function minimizeGUI()
    isGUIMinimized = true
    content.Visible = false
    main.Size = minimizedGUISize
    minimizeButton.Visible = false
    maximizeButton.Visible = true
    closeButton.Position = UDim2.new(1, -30, 0, 2)
end

local function maximizeGUI()
    isGUIMinimized = false
    content.Visible = true
    main.Size = isGUIMaximized and maximizedGUISize or originalGUISize
    minimizeButton.Visible = true
    maximizeButton.Visible = false
    closeButton.Position = UDim2.new(1, -30, 0, 2)
end

minimizeButton.MouseButton1Click:Connect(minimizeGUI)
maximizeButton.MouseButton1Click:Connect(maximizeGUI)
closeButton.MouseButton1Click:Connect(function()
    minimizeGUI()
    wait(0.1)
    gui:Destroy()
    stealGui:Destroy()
end)

-- F1 Toggle for GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    end
end)

-- GUI Dragging
local dragging = false
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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    wait(1)
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = walkSpeed
    end
    
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    
    -- Lưu checkpoint khi spawn
    if character and character:FindFirstChild("HumanoidRootPart") then
        saveCheckpoint()
    end
    
    -- Áp dụng anti-ragdoll nếu đang bật
    if antiRagdollActive then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end)

-- === Circle GUI ===
local circleGui = Instance.new("ScreenGui", CoreGui)
circleGui.Name = "CircleGUI_"..HttpService:GenerateGUID(false)
circleGui.ResetOnSpawn = false

local circleButton = Instance.new("TextButton", circleGui)
circleButton.Size = UDim2.new(0, 60, 0, 60)
circleButton.Position = UDim2.new(0, 100, 0, 100)
circleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
circleButton.Text = "F1"
circleButton.TextColor3 = Color3.new(1,1,1)
circleButton.Font = Enum.Font.GothamBold
circleButton.TextScaled = true
circleButton.BorderSizePixel = 0

local circleCorner = Instance.new("UICorner", circleButton)
circleCorner.CornerRadius = UDim.new(1, 0)

-- Close button for circle GUI
local circleCloseButton = Instance.new("TextButton", circleButton)
circleCloseButton.Size = UDim2.new(0, 20, 0, 20)
circleCloseButton.Position = UDim2.new(1, -15, 0, -5)
circleCloseButton.AnchorPoint = Vector2.new(1, 0)
circleCloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
circleCloseButton.Text = "X"
circleCloseButton.TextColor3 = Color3.new(1,1,1)
circleCloseButton.Font = Enum.Font.GothamBold
circleCloseButton.TextScaled = true
circleCloseButton.BorderSizePixel = 0

local circleCloseCorner = Instance.new("UICorner", circleCloseButton)
circleCloseCorner.CornerRadius = UDim.new(0.5, 0)

-- Delete both GUIs when X is clicked
circleCloseButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    circleGui:Destroy()
    stealGui:Destroy()
end)

-- Toggle main GUI when circle button is clicked
circleButton.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Make circle GUI draggable
local circleDragging = false
local circleDragInput, circleMousePos, circleFramePos

circleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = true
        circleMousePos = input.Position
        circleFramePos = circleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                circleDragging = false
            end
        end)
    end
end)

circleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        circleDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == circleDragInput and circleDragging then
        local delta = input.Position - circleMousePos
        circleButton.Position = UDim2.new(
            circleFramePos.X.Scale,
            circleFramePos.X.Offset + delta.X,
            circleFramePos.Y.Scale,
            circleFramePos.Y.Offset + delta.Y
        )
    end
end)

-- Random name change for circle GUI
local randomNames = {
    "ControllerUI", "HelperPanel", "DebugMode", "SystemOverlay",
    "AccessPoint", "HiddenUI", "ToolModule", "Circle", "QuickMenu", "BubbleCore"
}

task.spawn(function()
    while circleGui and circleGui.Parent do
        task.wait(120)
        local newName = randomNames[math.random(1, #randomNames)]
        circleGui.Name = newName
    end
end)

-- Initialize
updateLanguage()

if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkSpeed
    -- Lưu checkpoint khi khởi động
    saveCheckpoint()
end
