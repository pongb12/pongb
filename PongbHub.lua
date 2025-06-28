-- PongbHub Enhanced
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

-- === Anti-Ban System ===
local AntiBan = {
    _VERSION = "2.1",
    _safeFunctions = {},
    
    _randomString = function(length)
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local str = ""
        for i = 1, length do
            str = str .. string.sub(chars, math.random(1, #chars))
        end
        return str
    end,
    
    execute = function(self, func, ...)
        task.wait(math.random(1, 5) * 0.1) -- Random delay
        local success, result = pcall(function()
            local tempName = self._randomString(8)
            _G[tempName] = func
            local r = _G[tempName](...)
            _G[tempName] = nil
            return r
        end)
        return success and result or nil
    end,
    
    register = function(self, funcTable)
        for k, v in pairs(funcTable) do
            self._safeFunctions[self._randomString(12)] = v
        end
    end
}

AntiBan:register({
    notify = function(title, text)
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2,
            Icon = "rbxassetid://6726575885"
        })
    end,
    
    teleport = function(cframe)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cframe
        end
    end
})

-- === Language Settings ===
local lang = "vi"
local texts = {
    vi = {
        Title = "PongbHub",
        SaveCP = "Lưu Checkpoint",
        SelectCP = "Chọn Checkpoint ▼",
        AutoSteal = "Auto Steal",
        Rejoin = "Vào lại server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Xoá GUI",
        LangSwitch = "Ngôn ngữ",
        WalkSpeed = "Tốc độ di chuyển",
        NoClip = "Xuyên rào cản",
        CPSaved = "Đã lưu checkpoint!",
        CPTeled = "Đã dịch chuyển!",
        CurrentSpeed = "Tốc độ: ",
        SetSpeed = "Áp dụng",
        SpeedUpdated = "Đã đặt tốc độ: ",
        ActiveFeature = "TÍNH NĂNG ĐANG BẬT: ",
        DeleteCP = "Xóa CP hiện tại",
        CPList = "Danh sách CP:",
        AutoStealComplete = "Auto Steal hoàn thành!",
        Misc = "Misc",
        Setting = "Cài đặt",
        JobPlaceholder = "Nhập Job ID"
    },
    en = {
        Title = "PongbHub",
        SaveCP = "Save Checkpoint",
        SelectCP = "Select Checkpoint ▼",
        AutoSteal = "Auto Steal",
        Rejoin = "Rejoin Server",
        Hop = "Hop Server",
        Join = "Join Job ID",
        DeleteGUI = "Delete GUI",
        LangSwitch = "Language",
        WalkSpeed = "Walk Speed",
        NoClip = "NoClip",
        CPSaved = "Checkpoint saved!",
        CPTeled = "Teleported!",
        CurrentSpeed = "Speed: ",
        SetSpeed = "Apply",
        SpeedUpdated = "Speed set to: ",
        ActiveFeature = "ACTIVE FEATURE: ",
        DeleteCP = "Delete Current CP",
        CPList = "CP List:",
        AutoStealComplete = "Auto Steal complete!",
        Misc = "Misc",
        Setting = "Settings",
        JobPlaceholder = "Enter Job ID"
    }
}

-- === Global Variables ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local isGUIMaximized = false
local flyHeight = 5
local flySpeed = 35
local gameId = 109983668079237

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Title Bar with Tabs
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Text = texts[lang].Title
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local tabSteal = Instance.new("TextButton", titleBar)
tabSteal.Size = UDim2.new(0.2, 0, 1, 0)
tabSteal.Position = UDim2.new(0.6, 0, 0, 0)
tabSteal.Text = "Steal"
tabSteal.TextColor3 = Color3.new(1, 1, 1)
tabSteal.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local tabMisc = Instance.new("TextButton", titleBar)
tabMisc.Size = UDim2.new(0.2, 0, 1, 0)
tabMisc.Position = UDim2.new(0.8, 0, 0, 0)
tabMisc.Text = texts[lang].Misc
tabMisc.TextColor3 = Color3.new(1, 1, 1)
tabMisc.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Content Frames
local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1

local stealFrame = Instance.new("ScrollingFrame", contentFrame)
stealFrame.Size = UDim2.new(1, 0, 1, 0)
stealFrame.Visible = true
stealFrame.BackgroundTransparency = 1
stealFrame.ScrollBarThickness = 4
stealFrame.CanvasSize = UDim2.new(0, 0, 0, 600)

local miscFrame = Instance.new("ScrollingFrame", contentFrame)
miscFrame.Size = UDim2.new(1, 0, 1, 0)
miscFrame.Visible = false
miscFrame.BackgroundTransparency = 1
miscFrame.ScrollBarThickness = 4
miscFrame.CanvasSize = UDim2.new(0, 0, 0, 400)

local settingFrame = Instance.new("ScrollingFrame", contentFrame)
settingFrame.Size = UDim2.new(1, 0, 1, 0)
settingFrame.Visible = false
settingFrame.BackgroundTransparency = 1
settingFrame.ScrollBarThickness = 4
settingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)

-- Tab Switching
local function showTab(tab)
    stealFrame.Visible = tab == "steal"
    miscFrame.Visible = tab == "misc"
    settingFrame.Visible = tab == "setting"
    
    tabSteal.BackgroundColor3 = tab == "steal" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    tabMisc.BackgroundColor3 = tab == "misc" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
