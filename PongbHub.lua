--PongbHub--
--Enhanced Script by Pongb team--
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "UI_Main_"..HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false

-- === Language Settings ===
local lang = "vi"
local texts = {
    vi = {
        Title = "PongbHub",
        SaveCP = "Lưu Checkpoint",
        TeleCP = "Về Checkpoint",
        AutoSteal = "Auto Steal",
        Rejoin = "Vào lại server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Xoá GUI",
        LangSwitch = "Ngôn ngữ: Việt/Anh",
        JobPlaceholder = "Nhập Job ID",
        WalkSpeed = "Tốc độ di chuyển",
        SaveConfig = "Lưu cấu hình",
        ResetConfig = "Đặt lại cấu hình",
        NoClip = "Xuyên rào cản",
        ConfigSaved = "Đã lưu cấu hình!",
        ConfigReset = "Đã đặt lại cấu hình!",
        CPSaved = "Đã lưu checkpoint!",
        CPTeled = "Đã dịch chuyển đến checkpoint!",
        ZoomGUI = "🗖",
        Shortcuts = "Phím tắt:",
        ShortcutList = "F1: Ẩn/hiện GUI\nF2: Phóng to/thu nhỏ\nF4: Ẩn khẩn cấp\nShift phải: Ẩn/hiện GUI",
        CurrentSpeed = "Tốc độ hiện tại: ",
        SetSpeed = "Áp dụng tốc độ",
        SpeedUpdated = "Đã đặt tốc độ thành: ",
        ActiveFeature = "TÍNH NĂNG ĐANG BẬT: ",
        MultiCP = "Lưu CP đa điểm",
        SelectCP = "Chọn CP",
        NextCP = "CP tiếp theo",
        PrevCP = "CP trước đó",
        DeleteCP = "Xóa CP hiện tại",
        CPList = "Danh sách CP:"
    },
    en = {
        Title = "PongbHub",
        SaveCP = "Save Checkpoint",
        TeleCP = "Go to Checkpoint",
        AutoSteal = "Auto Steal",
        Rejoin = "Rejoin Server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Delete GUI",
        LangSwitch = "Language: EN/VN",
        JobPlaceholder = "Enter Job ID",
        WalkSpeed = "Walk Speed",
        SaveConfig = "Save Config",
        ResetConfig = "Reset Config",
        NoClip = "NoClip",
        ConfigSaved = "Config saved!",
        ConfigReset = "Config reset!",
        CPSaved = "Checkpoint saved!",
        CPTeled = "Teleported to checkpoint!",
        ZoomGUI = "🗖",
        Shortcuts = "Shortcuts:",
        ShortcutList = "F1: Toggle GUI\nF2: Zoom GUI\nF4: Emergency hide\nRight Shift: Toggle GUI",
        CurrentSpeed = "Current speed: ",
        SetSpeed = "Apply Speed",
        SpeedUpdated = "Speed set to: ",
        ActiveFeature = "ACTIVE FEATURE: ",
        MultiCP = "Save Multi CP",
        SelectCP = "Select CP",
        NextCP = "Next CP",
        PrevCP = "Previous CP",
        DeleteCP = "Delete Current CP",
        CPList = "CP List:"
    }
}

-- === Global Variables ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local baseWalkSpeed = 16
local isGUIMaximized = false
local flySpeed = 35
local activeFeatures = {}
local gameId = 109983668079237 -- Target game ID for server hop

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 550, 0, 380)
local originalGUIPosition = UDim2.new(0.5, -275, 0.5, -190)
local maximizedGUISize = UDim2.new(0, 700, 0, 500)
local maximizedGUIPosition = UDim2.new(0.5, -350, 0.5, -250)

