-- PongbHub Premium - Auto Steal Tycoon, NoClip, Speed Control
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PongbHub_Pro"
gui.ResetOnSpawn = false

-- Cấu hình ngôn ngữ
local lang = "vi"
local texts = {
    vi = {
        Title = "PONGHUB PREMIUM",
        SaveCP = "LƯU VỊ TRÍ",
        TeleCP = "DỊCH CHUYỂN",
        AutoSteal = "AUTO STEAL",
        Rejoin = "VÀO LẠI SERVER",
        Hop = "ĐỔI SERVER",
        Join = "JOIN JOB ID",
        DeleteGUI = "XÓA GUI",
        SelectTycoon = "CHỌN NHÀ",
        WalkSpeed = "TỐC ĐỘ: ",
        NoClip = "XUYÊN TƯỜNG",
        CenterGUI = "CĂN GIỮA",
        StealStatus = "TRẠNG THÁI: TẮT"
    },
    en = {
        Title = "PONGHUB PREMIUM",
        SaveCP = "SAVE LOCATION",
        TeleCP = "TELEPORT",
        AutoSteal = "AUTO STEAL",
        Rejoin = "REJOIN SERVER",
        Hop = "SERVER HOP",
        Join = "JOIN JOB ID",
        DeleteGUI = "DELETE GUI",
        SelectTycoon = "SELECT TYCOON",
        WalkSpeed = "SPEED: ",
        NoClip = "NOCLIP",
        CenterGUI = "CENTER GUI",
        StealStatus = "STATUS: OFF"
    }
}

-- Tạo GUI chính
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 400)
main.Position = UDim2.new(0.5, -225, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Thanh tiêu đề
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = texts[lang].Title
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Hệ thống tab
local tabs = {
    Steal = {Frame = Instance.new("Frame", main), Name = "Steal"},
    Misc = {Frame = Instance.new("Frame", main), Name = "Misc"},
    Settings = {Frame = Instance.new("Frame", main), Name = "Settings"}
}

for name, tab in pairs(tabs) do
    tab.Frame.Size = UDim2.new(1, -20, 1, -60)
    tab.Frame.Position = UDim2.new(0, 10, 0, 50)
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.Visible = false
end

-- Nút chuyển tab
local tabButtons = {}
local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.3, 0, 0, 30)
    btn.Position = UDim2.new(posX, 0, 0, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Frame.Visible = false
        end
        tabs[name].Frame.Visible = true
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

createTabButton("Steal", 0.02)
createTabButton("Misc", 0.35)
createTabButton("Settings", 0.68)

-- Tab Steal
local cp
local function createButton(parent, text, posY, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Hệ thống Checkpoint
createButton(tabs.Steal.Frame, texts[lang].SaveCP, 20, function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        cp = player.Character.HumanoidRootPart.CFrame
    end
end)

createButton(tabs.Steal.Frame, texts[lang].TeleCP, 70, function()
    if cp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cp
    end
end)

-- Hệ thống Auto Steal Tycoon
local selectedTycoon = nil
local autoStealActive = false
local autoStealBtn = createButton(tabs.Steal.Frame, texts[lang].AutoSteal, 120, function()
    autoStealActive = not autoStealActive
    autoStealBtn.Text = texts[lang].AutoSteal .. " " .. (autoStealActive and "ON" or "OFF")
    
    if autoStealActive then
        spawn(function()
            while autoStealActive and task.wait(1) do
                if selectedTycoon and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    local targetPos = selectedTycoon:GetModelCFrame().Position
                    
                    -- Tìm spampoint trong tycoon
                    for _, child in pairs(selectedTycoon:GetDescendants()) do
                        if child.Name:lower():find("spawn") or child.Name:lower():find("spampoint") then
                            targetPos = child.Position
                            break
                        end
                    end
                    
                    humanoid:MoveTo(targetPos)
                end
            end
        end)
    end
end)

-- Dropdown chọn Tycoon
local dropdown = Instance.new("Frame", tabs.Steal.Frame)
dropdown.Size = UDim2.new(1, -20, 0, 40)
dropdown.Position = UDim2.new(0, 10, 0, 180)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Instance.new("UICorner", dropdown)

local dropdownText = Instance.new("TextLabel", dropdown)
dropdownText.Size = UDim2.new(0.8, 0, 1, 0)
dropdownText.Text = texts[lang].SelectTycoon
dropdownText.TextColor3 = Color3.new(1, 1, 1)

local dropdownBtn = Instance.new("TextButton", dropdown)
dropdownBtn.Size = UDim2.new(0.2, 0, 1, 0)
dropdownBtn.Position = UDim2.new(0.8, 0, 0, 0)
dropdownBtn.Text = "▼"
dropdownBtn.TextColor3 = Color3.new(1, 1, 1)

local dropdownList = Instance.new("ScrollingFrame", tabs.Steal.Frame)
dropdownList.Size = UDim2.new(1, -20, 0, 150)
dropdownList.Position = UDim2.new(0, 10, 0, 230)
dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
dropdownList.Visible = false
Instance.new("UICorner", dropdownList)

local function updateTycoonList()
    dropdownList:ClearAllChildren()
    
    local tycoons = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name:find("Tycoon") or obj.Name:find("Base")) and obj:FindFirstChild("Owner") then
            table.insert(tycoons, obj)
        end
    end
    
    for i, tycoon in pairs(tycoons) do
        local btn = Instance.new("TextButton", dropdownList)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*35)
        btn.Text = tycoon.Owner.Value and tycoon.Owner.Value.Name or "Unknown"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            selectedTycoon = tycoon
            dropdownText.Text = btn.Text
            dropdownList.Visible = false
        end)
    end
