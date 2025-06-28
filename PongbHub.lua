-- PongbHub Final Version
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PongbHub_"..math.random(10000,99999)
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

-- === ANTI-BAN SYSTEM ===
local AntiBan = {
    Active = true,
    LastCheck = 0,
    
    GenerateRandomName = function(self)
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return string.gsub(HttpService:GenerateGUID(false), "-", ""):sub(1,16)
    end,
    
    EnvironmentCheck = function(self)
        local unsafeServices = {"AntiCheat", "AC", "Badger", "VAC", "Watchdog"}
        for _, name in pairs(unsafeServices) do
            if pcall(function() return game:GetService(name) end) then
                return false, "Anti-Cheat service detected: "..name
            end
        end
        return true
    end,
    
    SafeCall = function(self, func, ...)
        if not self.Active then return end
        local success, result = pcall(func, ...)
        if not success then
            warn("[ANTI-BAN] Error: "..tostring(result))
        end
        return result
    end,
    
    ProtectionLoop = function(self)
        while self.Active do
            local safe, reason = self:EnvironmentCheck()
            if not safe then
                self:OnDetection(reason)
                break
            end
            wait(math.random(20, 40))
        end
    end,
    
    OnDetection = function(self, reason)
        warn("[ANTI-BAN] Triggered: "..reason)
        self.Active = false
        gui:Destroy()
    end
}

-- === LANGUAGE SETTINGS ===
local lang = "vi"
local texts = {
    vi = {
        Title = "PongbHub Premium",
        SaveCP = "Lưu Điểm",
        TeleCP = "Dịch Chuyển",
        DeleteCP = "Xóa Điểm",
        AutoSteal = "Tự Động",
        NoClip = "Xuyên Tường",
        CurrentCP = "Điểm hiện tại: ",
        NoCP = "Chưa có điểm nào!"
    },
    en = {
        Title = "PongbHub Premium",
        SaveCP = "Save Point",
        TeleCP = "Teleport",
        DeleteCP = "Delete Point",
        AutoSteal = "Auto Farm",
        NoClip = "NoClip",
        CurrentCP = "Current CP: ",
        NoCP = "No points saved!"
    }
}

-- === GLOBAL VARIABLES ===
local cp = {}
local currentCPIndex = 1
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16

-- === GUI CREATION ===
local function CreateMainGUI()
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 350, 0, 250)
    main.Position = UDim2.new(0.5, -175, 0.5, -125)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    main.Active = true
    main.Draggable = true
    main.Visible = true

    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(80, 80, 100)

    -- Title Bar
    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.Name = "TitleBar"

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Text = texts[lang].Title
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 10, 0, 0)

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.Text = "X"
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18

    -- Content Frame
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1

    -- CP Info Label
    local cpLabel = Instance.new("TextLabel", content)
    cpLabel.Size = UDim2.new(1, -10, 0, 20)
    cpLabel.Position = UDim2.new(0, 5, 0, 0)
    cpLabel.Text = texts[lang].NoCP
    cpLabel.TextSize = 14
    cpLabel.Font = Enum.Font.Gotham
    cpLabel.BackgroundTransparency = 1
    cpLabel.TextColor3 = Color3.new(1, 1, 1)
    cpLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Button Creation Function
    local function CreateButton(parent, text, position, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.48, 0, 0, 35)
        btn.Position = position
        btn.Text = text
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        btn.TextColor3 = Color3.new(1, 1, 1)
        
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            AntiBan:SafeCall(callback)
        end)
        
        return btn
    end

    -- Main Buttons
    CreateButton(content, texts[lang].SaveCP, UDim2.new(0, 5, 0, 25), SaveCP)
    CreateButton(content, texts[lang].TeleCP, UDim2.new(0.51, 5, 0, 25), TeleportToCP)
    CreateButton(content, texts[lang].DeleteCP, UDim2.new(0, 5, 0, 65), DeleteCP)
    CreateButton(content, texts[lang].AutoSteal, UDim2.new(0, 5, 0, 105), ToggleAutoSteal)
    CreateButton(content, texts[lang].NoClip, UDim2.new(0.51, 5, 0, 105), ToggleNoClip)

    -- Navigation Arrows
    local prevBtn = CreateButton(content, "<", UDim2.new(0, 5, 0, 145), PrevCP)
    local nextBtn = CreateButton(content, ">", UDim2.new(0.51, 5, 0, 145), NextCP)

    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = not gui.Enabled
    end)

    return main, cpLabel
end

-- === CORE FUNCTIONS ===
local function SaveCP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        table.insert(cp, hrp.CFrame)
        currentCPIndex = #cp
        UpdateCPLabel()
        Notify(texts[lang].Title, texts[lang].SaveCP.." #"..#cp)
    end
end

local function TeleportToCP()
    if #cp > 0 then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cp[currentCPIndex]
            Notify(texts[lang].Title, texts[lang].TeleCP.." #"..currentCPIndex)
        end
    end
end

local function DeleteCP()
    if #cp > 0 then
        table.remove(cp, currentCPIndex)
        if currentCPIndex > #cp then currentCPIndex = #cp end
        if #cp == 0 then currentCPIndex = 1 end
        UpdateCPLabel()
        Notify(texts[lang].Title, texts[lang].DeleteCP)
    end
end

local function ToggleAutoSteal()
    autoStealActive = not autoStealActive
    if autoStealActive then
        spawn(function()
            while autoStealActive and #cp > 0 do
                TeleportToCP()
                wait(1)
                currentCPIndex = currentCPIndex % #cp + 1
                UpdateCPLabel()
                wait(1)
            end
            autoStealActive = false
        end)
    end
end

local function ToggleNoClip()
    noClipActive = not noClipActive
    if noClipActive then
        spawn(function()
            while noClipActive and player.Character do
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                RunService.Stepped:Wait()
            end
        end)
    end
end

local function PrevCP()
    if #cp > 0 then
        currentCPIndex = (currentCPIndex - 2) % #cp + 1
        UpdateCPLabel()
    end
end

local function NextCP()
    if #cp > 0 then
        currentCPIndex = currentCPIndex % #cp + 1
        UpdateCPLabel()
    end
end

local function UpdateCPLabel()
    if #cp > 0 then
        cpLabel.Text = texts[lang].CurrentCP..currentCPIndex.."/"..#cp
    else
        cpLabel.Text = texts[lang].NoCP
    end
end

local function Notify(title, message)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = 2,
        Icon = "rbxassetid://6726575885"
    })
end

-- === INITIALIZATION ===
local mainFrame, cpLabel = CreateMainGUI()
spawn(function() AntiBan:ProtectionLoop() end)

-- Keyboard Shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        SaveCP()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        TeleportToCP()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        ToggleNoClip()
    end
end)

-- First run
UpdateCPLabel()