-- === Anti-Cheat Protection ===
local function getRandomName()
    local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local name = ""
    for i = 1, 10 do
        name = name .. string.sub(letters, math.random(1, #letters), math.random(1, #letters))
    end
    return name
end

local AntiBan = {
    Active = true,
    LastCheck = 0,
    SafeFunctions = {},
    
    SafeCheck = function(self)
        if tick() - self.LastCheck < 30 then return true end
        self.LastCheck = tick()
        
        -- Randomize function names
        for k, v in pairs(self.SafeFunctions) do
            self.SafeFunctions[getRandomName()] = v
            self.SafeFunctions[k] = nil
        end
        
        -- Check for anti-cheat services
        local unsafe = {"AntiCheat", "AC", "Badger", "VAC", "Kick", "Ban"}
        for _, name in pairs(unsafe) do
            if game:GetService(name) then
                return false
            end
        end
        
        -- Check for known anti-cheat scripts
        for _, v in pairs(getnilinstances()) do
            if v:IsA("LocalScript") and (v.Name:find("Anti") or v.Name:find("AC")) then
                return false
            end
        end
        
        return true
    end,
    
    HandleKick = function(self, code)
        if code and (code:find("BAC%-10261") or code:find("Kick") or code:find("Ban")) then
            task.wait(math.random(200, 400)) -- Random delay
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    end,
    
    SafeCall = function(self, func, ...)
        if not self.Active then return end
        local success, result = pcall(func, ...)
        if not success then
            warn("AntiBan intercepted error: "..result)
        end
        return result
    end
}

-- Initialize safe functions
AntiBan.SafeFunctions = {
    showNotification = function(title, text)
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2,
            Icon = "rbxassetid://6726575885"
        })
    end,
    
    teleportTo = function(cframe)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cframe
        end
    end
}

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = originalGUISize
main.Position = originalGUIPosition
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
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Bar with Zoom Button
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Name = "TitleBar"

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 12, 0, 0)

local activeFeatureLabel = Instance.new("TextLabel", titleBar)
activeFeatureLabel.Size = UDim2.new(0, 200, 1, 0)
activeFeatureLabel.Position = UDim2.new(0.5, -100, 0, 0)
activeFeatureLabel.BackgroundTransparency = 1
activeFeatureLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
activeFeatureLabel.Text = ""
activeFeatureLabel.Font = Enum.Font.GothamBold
activeFeatureLabel.TextSize = 14
activeFeatureLabel.Visible = false

local zoomBtn = Instance.new("TextButton", titleBar)
zoomBtn.Size = UDim2.new(0, 32, 0, 32)
zoomBtn.Position = UDim2.new(1, -32, 0, 0)
zoomBtn.Text = texts[lang].ZoomGUI
zoomBtn.BackgroundTransparency = 1
zoomBtn.TextColor3 = Color3.new(1, 1, 1)
zoomBtn.Font = Enum.Font.GothamBold
zoomBtn.TextSize = 16
zoomBtn.Name = "ZoomButton"

-- Tab List
local tabList = Instance.new("Frame", main)
tabList.Size = UDim2.new(0, 120, 1, -32)
tabList.Position = UDim2.new(0, 0, 0, 32)
tabList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Content Frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -120, 1, -32)
content.Position = UDim2.new(0, 120, 0, 32)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

-- === Utility Functions ===
local function updateActiveFeatures()
    local features = {}
    if autoStealActive then table.insert(features, texts[lang].AutoSteal) end
    if noClipActive then table.insert(features, texts[lang].NoClip) end
    
    if #features > 0 then
        activeFeatureLabel.Text = texts[lang].ActiveFeature..table.concat(features, ", ")
        activeFeatureLabel.Visible = true
    else
        activeFeatureLabel.Visible = false
    end
end

local function createTabButton(name, posY)
    local btn = Instance.new("TextButton", tabList)
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.Position = UDim2.new(0, 4, 0, posY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return btn
end

local function createTabFrame()
    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 4
    frame.CanvasSize = UDim2.new(0, 0, 0, 600)
    return frame
end

local function addButton(tab, key, posY, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(0, 250, 0, 36)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.Text = texts[lang][key] or key
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Name = key
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    btn.MouseButton1Click:Connect(function()
        AntiBan:SafeCall(callback)
    end)
    return btn
end

local function addToggleButton(tab, key, posY, callback)
    local btn = addButton(tab, key, posY, function() end)
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        AntiBan:SafeCall(callback, active)
        updateActiveFeatures()
    end)
    
    return btn
end

-- === Create Tabs ===
local tabs = {
    Steal = createTabFrame(),
    Misc = createTabFrame(),
    Setting = createTabFrame()
}

local tabButtons = {
    Steal = createTabButton("Steal", 4),
    Misc = createTabButton("Misc", 48),
    Setting = createTabButton("Setting", 92)
}

-- Tab Animation
local function fadeTo(tabName)
    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        else
            frame.Visible = false
        end
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        AntiBan:SafeCall(fadeTo, name)
    end)
