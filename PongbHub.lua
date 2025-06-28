--PongbHub Optimized Version
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
        Title = "PongbHub Tối Ưu",
        SaveCP = "Tạo Checkpoint",
        TeleCP = "Dịch Chuyển",
        DeleteCP = "Xóa Checkpoint",
        AutoSteal = "Auto Steal",
        Rejoin = "Vào lại server",
        Hop = "Đổi Server",
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
        CPSaved = "Đã tạo checkpoint mới!",
        CPTeled = "Đã dịch chuyển!",
        CPDeleted = "Đã xóa checkpoint!",
        ZoomGUI = "🗖",
        Shortcuts = "Phím tắt:",
        CurrentSpeed = "Tốc độ hiện tại: ",
        SetSpeed = "Áp dụng tốc độ",
        SpeedUpdated = "Đã đặt tốc độ thành: ",
        ActiveFeature = "TÍNH NĂNG ĐANG BẬT: ",
        SelectCP = "Chọn CP: ",
        NoCP = "Chưa có CP nào!"
    },
    en = {
        Title = "PongbHub Optimized",
        SaveCP = "Create Checkpoint",
        TeleCP = "Teleport",
        DeleteCP = "Delete Checkpoint",
        AutoSteal = "Auto Steal",
        Rejoin = "Rejoin Server",
        Hop = "Server Hop",
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
        CPSaved = "New checkpoint created!",
        CPTeled = "Teleported!",
        CPDeleted = "Checkpoint deleted!",
        ZoomGUI = "🗖",
        Shortcuts = "Shortcuts:",
        CurrentSpeed = "Current speed: ",
        SetSpeed = "Apply Speed",
        SpeedUpdated = "Speed set to: ",
        ActiveFeature = "ACTIVE FEATURE: ",
        SelectCP = "Select CP: ",
        NoCP = "No CP saved!"
    }
}

-- === Global Variables ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local isGUIMaximized = false
local flySpeed = 35
local activeFeatures = {}
local gameId = 109983668079237

-- GUI Size Settings
local originalGUISize = UDim2.new(0, 400, 0, 300) -- Gọn hơn
local maximizedGUISize = UDim2.new(0, 550, 0, 400)

-- === Main GUI ===
local main = Instance.new("Frame", gui)
main.Size = originalGUISize
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true -- Cho phép kéo di chuyển
main.Visible = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(80, 80, 80)

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

-- Content Frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -10, 1, -42)
content.Position = UDim2.new(0, 5, 0, 37)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

-- === Checkpoint System ===
local cpLabel = Instance.new("TextLabel", content)
cpLabel.Size = UDim2.new(1, -10, 0, 20)
cpLabel.Position = UDim2.new(0, 5, 0, 0)
cpLabel.Text = texts[lang].NoCP
cpLabel.TextSize = 14
cpLabel.Font = Enum.Font.Gotham
cpLabel.BackgroundTransparency = 1
cpLabel.TextColor3 = Color3.new(1, 1, 1)
cpLabel.TextXAlignment = Enum.TextXAlignment.Left

local function updateCPLabel()
    if #cp > 0 then
        cpLabel.Text = texts[lang].SelectCP..currentCPIndex.."/"..#cp
    else
        cpLabel.Text = texts[lang].NoCP
    end
end

local function saveCurrentCP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        table.insert(cp, hrp.CFrame)
        currentCPIndex = #cp
        updateCPLabel()
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CPSaved,
            Duration = 2
        })
    end
end

local function teleportToCP()
    if #cp > 0 then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cp[currentCPIndex]
            game.StarterGui:SetCore("SendNotification", {
                Title = texts[lang].Title,
                Text = texts[lang].CPTeled.." #"..currentCPIndex,
                Duration = 2
            })
        end
    end
end

local function deleteCurrentCP()
    if #cp > 0 then
        table.remove(cp, currentCPIndex)
        if currentCPIndex > #cp then currentCPIndex = #cp end
        if currentCPIndex < 1 then currentCPIndex = 1 end
        updateCPLabel()
        game.StarterGui:SetCore("SendNotification", {
            Title = texts[lang].Title,
            Text = texts[lang].CPDeleted,
            Duration = 2
        })
    end
end

-- === Buttons ===
local function createButton(parent, text, position, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.48, 0, 0, 36)
    btn.Position = position
    btn.Text = text
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Checkpoint Buttons
createButton(content, texts[lang].SaveCP, UDim2.new(0, 5, 0, 25), saveCurrentCP)
createButton(content, texts[lang].TeleCP, UDim2.new(0.51, 5, 0, 25), teleportToCP)
createButton(content, texts[lang].DeleteCP, UDim2.new(0, 5, 0, 65), deleteCurrentCP)

-- Navigation Buttons
local prevBtn = createButton(content, "<", UDim2.new(0, 5, 0, 105), function()
    if #cp > 0 then
        currentCPIndex = (currentCPIndex - 2) % #cp + 1
        updateCPLabel()
    end
end)

local nextBtn = createButton(content, ">", UDim2.new(0.51, 5, 0, 105), function()
    if #cp > 0 then
        currentCPIndex = currentCPIndex % #cp + 1
        updateCPLabel()
    end
end)