end

tabSteal.MouseButton1Click:Connect(function()
    showTab("steal")
end)

tabMisc.MouseButton1Click:Connect(function()
    showTab("misc")
end)

-- === Steal Tab Content ===
local function createButton(frame, name, posY, callback, isToggle)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Text = texts[lang][name] or name
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)
    
    if isToggle then
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(60, 60, 60)
            AntiBan:execute(callback, active)
        end)
    else
        btn.MouseButton1Click:Connect(function()
            AntiBan:execute(callback)
        end)
    end
    
    return btn
end

-- Checkpoint System
local cpDropdown = createButton(stealFrame, "SelectCP", 40, function() end)

local cpListFrame = Instance.new("Frame", stealFrame)
cpListFrame.Size = UDim2.new(0.9, 0, 0, 150)
cpListFrame.Position = UDim2.new(0.05, 0, 0, 80)
cpListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cpListFrame.Visible = false

local cpListLayout = Instance.new("UIListLayout", cpListFrame)
cpListLayout.Padding = UDim.new(0, 5)

local function updateCPDropdown()
    cpDropdown.Text = texts[lang].SelectCP.." ("..#cp..")"
end

local function createCPButton(index, cframe)
    local btn = Instance.new("TextButton", cpListFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = "CP "..index..": "..math.floor(cframe.X)..", "..math.floor(cframe.Y)..", "..math.floor(cframe.Z)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        currentCPIndex = index
        AntiBan:execute(function()
            AntiBan:get("teleport")(cframe)
            AntiBan:get("notify")(texts[lang].Title, texts[lang].CPTeled)
        end)
        cpListFrame.Visible = false
    end)
end

local function saveCurrentCP()
    AntiBan:execute(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then 
            table.insert(cp, hrp.CFrame)
            createCPButton(#cp, hrp.CFrame)
            updateCPDropdown()
            AntiBan:get("notify")(texts[lang].Title, texts[lang].CPSaved)
        end
    end)
end

cpDropdown.MouseButton1Click:Connect(function()
    cpListFrame.Visible = not cpListFrame.Visible
end)

createButton(stealFrame, "SaveCP", 0, saveCurrentCP)

-- Auto Steal
createButton(stealFrame, "AutoSteal", 240, function(active)
    autoStealActive = active
    if active and #cp > 0 then
        spawn(function()
            while autoStealActive and #cp > 0 do
                AntiBan:execute(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bodyVelocity = Instance.new("BodyVelocity", hrp)
                        bodyVelocity.Velocity = Vector3.new(0, flyHeight, 0)
                        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                        
                        local direction = (cp[currentCPIndex].Position - hrp.Position).Unit
                        bodyVelocity.Velocity = direction * flySpeed
                        
                        task.wait(1)
                        bodyVelocity:Destroy()
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, true)

-- NoClip
createButton(stealFrame, "NoClip", 280, function(active)
    noClipActive = active
    if active then
        spawn(function()
            while noClipActive do
                AntiBan:execute(function()
                    if player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
end, true)

-- === Misc Tab Content ===
createButton(miscFrame, "Rejoin", 0, function()
    AntiBan:execute(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)
end)

createButton(miscFrame, "Hop", 40, function()
    AntiBan:execute(function()
        TeleportService:Teleport(gameId)
    end)
end)

local jobBox = Instance.new("TextBox", miscFrame)
jobBox.Size = UDim2.new(0.9, 0, 0, 30)
jobBox.Position = UDim2.new(0.05, 0, 0, 80)
jobBox.PlaceholderText = texts[lang].JobPlaceholder
jobBox.Text = ""
jobBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jobBox.TextColor3 = Color3.new(1, 1, 1)

createButton(miscFrame, "Join", 120, function()
    if jobBox.Text ~= "" then
        AntiBan:execute(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobBox.Text)
        end)
    end
end)

createButton(miscFrame, "DeleteGUI", 160, function()
    gui:Destroy()
end)

-- === Setting Tab Content ===
local speedLabel = Instance.new("TextLabel", settingFrame)
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 20)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("TextBox", settingFrame)
speedSlider.Size = UDim2.new(0.6, 0, 0, 30)
speedSlider.Position = UDim2.new(0.05, 0, 0, 50)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-100"
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)

local speedBtn = createButton(settingFrame, "SetSpeed", 50, function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
        walkSpeed = newSpeed
        speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
        AntiBan:execute(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        end)
        AntiBan:get("notify")(texts[lang].Title, texts[lang].SpeedUpdated..walkSpeed)
    end
end)
speedBtn.Size = UDim2.new(0.3, 0, 0, 30)
speedBtn.Position = UDim2.new(0.65, 0, 0, 50)

createButton(settingFrame, "LangSwitch", 100, function()
    lang = lang == "vi" and "en" or "vi"
    -- Update all texts
    for _, frame in pairs({stealFrame, miscFrame, settingFrame}) do
        for _, child in pairs(frame:GetChildren()) do
            if child:IsA("TextButton") and texts[lang][child.Name] then
                child.Text = texts[lang][child.Name]
            end
        end
    end
    title.Text = texts[lang].Title
    tabMisc.Text = texts[lang].Misc
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
end)

-- === GUI Dragging ===
local dragging, dragInput, dragStart, startPos

main.InputBegan:Connect(function(input)
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

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initialize
showTab("steal")
updateCPDropdown()
