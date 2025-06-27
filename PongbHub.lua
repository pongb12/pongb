--PongbHub--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "UI_Main"
gui.ResetOnSpawn = false

-- === Ngôn ngữ ===
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
        CPTeled = "Đã dịch chuyển đến checkpoint!"
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
        CPTeled = "Teleported to checkpoint!"
    }
}

-- === Biến toàn cục ===
local cp
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local config = {
    walkSpeed = walkSpeed,
    lang = lang
}

-- === GUI Chính ===
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 330)
main.Position = UDim2.new(0.5, -250, 0.5, -165)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
main.Active = true
main.Draggable = true
main.Visible = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(100, 100, 100)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tab List
local tabList = Instance.new("Frame", main)
tabList.Size = UDim2.new(0, 100, 1, -30)
tabList.Position = UDim2.new(0, 0, 0, 30)
tabList.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

-- Content
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -100, 1, -30)
content.Position = UDim2.new(0, 100, 0, 30)
content.BackgroundTransparency = 1

-- === Hàm tiện ích ===
local function showNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

local function createTabButton(name, posY)
    local b = Instance.new("TextButton", tabList)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, posY)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    b.TextSize = 14
    return b
end

local function createTabFrame()
    local f = Instance.new("Frame", content)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    return f
end

local function addBtn(tab, key, posY, callback)
    local b = Instance.new("TextButton", tab)
    b.Size = UDim2.new(0, 200, 0, 30)
    b.Position = UDim2.new(0, 20, 0, posY)
    b.Text = texts[lang][key] or key
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    b.Name = key
    b.MouseButton1Click:Connect(callback)
    return b
end

local function addToggleBtn(tab, key, posY, callback)
    local b = Instance.new("TextButton", tab)
    b.Size = UDim2.new(0, 200, 0, 30)
    b.Position = UDim2.new(0, 20, 0, posY)
    b.Text = texts[lang][key] or key
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    b.Name = key
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        if active then
            b.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(active)
    end)
    return b
end

-- === Tabs ===
local tabs = {
    Steal = createTabFrame(),
    Misc = createTabFrame(),
    Setting = createTabFrame()
}

local tabBtns = {
    Steal = createTabButton("Steal", 0),
    Misc = createTabButton("Misc", 45),
    Setting = createTabButton("Setting", 90)
}

-- Tab animation
local function fadeTo(tabName)
    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        else
            frame.Visible = false
        end
    end
end

for name, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function()
        fadeTo(name)
    end)
end

-- === STEAL ===
-- Hàm NoClip
local function noclipLoop()
    while noClipActive and player.Character do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        RunService.Stepped:wait()
    end
end

addBtn(tabs.Steal, "SaveCP", 20, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        cp = hrp.CFrame
        showNotification(texts[lang].Title, texts[lang].CPSaved)
    end
end)

addBtn(tabs.Steal, "TeleCP", 60, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if cp and hrp then 
        hrp.CFrame = cp
        showNotification(texts[lang].Title, texts[lang].CPTeled)
    end
end)

addToggleBtn(tabs.Steal, "AutoSteal", 100, function(active)
    autoStealActive = active
    if active then
        spawn(function()
            while autoStealActive and player.Character do
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if cp and hrp and humanoid then
                    humanoid.WalkSpeed = walkSpeed
                    hrp.CFrame = cp
                    task.wait(1) -- Delay để tránh anti-teleport
                end
                task.wait()
            end
        end)
    end
end)

-- Nút NoClip
addToggleBtn(tabs.Steal, "NoClip", 140, function(active)
    noClipActive = active
    if active then
        spawn(noclipLoop)
    end
end)

-- === MISC ===
addBtn(tabs.Misc, "Rejoin", 20, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

addBtn(tabs.Misc, "Hop", 60, function()
    TeleportService:TeleportToPlaceInstance(109983668079237, "00000000000000000000000000000000")
end)

local jobBox = Instance.new("TextBox", tabs.Misc)
jobBox.Size = UDim2.new(0, 200, 0, 30)
jobBox.Position = UDim2.new(0, 20, 0, 100)
jobBox.PlaceholderText = texts[lang].JobPlaceholder
jobBox.Name = "JobBox"

addBtn(tabs.Misc, "Join", 140, function()
    if jobBox.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(109983668079237, jobBox.Text)
    end
end)

addBtn(tabs.Misc, "DeleteGUI", 180, function()
    gui:Destroy()
end)

-- === SETTING ===
local speedLabel = Instance.new("TextLabel", tabs.Setting)
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0, 20, 0, 60)
speedLabel.Text = texts[lang].WalkSpeed..": "..walkSpeed
speedLabel.TextSize = 14
speedLabel.BackgroundTransparency = 1

local speedSlider = Instance.new("TextBox", tabs.Setting)
speedSlider.Size = UDim2.new(0, 200, 0, 30)
speedSlider.Position = UDim2.new(0, 20, 0, 80)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-100"
speedSlider.TextSize = 14

local function updateWalkSpeed()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
        walkSpeed = newSpeed
        speedLabel.Text = texts[lang].WalkSpeed..": "..walkSpeed
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
    else
        speedSlider.Text = tostring(walkSpeed)
    end
end

speedSlider.FocusLost:Connect(updateWalkSpeed)

-- Nút lưu/xóa cấu hình
addBtn(tabs.Setting, "SaveConfig", 120, function()
    config.walkSpeed = walkSpeed
    config.lang = lang
    showNotification(texts[lang].Title, texts[lang].ConfigSaved)
end)

addBtn(tabs.Setting, "ResetConfig", 160, function()
    walkSpeed = 16
    speedSlider.Text = "16"
    updateWalkSpeed()
    showNotification(texts[lang].Title, texts[lang].ConfigReset)
end)

-- Nút chuyển ngôn ngữ
local langBtn = addBtn(tabs.Setting, "LangSwitch", 20, function()
    lang = (lang == "vi") and "en" or "vi"
    title.Text = texts[lang].Title
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    speedLabel.Text = texts[lang].WalkSpeed..": "..walkSpeed
    speedSlider.PlaceholderText = "16-100"
    
    for _, tab in pairs(tabs) do
        for _, c in pairs(tab:GetChildren()) do
            if c:IsA("TextButton") and texts[lang][c.Name] then
                c.Text = texts[lang][c.Name]
            end
        end
    end
    langBtn.Text = texts[lang].LangSwitch
end)

-- === PHÍM TẮT ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Ẩn/hiện GUI
    if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
    
    -- Ẩn khẩn cấp
    if input.KeyCode == Enum.KeyCode.F4 then
        gui.Enabled = not gui.Enabled
    end
end)

-- === ANTI-BAN/KICK SYSTEM ===
local AntiBan = {
    Active = true,
    LastCheck = 0,
    
    RandomNames = {"CoreGui", "PlayerNotification", "ChatSystem", "MobileControls"},
    
    SafeCheck = function(self)
        if tick() - self.LastCheck < 30 then return true end
        self.LastCheck = tick()
        
        local unsafe = {"AntiCheat", "AC", "Badger", "VAC"}
        for _, name in pairs(unsafe) do
            if game:FindFirstChild(name) then
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
    end,
    
    Camouflage = function(self)
        if math.random(1, 100) == 1 then
            gui.Name = self.RandomNames[math.random(1, #self.RandomNames)]
        end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if math.random(1, 50) == 1 then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
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
        AntiBan:Camouflage()
    end
end)

-- Hiển thị tab mặc định
fadeTo("Steal")

-- Áp dụng tốc độ di chuyển ban đầu
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = walkSpeed
end
