-- ✅ Full GUI PongbHub with language toggle, anti-ban system, spawn-tracked AutoSteal, tab animation, drag, toggle visibility

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "UI_Main"
gui.ResetOnSpawn = false

-- Language system
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
        JobPlaceholder = "Nhập Job ID"
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
        JobPlaceholder = "Enter Job ID"
    }
}

-- GUI Base
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 330)
main.Position = UDim2.new(0.5, -250, 0.5, -165)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
main.Active = true
main.Draggable = true
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Thickness = 2

-- Minimize/Expand
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Text = "–"
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -30, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18

local isMinimized = false
toggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, c in pairs(main:GetChildren()) do
        if c ~= toggleBtn and not c:IsA("UICorner") and not c:IsA("UIStroke") then
            c.Visible = not isMinimized
        end
    end
    main.Size = isMinimized and UDim2.new(0, 500, 0, 30) or UDim2.new(0, 500, 0, 330)
    toggleBtn.Text = isMinimized and "+" or "–"
end)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tabs
local tabList = Instance.new("Frame", main)
tabList.Size = UDim2.new(0, 100, 1, -30)
tabList.Position = UDim2.new(0, 0, 0, 30)
tabList.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -100, 1, -30)
content.Position = UDim2.new(0, 100, 0, 30)
content.BackgroundTransparency = 1

local function createTabButton(name, y)
    local b = Instance.new("TextButton", tabList)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, y)
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

local tabs = { Steal = createTabFrame(), Misc = createTabFrame(), Setting = createTabFrame() }
local tabBtns = {
    Steal = createTabButton("Steal", 0),
    Misc = createTabButton("Misc", 45),
    Setting = createTabButton("Setting", 90)
}

local function fadeTo(tabName)
    for name, frame in pairs(tabs) do
        frame.Visible = name == tabName
        if name == tabName then
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end
    end
end

for name, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() fadeTo(name) end)
end

-- Get player's original spawn
local spawnCFrame = nil
player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    task.wait(1)
    spawnCFrame = hrp.CFrame
end)

-- Button creation
local function addBtn(tab, key, y, cb)
    local b = Instance.new("TextButton", tab)
    b.Size = UDim2.new(0, 200, 0, 30)
    b.Position = UDim2.new(0, 20, 0, y)
    b.Text = texts[lang][key]
    b.Name = key
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    b.MouseButton1Click:Connect(cb)
    return b
end

local cp = nil
addBtn(tabs.Steal, "SaveCP", 20, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then cp = hrp.CFrame end
end)

addBtn(tabs.Steal, "TeleCP", 60, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if cp and hrp then hrp.CFrame = cp end
end)

addBtn(tabs.Steal, "AutoSteal", 100, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if hrp and hum and spawnCFrame then
        hum.WalkSpeed = 32
        TweenService:Create(hrp, TweenInfo.new(3), {CFrame = spawnCFrame + Vector3.new(0, 3, 0)}):Play()
    end
end)

-- Misc
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

-- Setting
local langBtn = addBtn(tabs.Setting, "LangSwitch", 20, function()
    lang = (lang == "vi") and "en" or "vi"
    title.Text = texts[lang].Title
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    for _, tab in pairs(tabs) do
        for _, obj in pairs(tab:GetChildren()) do
            if obj:IsA("TextButton") and texts[lang][obj.Name] then
                obj.Text = texts[lang][obj.Name]
            end
        end
    end
    langBtn.Text = texts[lang].LangSwitch
end)

-- Hotkey show/hide GUI
UserInputService.InputBegan:Connect(function(i, g)
    if not g and (i.KeyCode == Enum.KeyCode.F1 or i.KeyCode == Enum.KeyCode.RightShift) then
        main.Visible = not main.Visible
    end
end)

fadeTo("Steal")

-- === Anti-Ban System ===
do
    local AntiBan = {
        Active = true,
        LastCheck = 0,
        RandomNames = {"CoreGui", "PlayerNotification", "ChatSystem", "MobileControls"},
        SafeCheck = function(self)
            if tick() - self.LastCheck < 30 then return true end
            self.LastCheck = tick()
            local unsafe = {"AntiCheat", "AC", "Badger", "VAC"}
            for _, name in pairs(unsafe) do
                if game:FindFirstChild(name) then return false end
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

    Players.PlayerRemoving:Connect(function(p)
        if p == player and AntiBan.Active then
            AntiBan:HandleKick(p.KickMessage)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.F4 and not gameProcessed and AntiBan.Active then
            gui.Enabled = not gui.Enabled
        end
    end)

    task.spawn(function()
        while AntiBan.Active and task.wait(10) do
            if not AntiBan:SafeCheck() then
                gui:Destroy()
                AntiBan.Active = false
                break
            end
            AntiBan:Camouflage()
        end
    end)

    local oldTween = TweenService.Create
    getgenv().TweenService = getgenv().TweenService or {}
    getgenv().TweenService.Create = function(self, ...)
        if AntiBan.Active and AntiBan:SafeCheck() then
            return oldTween(self, ...)
        end
        return nil
    end
end