end

-- === Enhanced NoClip ===
local function improvedNoClip()
    while noClipActive and player.Character do
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(11) -- Freeze state to prevent detection
        end
        
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
        RunService.Stepped:Wait()
    end
end

-- === Flying Function for Auto Steal ===
local function flyToPosition(targetCFrame)
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    -- Enable flying
    humanoid.PlatformStand = true
    
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    
    local startTime = tick()
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    
    while autoStealActive and (tick() - startTime < distance / flySpeed * 1.5) do
        if not player.Character or not hrp or not bodyVelocity then break end
        
        local direction = (targetCFrame.Position - hrp.Position).Unit
        bodyVelocity.Velocity = direction * flySpeed
        
        -- Smooth height adjustment (fly slightly above ground)
        local ray = Ray.new(hrp.Position, Vector3.new(0, -10, 0))
        local hit = workspace:FindPartOnRay(ray, player.Character)
        
        if hit then
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, 5, bodyVelocity.Velocity.Z)
        else
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, 0, bodyVelocity.Velocity.Z)
        end
        
        RunService.Heartbeat:Wait()
    end
    
    -- Cleanup
    if bodyVelocity then bodyVelocity:Destroy() end
    if humanoid then humanoid.PlatformStand = false end
end

-- === Multi Checkpoint System ===
local cpListLabel = Instance.new("TextLabel", tabs.Steal)
cpListLabel.Size = UDim2.new(0, 250, 0, 20)
cpListLabel.Position = UDim2.new(0, 20, 0, 300)
cpListLabel.Text = texts[lang].CPList
cpListLabel.TextSize = 14
cpListLabel.Font = Enum.Font.GothamBold
cpListLabel.BackgroundTransparency = 1
cpListLabel.TextColor3 = Color3.new(1, 1, 1)
cpListLabel.TextXAlignment = Enum.TextXAlignment.Left
cpListLabel.Visible = false

local cpListText = Instance.new("TextLabel", tabs.Steal)
cpListText.Size = UDim2.new(0, 250, 0, 60)
cpListText.Position = UDim2.new(0, 20, 0, 320)
cpListText.Text = ""
cpListText.TextSize = 12
cpListText.Font = Enum.Font.Gotham
cpListText.BackgroundTransparency = 1
cpListText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
cpListText.TextXAlignment = Enum.TextXAlignment.Left
cpListText.TextYAlignment = Enum.TextYAlignment.Top
cpListText.Visible = false

local function updateCPList()
    if #cp > 0 then
        cpListLabel.Visible = true
        cpListText.Visible = true
        
        local listText = ""
        for i, checkpoint in ipairs(cp) do
            local pos = checkpoint.Position
            listText = listText .. string.format("%d: (%.1f, %.1f, %.1f)\n", i, pos.X, pos.Y, pos.Z)
        end
        cpListText.Text = listText
    else
        cpListLabel.Visible = false
        cpListText.Visible = false
    end
end

