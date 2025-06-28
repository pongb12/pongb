--PongbHub--
--Script by Pongb team--
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "UI_Main"
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
        SpeedUpdated = "Đã đặt tốc độ thành: "
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
        SpeedUpdated = "Speed set to: "
    }
}

-- === Global Variables ===
local cp
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local baseWalkSpeed = 16
local isGUIMaximized = false

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 550, 0, 380)
local originalGUIPosition = UDim2.new(0.5, -275, 0.5, -190)
local maximizedGUISize = UDim2.new(0, 700, 0, 500)
local maximizedGUIPosition = UDim2.new(0.5, -350, 0.5, -250)

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
local function showNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2,
        Icon = "rbxassetid://6726575885"
    })
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
    
    btn.MouseButton1Click:Connect(callback)
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
        callback(active)
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
        fadeTo(name)
    end)
end

-- === STEAL TAB ===
-- NoClip Function
local function noclipLoop()
    while noClipActive and player.Character do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        RunService.Stepped:Wait()
    end
end

addButton(tabs.Steal, "SaveCP", 20, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        cp = hrp.CFrame
        showNotification(texts[lang].Title, texts[lang].CPSaved)
    end
end)

addButton(tabs.Steal, "TeleCP", 60, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if cp and hrp then 
        hrp.CFrame = cp
        showNotification(texts[lang].Title, texts[lang].CPTeled)
    end
end)

addToggleButton(tabs.Steal, "AutoSteal", 100, function(active)
    autoStealActive = active
    if active then
        spawn(function()
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            if humanoid then
                baseWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 32
            end
            
            while autoStealActive and player.Character do
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                humanoid = player.Character:FindFirstChild("Humanoid")
                
                if cp and hrp and humanoid then
                    humanoid:MoveTo(cp.Position)
                    
                    local reached = false
                    local connection
                    connection = humanoid.MoveToFinished:Connect(function(success)
                        if success then
                            connection:Disconnect()
                            reached = true
                        end
                    end)
                    
                    local startTime = tick()
                    while not reached and (tick() - startTime < 10) and autoStealActive do
                        task.wait()
                    end
                    
                    if connection then connection:Disconnect() end
                end
                task.wait(0.5)
            end
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = baseWalkSpeed
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = baseWalkSpeed
        end
    end
end)

addToggleButton(tabs.Steal, "NoClip", 140, function(active)
    noClipActive = active
    if active then
        spawn(noclipLoop)
    end
end)

-- === MISC TAB ===
addButton(tabs.Misc, "Rejoin", 20, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

addButton(tabs.Misc, "Hop", 60, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId)
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
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobBox.Text)
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
        showNotification(texts[lang].Title, texts[lang].SpeedUpdated..walkSpeed)
    else
        speedSlider.Text = tostring(walkSpeed)
    end
end

speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateWalkSpeed()
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
    -- Save configuration here
    showNotification(texts[lang].Title, texts[lang].ConfigSaved)
end)

addButton(tabs.Setting, "ResetConfig", 380, function()
    walkSpeed = 16
    speedSlider.Text = "16"
    updateWalkSpeed()
    showNotification(texts[lang].Title, texts[lang].ConfigReset)
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

-- === Anti-Cheat Protection ===
local AntiBan = {
    Active = true,
    LastCheck = 0,
    
    SafeCheck = function(self)
        if tick() - self.LastCheck < 30 then return true end
        self.LastCheck = tick()
        
        local unsafe = {"AntiCheat", "AC", "Badger", "VAC"}
        for _, name in pairs(unsafe) do
            if game:GetService(name) then
                return false
            end
        end
        return true
    end,
    
    HandleKick = function(self, code)
        if code and code:find("BAC%-10261") then
            task.wait(300)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    end
}

game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == player and AntiBan.Active then
        AntiBan:HandleKick(p.KickMessage)
    end
end)

spawn(function()
    while AntiBan.Active and task.wait(10) do
        if not AntiBan:SafeCheck() then
            gui:Destroy()
            AntiBan.Active = false
            break
        end
    end
end)

-- Initialize
fadeTo("Steal")

-- Apply initial walk speed
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkSpeed
end
