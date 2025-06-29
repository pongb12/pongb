--PongbHub - Improved Version--
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PongbHub_"..HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false

-- === Language Settings ===
local lang = "vi"
local texts = {
    vi = {
        Title = "PongbHub",
        SaveCP = "Lưu Checkpoint",
        SelectCP = "Chọn Checkpoint ▼",
        AutoSteal = "Steal",
        Float = "Float",
        Rejoin = "Vào lại server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Xoá GUI",
        WalkSpeed = "Tốc độ di chuyển",
        NoClip = "Xuyên rào cản",
        CPSaved = "Đã lưu checkpoint!",
        CPTeled = "Đã dịch chuyển đến checkpoint!",
        CurrentSpeed = "Tốc độ hiện tại: ",
        SetSpeed = "Áp dụng tốc độ",
        SpeedUpdated = "Đã đặt tốc độ thành: ",
        ActiveFeature = "TÍNH NĂNG ĐANG BẬT: ",
        DeleteCP = "Xóa CP hiện tại",
        CPList = "Danh sách CP:",
        AutoStealComplete = "Steal hoàn thành!",
        Misc = "Tính năng khác",
        Settings = "Cài đặt",
        Language = "Ngôn ngữ",
        Theme = "Giao diện",
        MinimizeGUI = "Thu nhỏ GUI",
        MaximizeGUI = "Phóng to GUI"
    },
    en = {
        Title = "PongbHub",
        SaveCP = "Save Checkpoint",
        SelectCP = "Select Checkpoint ▼",
        AutoSteal = "Steal",
        Float = "Float",
        Rejoin = "Rejoin Server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Delete GUI",
        WalkSpeed = "Walk Speed",
        NoClip = "NoClip",
        CPSaved = "Checkpoint saved!",
        CPTeled = "Teleported to checkpoint!",
        CurrentSpeed = "Current speed: ",
        SetSpeed = "Apply Speed",
        SpeedUpdated = "Speed set to: ",
        ActiveFeature = "ACTIVE FEATURE: ",
        DeleteCP = "Delete Current CP",
        CPList = "CP List:",
        AutoStealComplete = "Steal complete!",
        Misc = "Misc",
        Settings = "Settings",
        Language = "Language",
        Theme = "Theme",
        MinimizeGUI = "Minimize GUI",
        MaximizeGUI = "Maximize GUI"
    }
}

-- === Global Variables ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local isGUIMaximized = true -- Start maximized
local isGUIMinimized = false
local flyHeight = 5
local flySpeed = 45
local activeFeatures = {}
local gameId = 109983668079237

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 300, 0, 450)
local maximizedGUISize = UDim2.new(0, 400, 0, 550)
local minimizedGUISize = UDim2.new(0, 150, 0, 30)

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = maximizedGUISize
main.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered
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
maximizeButton.Visible = false -- Hidden by default
maximizeButton.ZIndex = 2

local maximizeCorner = Instance.new("UICorner", maximizeButton)
maximizeCorner.CornerRadius = UDim.new(0, 4)

-- Content Frame
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 800)

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
miscTab.Size = UDim2.new(1, -10, 0, 300)
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
    
    -- Update CP dropdown
    updateCPDropdown()
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
mainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30) -- Active by default
local miscTabBtn = createTab("Misc", miscTab, 1)
local settingsTabBtn = createTab("Settings", settingsTab, 2)

-- === Checkpoint System ===
local cpDropdown = Instance.new("TextButton", mainTab)
cpDropdown.Size = UDim2.new(1, -10, 0, 30)
cpDropdown.Position = UDim2.new(0, 5, 0, 40)
cpDropdown.Text = texts[lang].SelectCP
cpDropdown.TextSize = 14
cpDropdown.Font = Enum.Font.Gotham
cpDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
cpDropdown.TextColor3 = Color3.new(1, 1, 1)

local cpDropdownCorner = Instance.new("UICorner", cpDropdown)
cpDropdownCorner.CornerRadius = UDim.new(0, 4)

local cpListFrame = Instance.new("ScrollingFrame", gui)
cpListFrame.Size = UDim2.new(0, 280, 0, 150)
cpListFrame.Position = UDim2.new(0, main.AbsolutePosition.X + 10, 0, main.AbsolutePosition.Y + 115)
cpListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cpListFrame.BorderSizePixel = 1
cpListFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
cpListFrame.Visible = false
cpListFrame.ZIndex = 10
cpListFrame.ScrollBarThickness = 4
cpListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local cpListCorner = Instance.new("UICorner", cpListFrame)
cpListCorner.CornerRadius = UDim.new(0, 4)

local cpListLayout = Instance.new("UIListLayout", cpListFrame)
cpListLayout.Padding = UDim.new(0, 2)

local function updateCanvasSize()
    cpListLayout.Changed:Connect(function()
        cpListFrame.CanvasSize = UDim2.new(0, 0, 0, cpListLayout.AbsoluteContentSize.Y + 10)
    end)
end
updateCanvasSize()

local function updateCPDropdown()
    cpDropdown.Text = texts[lang].SelectCP.." ("..#cp..")"
end