local function saveCurrentCP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        table.insert(cp, hrp.CFrame)
        currentCPIndex = #cp
        AntiBan.SafeFunctions.showNotification(texts[lang].Title, texts[lang].CPSaved.." #"..#cp)
        updateCPList()
    end
end

local function deleteCurrentCP()
    if #cp > 0 then
        table.remove(cp, currentCPIndex)
        if currentCPIndex > #cp then
            currentCPIndex = #cp
        end
        if #cp == 0 then
            currentCPIndex = 1
        end
        updateCPList()
        AntiBan.SafeFunctions.showNotification(texts[lang].Title, "Deleted CP #"..currentCPIndex)
    end
end

local function teleportToCP(index)
    if cp[index] then
        currentCPIndex = index
        AntiBan.SafeFunctions.teleportTo(cp[index])
        AntiBan.SafeFunctions.showNotification(texts[lang].Title, texts[lang].CPTeled.." #"..index)
    end
end

-- === STEAL TAB ===
addButton(tabs.Steal, "SaveCP", 20, function()
    saveCurrentCP()
end)

addButton(tabs.Steal, "TeleCP", 60, function()
    if #cp > 0 then
        teleportToCP(currentCPIndex)
    end
end)

addButton(tabs.Steal, "NextCP", 100, function()
    if #cp > 0 then
        currentCPIndex = (currentCPIndex % #cp) + 1
        teleportToCP(currentCPIndex)
    end
end)

addButton(tabs.Steal, "PrevCP", 140, function()
    if #cp > 0 then
        currentCPIndex = (currentCPIndex - 2) % #cp + 1
        teleportToCP(currentCPIndex)
    end
end)

addButton(tabs.Steal, "DeleteCP", 180, function()
    deleteCurrentCP()
end)

addToggleButton(tabs.Steal, "AutoSteal", 220, function(active)
    autoStealActive = active
    if active then
        spawn(function()
            while autoStealActive and player.Character and #cp > 0 do
                flyToPosition(cp[currentCPIndex])
                
                -- Move to next CP automatically
                currentCPIndex = (currentCPIndex % #cp) + 1
                
                -- Small delay before next move
                task.wait(0.5)
            end
            autoStealActive = false
        end)
    end
end)

addToggleButton(tabs.Steal, "NoClip", 260, function(active)
    noClipActive = active
    if active then
        spawn(improvedNoClip)
    end
end)

-- === MISC TAB ===
local function safeTeleport(placeId, jobId)
    if not AntiBan:SafeCheck() then
        gui:Destroy()
        return
    end
    
    if jobId then
        TeleportService:TeleportToPlaceInstance(placeId, jobId)
    else
        TeleportService:Teleport(placeId)
    end
end

addButton(tabs.Misc, "Rejoin", 20, function()
    safeTeleport(game.PlaceId, game.JobId)
end)

addButton(tabs.Misc, "Hop", 60, function()
    -- Get servers for our target game
    local servers = {}
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?limit=100"
        ))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            safeTeleport(gameId, servers[math.random(1, #servers)])
        else
            safeTeleport(gameId)
        end
    else
        safeTeleport(gameId)
    end
end)

local jobBox = Instance.new("TextBox", tabs.Misc)
jobBox.Size = UDim2.new(0, 250, 0, 36)
jobBox.Position = UDim2.new(0, 20, 0, 100)
jobBox.PlaceholderText = texts[lang].JobPlaceholder
jobBox.Text = ""
jobBox.ClearTextOnFocus = false
jobBox.TextSize = 14
jobBox.Font = Enum.Font.Gotham
jobBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jobBox.TextColor3 = Color3.new(1, 1, 1)

local boxCorner = Instance.new("UICorner", jobBox)
boxCorner.CornerRadius = UDim.new(0, 4)

addButton(tabs.Misc, "Join", 140, function()
    if jobBox.Text ~= "" then
        safeTeleport(game.PlaceId, jobBox.Text)
    end
end)

addButton(tabs.Misc, "DeleteGUI", 180, function()
    gui:Destroy()
end)

-- === SETTING TAB ===
-- Speed Control
local speedLabel = Instance.new("TextLabel", tabs.Setting)
speedLabel.Size = UDim2.new(0, 250, 0, 20)
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("TextBox", tabs.Setting)
speedSlider.Size = UDim2.new(0, 250, 0, 36)
speedSlider.Position = UDim2.new(0, 20, 0, 40)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-100"
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.ClearTextOnFocus = false

local sliderCorner = Instance.new("UICorner", speedSlider)
sliderCorner.CornerRadius = UDim.new(0, 4)

local function updateWalkSpeed()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
        walkSpeed = newSpeed
        speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if not autoStealActive then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        end
        AntiBan.SafeFunctions.showNotification(texts[lang].Title, texts[lang].SpeedUpdated..walkSpeed)
    else
        speedSlider.Text = tostring(walkSpeed)
    end
end

speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        AntiBan:SafeCall(updateWalkSpeed)
    end
end)

addButton(tabs.Setting, "SetSpeed", 80, function()
    updateWalkSpeed()
end)

-- Language Switch
addButton(tabs.Setting, "LangSwitch", 140, function()
    lang = (lang == "vi") and "en" or "vi"
    title.Text = texts[lang].Title
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
    
    -- Update all buttons text
    for _, tab in pairs(tabs) do
        for _, child in pairs(tab:GetChildren()) do
            if child:IsA("TextButton") and texts[lang][child.Name] then
                child.Text = texts[lang][child.Name]
            end
        end
    end
    updateActiveFeatures()
    updateCPList()
end)

-- Shortcuts Info
local shortcutsLabel = Instance.new("TextLabel", tabs.Setting)
shortcutsLabel.Size = UDim2.new(0, 250, 0, 20)
shortcutsLabel.Position = UDim2.new(0, 20, 0, 200)
shortcutsLabel.Text = texts[lang].Shortcuts
shortcutsLabel.TextSize = 14
shortcutsLabel.Font = Enum.Font.GothamBold
shortcutsLabel.BackgroundTransparency = 1
shortcutsLabel.TextColor3 = Color3.new(1, 1, 1)
shortcutsLabel.TextXAlignment = Enum.TextXAlignment.Left

local shortcutsText = Instance.new("TextLabel", tabs.Setting)
shortcutsText.Size = UDim2.new(0, 250, 0, 100)
shortcutsText.Position = UDim2.new(0, 20, 0, 220)
shortcutsText.Text = texts[lang].ShortcutList
shortcutsText.TextSize = 12
shortcutsText.Font = Enum.Font.Gotham
shortcutsText.BackgroundTransparency = 1
shortcutsText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
shortcutsText.TextXAlignment = Enum.TextXAlignment.Left
shortcutsText.TextYAlignment = Enum.TextYAlignment.Top

-- Config Buttons
addButton(tabs.Setting, "SaveConfig", 340, function()
    AntiBan.SafeFunctions.showNotification(texts[lang].Title, texts[lang].ConfigSaved)
end)

addButton(tabs.Setting, "ResetConfig", 380, function()
    walkSpeed = 16
    speedSlider.Text = "16"
    updateWalkSpeed()
    AntiBan.SafeFunctions.showNotification(texts[lang].Title, texts[lang].ConfigReset)
end)

-- === GUI Zoom Function ===
zoomBtn.MouseButton1Click:Connect(function()
    isGUIMaximized = not isGUIMaximized
    if isGUIMaximized then
        main.Size = maximizedGUISize
        main.Position = maximizedGUIPosition
        zoomBtn.Text = "🗗"
    else
        main.Size = originalGUISize
        main.Position = originalGUIPosition
        zoomBtn.Text = texts[lang].ZoomGUI
    end
end)

-- === GUI Dragging Fix ===
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- === Mobile/PC Responsive Adjustments ===
local function updateGUIPosition()
    if UserInputService.TouchEnabled then -- Mobile
        main.Position = UDim2.new(0.5, -275, 0.1, 0)
    else -- PC
        if isGUIMaximized then
            main.Position = maximizedGUIPosition
        else
            main.Position = originalGUIPosition
        end
    end
end

UserInputService.LastInputTypeChanged:Connect(updateGUIPosition)
updateGUIPosition()

-- === Keyboard Shortcuts ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Toggle GUI visibility
    if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
    
    -- Emergency hide
    if input.KeyCode == Enum.KeyCode.F4 then
        gui.Enabled = not gui.Enabled
    end
    
    -- Zoom GUI
    if input.KeyCode == Enum.KeyCode.F2 then
        isGUIMaximized = not isGUIMaximized
        if isGUIMaximized then
            main.Size = maximizedGUISize
            main.Position = maximizedGUIPosition
            zoomBtn.Text = "🗗"
        else
            main.Size = originalGUISize
            main.Position = originalGUIPosition
            zoomBtn.Text = texts[lang].ZoomGUI
        end
    end
end)

-- === Anti-Cheat Protection Loop ===
spawn(function()
    while AntiBan.Active and task.wait(math.random(10, 20)) do -- Random check interval
        if not AntiBan:SafeCheck() then
            gui:Destroy()
            AntiBan.Active = false
            break
        end
    end
end)

-- Player removal handler
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == player and AntiBan.Active then
        AntiBan:HandleKick(p.KickMessage)
    end
end)

-- Initialize
fadeTo("Steal")

-- Apply initial walk speed
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkSpeed
end
