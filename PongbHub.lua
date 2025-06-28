-- PongbHub Ultimate Fix
-- Phiên bản ổn định cuối cùng

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ===== HỆ THỐNG BẢO MẬT =====
local Security = {
    Active = true,
    LastCheck = 0,
    RandomNames = {},
    SafeFunctions = {}
}

-- Tạo tên ngẫu nhiên
for i = 1, 5 do
    Security.RandomNames[i] = HttpService:GenerateGUID(false)
end

-- Kiểm tra anti-cheat
function Security:CheckSafety()
    if tick() - self.LastCheck < 30 then return true end
    self.LastCheck = tick()
    
    -- Kiểm tra dịch vụ anti-cheat
    local unsafe = {"AntiCheat", "AC", "Badger", "VAC"}
    for _, name in pairs(unsafe) do
        if pcall(function() return game:GetService(name) end) then
            return false
        end
    end
    
    return true
end

-- ===== THIẾT LẬP GUI =====
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = Security.RandomNames[1]
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true

-- Corner
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Text = "PongbHub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold

-- Status Label
local statusLabel = Instance.new("TextLabel", titleBar)
statusLabel.Size = UDim2.new(0, 150, 1, 0)
statusLabel.Position = UDim2.new(1, -150, 0, 0)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- ===== TÍNH NĂNG CHÍNH =====
-- NoClip
local noClipActive = false

local function safeNoClip()
    while noClipActive and player.Character do
        if player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid:ChangeState(11) -- Freeze state
        end
        
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Velocity = Vector3.new(0, 0, 0)
            end
        end
        RunService.Stepped:Wait()
    end
end

-- Server Hop
local function safeHop()
    local gameId = 109983668079237
    local servers = {}
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?limit=100"
        ))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(gameId, servers[math.random(1, #servers)])
        else
            TeleportService:Teleport(gameId)
        end
    else
        TeleportService:Teleport(gameId)
    end
end

-- ===== NÚT CHỨC NĂNG =====
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        if Security.Active then
            pcall(callback)
        end
    end)
    
    return btn
end

-- NoClip Button
local noClipBtn = createButton("NO CLIP (F3)", 0.15, function()
    noClipActive = not noClipActive
    if noClipActive then
        noClipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "NO CLIP ACTIVE"
        spawn(safeNoClip)
    else
        noClipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        statusLabel.Text = ""
    end
end)

-- Server Hop Button
local hopBtn = createButton("SERVER HOP (F4)", 0.3, safeHop)

-- Rejoin Button
local rejoinBtn = createButton("REJOIN GAME", 0.45, function()
    TeleportService:Teleport(game.PlaceId)
end)

-- ===== XỬ LÝ SỰ KIỆN =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F3 then
        noClipActive = not noClipActive
        if noClipActive then
            noClipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "NO CLIP ACTIVE"
            spawn(safeNoClip)
        else
            noClipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            statusLabel.Text = ""
        end
    elseif input.KeyCode == Enum.KeyCode.F4 then
        safeHop()
    end
end)

-- ===== KÉO THẢ GUI =====
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
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
        updateInput(input)
    end
end)

-- ===== KIỂM TRA BẢO MẬT ĐỊNH KỲ =====
spawn(function()
    while Security.Active do
        Security.Active = Security:CheckSafety()
        if not Security.Active then
            gui:Destroy()
            break
        end
        wait(30)
    end
end)