local function createCPButton(index, cframe)
    local btn = Instance.new("TextButton", cpListFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = "CP "..index..": "..math.floor(cframe.X)..", "..math.floor(cframe.Y)..", "..math.floor(cframe.Z)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            currentCPIndex = index
            player.Character.HumanoidRootPart.CFrame = cframe
            cpListFrame.Visible = false
            game.StarterGui:SetCore("SendNotification", {
                Title = texts[lang].Title,
                Text = texts[lang].CPTeled.." #"..index,
                Duration = 2
            })
        end
    end)

    return btn
end

local function saveCurrentCP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        table.insert(cp, hrp.CFrame)
        createCPButton(#cp, hrp.CFrame)
        updateCPDropdown()
        updateCanvasSize()
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CPSaved.." #"..#cp,
            Duration = 2
        })
    end
end

local function deleteCurrentCP()
    if #cp > 0 and currentCPIndex <= #cp then
        table.remove(cp, currentCPIndex)
        for _, child in pairs(cpListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for i, checkpoint in ipairs(cp) do
            createCPButton(i, checkpoint)
        end
        if #cp == 0 then
            cpListFrame.Visible = false
            currentCPIndex = 1
        elseif currentCPIndex > #cp then
            currentCPIndex = #cp
        end
        updateCPDropdown()
        updateCanvasSize()
    end
end

cpDropdown.MouseButton1Click:Connect(function()
    if #cp > 0 then
        cpListFrame.Visible = not cpListFrame.Visible
        local mainPos = main.AbsolutePosition
        cpListFrame.Position = UDim2.new(0, mainPos.X + 10, 0, mainPos.Y + 115)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = cpListFrame.AbsolutePosition
        local frameSize = cpListFrame.AbsoluteSize
        
        if cpListFrame.Visible and (mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or 
           mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y) then
            cpListFrame.Visible = false
        end
    end
end)

-- === Server Hopping Function ===
local function serverHop()
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=100"))
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

-- === Float Function ===
local floatActive = false
local floatBodyVelocity = nil

local function toggleFloat(active)
    floatActive = active
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return end
    
    if active then
        floatBodyVelocity = Instance.new("BodyVelocity", hrp)
        floatBodyVelocity.Velocity = Vector3.new(0, 14, 0)
        floatBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        
        spawn(function()
            while floatActive and floatBodyVelocity and player.Character do
                if floatBodyVelocity then
                    floatBodyVelocity.Velocity = Vector3.new(0, 14, 0)
                end
                wait(0.1)
            end
        end)
    else
        if floatBodyVelocity then
            floatBodyVelocity:Destroy()
            floatBodyVelocity = nil
        end
    end
end

-- === Auto Steal ===
local function flyToPosition(targetCFrame)
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    humanoid.PlatformStand = true
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)

    local startTime = tick()
    local distance = (hrp.Position - targetCFrame.Position).Magnitude

    while autoStealActive and (tick() - startTime < distance / flySpeed * 2.5) do
        if not player.Character or not hrp or not bodyVelocity then break end

        local direction = (targetCFrame.Position - hrp.Position).Unit
        bodyVelocity.Velocity = direction * flySpeed

        local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -3, 0), raycastParams)
        
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
end

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

-- === Anti-Kick/Ban Protection ===
local antiKickActive = true

local function setupAntiKick()
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
end

-- Try to set up anti-kick (may not work in all games)
pcall(setupAntiKick)

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
        end)
    else
        btn.MouseButton1Click:Connect(callback)
    end

    return btn
end

-- Main Tab Buttons
createButton("SaveCP", 0, saveCurrentCP, false, mainTab)
createButton("DeleteCP", 80, deleteCurrentCP, false, mainTab)
createButton("AutoSteal", 120, function(active)
    autoStealActive = active
    if active and #cp > 0 then
        flyToPosition(cp[currentCPIndex])
    end
end, true, mainTab)

createButton("Float", 160, toggleFloat, true, mainTab)

createButton("NoClip", 200, function(active)
    noClipActive = active
    improvedNoClip()
end, true, mainTab)

-- Speed Control
local speedLabel = Instance.new("TextLabel", mainTab)
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 240)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("TextBox", mainTab)
speedSlider.Size = UDim2.new(0.6, -5, 0, 30)
speedSlider.Position = UDim2.new(0, 5, 0, 260)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-10000"
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)

local speedSliderCorner = Instance.new("UICorner", speedSlider)
speedSliderCorner.CornerRadius = UDim.new(0, 4)

local speedBtn = createButton("SetSpeed", 260, function()
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
speedBtn.Position = UDim2.new(0.6, 5, 0, 260)

-- Misc Tab Content
createButton("Rejoin", 0, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end, false, miscTab)

createButton("Hop", 40, function()
    serverHop()
end, false, miscTab)

createButton("DeleteGUI", 80, function()
    gui:Destroy()
end, false, miscTab)

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
end)

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
    
    if cpListFrame.Visible then
        local mainPos = main.AbsolutePosition
        cpListFrame.Position = UDim2.new(0, mainPos.X + 10, 0, mainPos.Y + 115)
    end
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
player.CharacterAdded:Connect(function()
    wait(1)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end
    
    if floatActive then
        floatActive = false
        floatBodyVelocity = nil
    end
    
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
end)

-- Initialize
updateCPDropdown()
updateLanguage()

if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkSpeed
end
