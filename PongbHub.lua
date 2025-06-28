-- PongbHub Ultimate
-- Phiên bản bảo mật cao với đầy đủ tính năng chống phát hiện

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ======= HỆ THỐNG CHỐNG PHÁT HIỆN =======
local secure = {
    randomNames = {},
    lastCheck = 0,
    safeFunctions = {},
    active = true
}

-- Tạo tên ngẫu nhiên cho các thành phần
local function generateRandomName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name = ""
    for i = 1, 12 do
        name = name .. string.sub(chars, math.random(1, #chars), 1)
    end
    return name
end

-- Đặt tên ngẫu nhiên cho các thành phần chính
for i = 1, 5 do
    secure.randomNames[i] = generateRandomName()
end

-- Hàm gọi an toàn
function secure.safeCall(func, ...)
    if not secure.active then return nil end
    local success, result = pcall(func, ...)
    if not success then
        warn(secure.randomNames[1] .. ": " .. result)
        return nil
    end
    return result
end

-- Kiểm tra anti-cheat
function secure.antiCheatCheck()
    if tick() - secure.lastCheck < math.random(15, 30) then return true end
    secure.lastCheck = tick()
    
    -- Thay đổi tên hàm ngẫu nhiên
    secure.safeFunctions[generateRandomName()] = secure.safeCall
    secure.safeFunctions[generateRandomName()] = secure.antiCheatCheck
    
    -- Kiểm tra dịch vụ anti-cheat
    local unsafeServices = {"AntiCheat", "AC", "Badger", "VAC", "Kick", "Ban"}
    for _, name in pairs(unsafeServices) do
        if pcall(function() return game:GetService(name) end) then
            return false
        end
    end
    
    -- Kiểm tra script anti-cheat
    for _, v in pairs(getnilinstances()) do
        if v:IsA("LocalScript") and (v.Name:find("Anti") or v.Name:find("AC")) then
            return false
        end
    end
    
    return true
end

-- Xử lý khi bị kick
function secure.handleKick(message)
    if message and (message:find("BAC%-10261") or message:find("Kick") or message:find("Ban")) then
        task.wait(math.random(200, 400)) -- Delay ngẫu nhiên
        TeleportService:Teleport(game.PlaceId)
    end
end

-- ======= THIẾT LẬP GUI AN TOÀN =======
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = secure.randomNames[2]
gui.ResetOnSpawn = false

-- ======= NO CLIP CẢI TIẾN =======
local noClipActive = false

local function enhancedNoClip()
    while noClipActive and player.Character do
        secure.safeCall(function()
            -- Sử dụng trạng thái Freeze để tránh bị phát hiện
            if player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character.Humanoid:ChangeState(11) -- Freeze state
            end
            
            -- Reset velocity và tắt collision
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        RunService.Stepped:Wait()
    end
end

-- ======= SERVER HOP NÂNG CAO =======
local function safeServerHop()
    secure.safeCall(function()
        local gameId = 109983668079237
        local servers = {}
        
        -- Lấy danh sách server từ API
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?limit=100"
            ))
        end)
        
        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
            
            -- Chọn server ngẫu nhiên
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(gameId, servers[math.random(1, #servers)])
            else
                TeleportService:Teleport(gameId)
            end
        else
            TeleportService:Teleport(gameId)
        end
    end)
end

-- ======= GIAO DIỆN THÔNG MINH =======
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Name = secure.randomNames[3]

-- Thanh tiêu đề thông minh
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Name = secure.randomNames[4]

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Text = "PongbHub Secure"
title.TextColor3 = Color3.new(1, 1, 1)

-- Hiển thị tính năng đang bật
local activeFeatureLabel = Instance.new("TextLabel", titleBar)
activeFeatureLabel.Size = UDim2.new(0, 150, 1, 0)
activeFeatureLabel.Position = UDim2.new(1, -150, 0, 0)
activeFeatureLabel.Text = ""
activeFeatureLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
activeFeatureLabel.TextXAlignment = Enum.TextXAlignment.Right

local function updateActiveFeatures()
    local features = {}
    if noClipActive then table.insert(features, "NO CLIP") end
    activeFeatureLabel.Text = table.concat(features, " | ")
end

-- Nút NoClip cải tiến
local noClipBtn = Instance.new("TextButton", main)
noClipBtn.Size = UDim2.new(0.9, 0, 0, 30)
noClipBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
noClipBtn.Text = "NO CLIP (F3)"
noClipBtn.Name = secure.randomNames[5]

noClipBtn.MouseButton1Click:Connect(function()
    noClipActive = not noClipActive
    if noClipActive then
        noClipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        secure.safeCall(enhancedNoClip)
    else
        noClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    updateActiveFeatures()
end)

-- Nút Server Hop
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.9, 0, 0, 30)
hopBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
hopBtn.Text = "SERVER HOP (F4)"

hopBtn.MouseButton1Click:Connect(function()
    secure.safeCall(safeServerHop)
end)

-- ======= XỬ LÝ SỰ KIỆN =======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F3 then
        noClipActive = not noClipActive
        if noClipActive then
            noClipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            secure.safeCall(enhancedNoClip)
        else
            noClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        updateActiveFeatures()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        secure.safeCall(safeServerHop)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if p == player then
        secure.safeCall(secure.handleKick, p.KickMessage)
    end
end)

-- ======= TỰ ĐỘNG KIỂM TRA =======
spawn(function()
    while secure.active do
        secure.active = secure.safeCall(secure.antiCheatCheck)
        if not secure.active then
            gui:Destroy()
            break
        end
        wait(math.random(15, 30)) -- Kiểm tra ngẫu nhiên
    end
end)

-- ======= ĐIỀU CHỈNH MOBILE =======
if UserInputService.TouchEnabled then
    main.Position = UDim2.new(0.5, 0, 0.2, 0)
    main.Size = UDim2.new(0, 380, 0, 350)
end