end

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
    if dropdownList.Visible then
        updateTycoonList()
    end
end)

-- Tab Misc
createButton(tabs.Misc.Frame, texts[lang].Rejoin, 20, function()
    TeleportService:Teleport(game.PlaceId)
end)

createButton(tabs.Misc.Frame, texts[lang].Hop, 70, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, "00000000000000000000000000000000")
end)

local jobBox = Instance.new("TextBox", tabs.Misc.Frame)
jobBox.Size = UDim2.new(1, -20, 0, 40)
jobBox.Position = UDim2.new(0, 10, 0, 120)
jobBox.PlaceholderText = texts[lang].Join
jobBox.TextColor3 = Color3.new(1, 1, 1)
jobBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Instance.new("UICorner", jobBox)

createButton(tabs.Misc.Frame, texts[lang].Join, 180, function()
    if jobBox.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobBox.Text)
    end
end)

-- Tab Settings
local noClipActive = false
createButton(tabs.Settings.Frame, texts[lang].NoClip, 20, function()
    noClipActive = not noClipActive
end)

local speedLabel = Instance.new("TextLabel", tabs.Settings.Frame)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 70)
speedLabel.Text = texts[lang].WalkSpeed .. "16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)

local speedSlider = Instance.new("Slider", tabs.Settings.Frame)
speedSlider.Size = UDim2.new(1, -20, 0, 20)
speedSlider.Position = UDim2.new(0, 10, 0, 100)
speedSlider.MinValue = 16
speedSlider.MaxValue = 100
speedSlider.Value = 16

speedSlider.Changed:Connect(function()
    local speed = math.floor(speedSlider.Value)
    speedLabel.Text = texts[lang].WalkSpeed .. speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

createButton(tabs.Settings.Frame, texts[lang].CenterGUI, 150, function()
    main.Position = UDim2.new(0.5, -225, 0.5, -200)
end)

createButton(tabs.Settings.Frame, texts[lang].DeleteGUI, 200, function()
    gui:Destroy()
end)

-- Hệ thống NoClip
RunService.Stepped:Connect(function()
    if noClipActive and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1: Ẩn/hiện GUI
    if input.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    end
    
    -- F2: Dừng Auto Steal khẩn cấp
    if input.KeyCode == Enum.KeyCode.F2 and autoStealActive then
        autoStealActive = false
        autoStealBtn.Text = texts[lang].AutoSteal .. " OFF"
    end
end)

-- Khởi tạo
tabs.Steal.Frame.Visible = true

-- Anti-ban/kick system (thêm cuối file, không thay đổi code cũ)
do
    local AntiBan = {
        Active = true,
        LastCheck = 0,
        
        RandomNames = {"CoreGui", "PlayerNotification", "ChatSystem", "MobileControls"},
        
        SafeCheck = function(self)
            -- Chỉ kiểm tra mỗi 30 giây
            if tick() - self.LastCheck < 30 then return true end
            self.LastCheck = tick()
            
            -- Kiểm tra anti-cheat
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
                task.wait(300) -- Đợi 5 phút
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
            end
        end,
        
        Camouflage = function(self)
            -- Ngẫu nhiên hoá tên GUI
            if math.random(1, 100) == 1 then
                gui.Name = self.RandomNames[math.random(1, #self.RandomNames)]
            end
            
            -- Fake hành vi
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if math.random(1, 50) == 1 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    }

    -- Xử lý khi bị kick
    game:GetService("Players").PlayerRemoving:Connect(function(p)
        if p == player and AntiBan.Active then
            AntiBan:HandleKick(p.KickMessage)
        end
    end)

    -- Ẩn GUI khẩn cấp
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.F4 and not gameProcessed and AntiBan.Active then
            gui.Enabled = not gui.Enabled
        end
    end)

    -- Bảo vệ liên tục
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

    -- Ghi đè an toàn các hàm teleport
    local oldTween = TweenService.Create
    getgenv().TweenService.Create = function(self, ...)
        if AntiBan.Active and AntiBan:SafeCheck() then
            return oldTween(self, ...)
        end
        return nil
    end
end

-- ===== KẾT THÚC PHẦN THÊM VÀO =====
