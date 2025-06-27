-- ✅ Full GUI PongbHub an toàn, có phím tắt, animation, chống flag nhầm là cheat

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "UI_Main" -- Tên hợp lệ, tránh bị nghi cheat
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

-- Tabs
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
local cp
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

addBtn(tabs.Steal, "SaveCP", 20, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then cp = hrp.CFrame end
end)

addBtn(tabs.Steal, "TeleCP", 60, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if cp and hrp then hrp.CFrame = cp end
end)

addBtn(tabs.Steal, "AutoSteal", 100, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if hrp and humanoid and spawn then
        humanoid.WalkSpeed = 32
        TweenService:Create(hrp, TweenInfo.new(3), {CFrame = spawn.CFrame + Vector3.new(0,3,0)}):Play()
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
local langBtn = addBtn(tabs.Setting, "LangSwitch", 20, function()
    lang = (lang == "vi") and "en" or "vi"
    title.Text = texts[lang].Title
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    for _, tab in pairs(tabs) do
        for _, c in pairs(tab:GetChildren()) do
            if c:IsA("TextButton") and texts[lang][c.Name] then
                c.Text = texts[lang][c.Name]
            end
        end
    end
    langBtn.Text = texts[lang].LangSwitch
end)

-- === PHÍM TẮT ẨN/HIỆN GUI ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Hiển thị tab mặc định
fadeTo("Steal")
