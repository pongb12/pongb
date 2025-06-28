--PongbHub --
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
        AutoSteal = "Auto Steal",
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
        AutoStealComplete = "Auto Steal hoàn thành!"
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
        AutoStealComplete = "Auto Steal complete!"
    }
}

-- === Global Variables ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local isGUIMaximized = false
local flyHeight = 5 -- Lower flying height
local flySpeed = 35
local activeFeatures = {}
local gameId = 109983668079237

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 300, 0, 350)
local maximizedGUISize = UDim2.new(0, 400, 0, 450)

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = originalGUISize
main.Position = UDim2.new(0.5, -150, 0.5, -175)
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

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Content Frame
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 600)

-- === Checkpoint System ===
local cpDropdown = Instance.new("TextButton", content)
cpDropdown.Size = UDim2.new(1, -10, 0, 30)
cpDropdown.Position = UDim2.new(0, 5, 0, 40)
cpDropdown.Text = texts[lang].SelectCP
cpDropdown.TextSize = 14
cpDropdown.Font = Enum.Font.Gotham
cpDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
cpDropdown.TextColor3 = Color3.new(1, 1, 1)

local cpDropdownCorner = Instance.new("UICorner", cpDropdown)
cpDropdownCorner.CornerRadius = UDim.new(0, 4)

local cpListFrame = Instance.new("Frame", main)
cpListFrame.Size = UDim2.new(1, -10, 0, 150)
cpListFrame.Position = UDim2.new(0, 5, 0, 75)
cpListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cpListFrame.Visible = false
cpListFrame.ZIndex = 2

local cpListLayout = Instance.new("UIListLayout", cpListFrame)
cpListLayout.Padding = UDim.new(0, 2)

local function updateCPDropdown()
    cpDropdown.Text = texts[lang].SelectCP.." ("..#cp..")"
end

local function createCPButton(index, cframe)
    local btn = Instance.new("TextButton", cpListFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Text = "CP "..index..": "..math.floor(cframe.X)..", "..math.floor(cframe.Y)..", "..math.floor(cframe.Z)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        currentCPIndex = index
        player.Character:FindFirstChild("HumanoidRootPart").CFrame = cframe
        cpListFrame.Visible = false
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CPTeled.." #"..index,
            Duration = 2
        })
    end)
    
    return btn
end

local function saveCurrentCP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        table.insert(cp, hrp.CFrame)
        createCPButton(#cp, hrp.CFrame)
        updateCPDropdown()
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CPSaved.." #"..#cp,
            Duration = 2
        })
    end
end

local function deleteCurrentCP()
    if #cp > 0 then
        table.remove(cp, currentCPIndex)
        cpListFrame:ClearAllChildren()
        for i, checkpoint in ipairs(cp) do
            createCPButton(i, checkpoint)
        end
        if #cp == 0 then
            cpListFrame.Visible = false
        end
        updateCPDropdown()
    end
end

cpDropdown.MouseButton1Click:Connect(function()
    if #cp > 0 then
        cpListFrame.Visible = not cpListFrame.Visible
    end
end)

-- === Auto Steal with Lower Height ===
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
    
    while autoStealActive and (tick() - startTime < distance / flySpeed * 1.5) do
        if not player.Character or not hrp or not bodyVelocity then break end
        
        local direction = (targetCFrame.Position - hrp.Position).Unit
        bodyVelocity.Velocity = direction * flySpeed
        
        -- Lower flying height adjustment
        local ray = Ray.new(hrp.Position, Vector3.new(0, -2.5, 0))
        local hit = workspace:FindPartOnRay(ray, player.Character)
        
        if hit then
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, flyHeight, bodyVelocity.Velocity.Z)
        else
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, 0, bodyVelocity.Velocity.Z)
        end
        
        RunService.Heartbeat:Wait()
    end
    
    if bodyVelocity then bodyVelocity:Destroy() end
    if humanoid then humanoid.PlatformStand = false end
    
    -- Auto-disable after reaching target
    if autoStealActive then
        autoStealActive = false
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].AutoStealComplete,
            Duration = 2
        })
    end
end

-- === NoClip Function ===
local function improvedNoClip()
    while noClipActive and player.Character do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        RunService.Stepped:Wait()
    end
end

-- === Create Buttons ===
local function createButton(name, posY, callback, isToggle)
    local btn = Instance.new("TextButton", content)
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

-- Save CP Button
createButton("SaveCP", 0, saveCurrentCP)

-- Delete CP Button
createButton("DeleteCP", 80, deleteCurrentCP)

-- Auto Steal Toggle
createButton("AutoSteal", 120, function(active)
    autoStealActive = active
    if active and #cp > 0 then
        flyToPosition(cp[currentCPIndex])
    end
end, true)

-- NoClip Toggle
createButton("NoClip", 160, function(active)
    noClipActive = active
    if active then
        spawn(improvedNoClip)
    end
end, true)

-- Speed Control
local speedLabel = Instance.new("TextLabel", content)
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 200)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("TextBox", content)
speedSlider.Size = UDim2.new(0.6, -5, 0, 30)
speedSlider.Position = UDim2.new(0, 5, 0, 220)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = "16-100"
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)

local speedBtn = createButton("SetSpeed", 220, function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
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
end)
speedBtn.Size = UDim2.new(0.4, -10, 0, 30)
speedBtn.Position = UDim2.new(0.6, 5, 0, 220)

-- Server Controls
createButton("Rejoin", 260, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

createButton("Hop", 300, function()
    TeleportService:Teleport(gameId)
end)

-- GUI Dragging
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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
        update(input)
    end
end)

-- Initialize
updateCPDropdown()