-- Auto Steal Button
local autoStealBtn = createButton(content, texts[lang].AutoSteal, UDim2.new(0, 5, 0, 145), function()
    autoStealActive = not autoStealActive
    if autoStealActive then
        autoStealBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        spawn(function()
            while autoStealActive and #cp > 0 do
                teleportToCP()
                wait(1)
                currentCPIndex = currentCPIndex % #cp + 1
                updateCPLabel()
                wait(1)
            end
            autoStealActive = false
            autoStealBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
    else
        autoStealBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- NoClip Button
local noClipBtn = createButton(content, texts[lang].NoClip, UDim2.new(0.51, 5, 0, 145), function()
    noClipActive = not noClipActive
    if noClipActive then
        noClipBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        spawn(function()
            while noClipActive and player.Character do
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                RunService.Stepped:Wait()
            end
            noClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
    else
        noClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- === GUI Zoom Function ===
zoomBtn.MouseButton1Click:Connect(function()
    isGUIMaximized = not isGUIMaximized
    if isGUIMaximized then
        main.Size = maximizedGUISize
        zoomBtn.Text = "🗗"
    else
        main.Size = originalGUISize
        zoomBtn.Text = texts[lang].ZoomGUI
    end
end)

-- === Keyboard Shortcuts ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    elseif input.KeyCode == Enum.KeyCode.F2 then
        isGUIMaximized = not isGUIMaximized
        if isGUIMaximized then
            main.Size = maximizedGUISize
            zoomBtn.Text = "🗗"
        else
            main.Size = originalGUISize
            zoomBtn.Text = texts[lang].ZoomGUI
        end
    elseif input.KeyCode == Enum.KeyCode.F3 then
        saveCurrentCP()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        teleportToCP()
    end
end)

-- === ANTI-BAN SYSTEM UPGRADED ===
local AntiBan = {
    Active = true,
    LastCheck = 0,
    SafeFunctions = {},
    RandomNames = {},
    
    -- Tạo tên ngẫu nhiên cho hàm
    GenerateRandomName = function(self)
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        local name = ""
        for i = 1, 16 do
            name = name .. string.sub(chars, math.random(1, #chars), 1)
        end
        return name
    end,
    
    -- Kiểm tra môi trường an toàn
    EnvironmentCheck = function(self)
        -- Quét các dịch vụ Anti-Cheat
        local unsafeServices = {
            "AntiCheat", "AC", "Badger", "VAC", "Kick", "Ban", 
            "Security", "ScriptScan", "Watchdog", "Guardian"
        }
        
        for _, name in pairs(unsafeServices) do
            if pcall(function() return game:GetService(name) end) then
                return false, "Phát hiện dịch vụ Anti-Cheat: "..name
            end
        end
        
        -- Kiểm tra script độc hại
        for _, v in pairs(getnilinstances()) do
            if v:IsA("LocalScript") and (v.Name:lower():find("anti") or v.Name:lower():find("scan")) then
                return false, "Phát hiện script giám sát: "..v.Name
            end
        end
        
        return true
    end,
    
    -- Xử lý khi bị phát hiện
    OnDetection = function(self, reason)
        warn("[ANTI-BAN] Cảnh báo: "..reason)
        
        -- Tự hủy GUI và xóa dấu vết
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.Text = ""
            end
            obj:Destroy()
        end
        gui:Destroy()
        
        -- Giả lập hành vi người chơi bình thường
        if player.Character then
            player.Character:BreakJoints()
        end
        
        self.Active = false
    end,
    
    -- Gọi hàm an toàn
    SafeCall = function(self, func, ...)
        if not self.Active then return end
        
        -- Đổi tên hàm ngẫu nhiên
        local funcName = self:GenerateRandomName()
        self.SafeFunctions[funcName] = func
        self.RandomNames[func] = funcName
        
        -- Thực thi với bẫy lỗi
        local success, result = pcall(function()
            return self.SafeFunctions[funcName](...)
        end)
        
        -- Dọn dẹp
        self.SafeFunctions[funcName] = nil
        self.RandomNames[func] = nil
        
        if not success then
            self:OnDetection("Lỗi khi thực thi: "..tostring(result))
        end
        
        return result
    end,
    
    -- Bảo vệ liên tục
    ProtectionLoop = function(self)
        while self.Active and task.wait(math.random(15, 30)) do
            local safe, reason = self:EnvironmentCheck()
            if not safe then
                self:OnDetection(reason)
                break
            end
            
            -- Ngẫu nhiên hóa bộ nhớ
            for func, name in pairs(self.RandomNames) do
                local newName = self:GenerateRandomName()
                self.SafeFunctions[newName] = func
                self.SafeFunctions[name] = nil
                self.RandomNames[func] = newName
            end
        end
    end
}

-- === KÍCH HOẠT ANTI-BAN ===
spawn(function()
    AntiBan:ProtectionLoop()
end)

-- === CẬP NHẬT CÁC HÀM QUAN TRỌNG ===
local function protectedSaveCP()
    AntiBan:SafeCall(saveCurrentCP)
end

local function protectedTeleCP()
    AntiBan:SafeCall(teleportToCP)
end

-- Thay thế các callback cũ bằng phiên bản đã bảo vệ
createButton(content, texts[lang].SaveCP, UDim2.new(0, 5, 0, 25), protectedSaveCP)
createButton(content, texts[lang].TeleCP, UDim2.new(0.51, 5, 0, 25), protectedTeleCP)

-- Initialize
updateCPLabel()
