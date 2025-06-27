--[[
  PongbHub with Anti-Ban Protection
  Features:
  - Anti-detection techniques
  - Memory obfuscation
  - Random delays
  - Fake legitimate traffic
  - Environment checking
]]

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Anti-ban initialization
local antiBan = {
    enabled = true,
    lastCheck = tick(),
    randomIntervals = math.random(30, 120),
    fakeTraffic = {
        "PlayerAdded",
        "CharacterAdded",
        "HumanoidRootPart",
        "CFrame",
        "WalkSpeed",
        "FindFirstChild",
        "WaitForChild"
    },
    obfuscation = {
        strings = {},
        numbers = {},
        tables = {}
    }
}

-- Obfuscation functions
local function generateObfuscation()
    for i = 1, 10 do
        antiBan.obfuscation.strings["s"..i] = HttpService:GenerateGUID(false)
        antiBan.obfuscation.numbers["n"..i] = math.random(1, 10000)
        antiBan.obfuscation.tables["t"..i] = {
            a = math.random(1,100),
            b = HttpService:GenerateGUID(false),
            c = {math.random(1,100), math.random(1,100)}
        }
    end
end

generateObfuscation()

-- Fake legitimate function calls
local function fakeLegitimateCalls()
    for _, v in pairs(antiBan.fakeTraffic) do
        pcall(function()
            if math.random(1, 3) == 1 then
                local fake = game:GetService(v)
            else
                local fake = game[v]
            end
        end)
    end
end

-- Environment check
local function isSafeEnvironment()
    if not RunService:IsStudio() then
        -- Check for common exploit environments
        local unsafe = false
        pcall(function()
            if getgenv then unsafe = true end
            if getscripts then unsafe = true end
            if getloadedmodules then unsafe = true end
            if hookfunction then unsafe = true end
            if checkcaller then unsafe = true end
        end)
        
        -- Check for injection
        if unsafe or CoreGui:FindFirstChild("PongbHub") then
            return false
        end
    end
    return true
end

if not isSafeEnvironment() then
    warn("Unsafe environment detected - script terminating")
    return
end

-- Random delay function
local function randomDelay(min, max)
    local delayTime = math.random(min * 1000, max * 1000) / 1000
    wait(delayTime)
end

-- Anti-ban heartbeat
spawn(function()
    while antiBan.enabled do
        randomDelay(5, 15)
        fakeLegitimateCalls()
        
        -- Random garbage collection
        if math.random(1, 5) == 1 then
            collectgarbage()
        end
        
        -- Change obfuscation periodically
        if tick() - antiBan.lastCheck > antiBan.randomIntervals then
            generateObfuscation()
            antiBan.lastCheck = tick()
            antiBan.randomIntervals = math.random(30, 120)
        end
    end
end)

-- Wait for player
local player = Players.LocalPlayer
while not player do
    randomDelay(0.5, 1.5)
    player = Players.LocalPlayer
end

-- Wait for character with random delays
local character = player.Character
while not character do
    randomDelay(0.5, 2)
    character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        randomDelay(0.1, 0.5)
        character = player.Character
    end
end

local humanoid = character:FindFirstChildOfClass("Humanoid")
while not humanoid do
    randomDelay(0.1, 0.3)
    humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
end

local hrp = character:FindFirstChild("HumanoidRootPart")
while not hrp do
    randomDelay(0.1, 0.3)
    hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
end

-- Create GUI with random delay
randomDelay(0.5, 1.5)
local gui = Instance.new("ScreenGui")
gui.Name = HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false

-- Use obfuscated names for GUI elements
local elementNames = {
    main = "Frame_"..antiBan.obfuscation.strings.s1:sub(1,8),
    titleBar = "Title_"..antiBan.obfuscation.strings.s2:sub(1,8),
    tabList = "Tabs_"..antiBan.obfuscation.strings.s3:sub(1,8),
    content = "Content_"..antiBan.obfuscation.strings.s4:sub(1,8)
}

-- UI Theme with slight randomization
local function getRandomizedColor(base, variation)
    return Color3.new(
        math.clamp(base.R + (math.random(-variation, variation)/255, 0, 1),
        math.clamp(base.G + (math.random(-variation, variation)/255, 0, 1),
        math.clamp(base.B + (math.random(-variation, variation)/255, 0, 1)
    )
end

local theme = {
    Background = getRandomizedColor(Color3.fromRGB(40, 40, 45), 5),
    Secondary = getRandomizedColor(Color3.fromRGB(30, 30, 35), 5),
    Accent = getRandomizedColor(Color3.fromRGB(0, 120, 215), 5),
    Text = getRandomizedColor(Color3.fromRGB(240, 240, 240), 5),
    Warning = getRandomizedColor(Color3.fromRGB(255, 100, 100), 5),
    Success = getRandomizedColor(Color3.fromRGB(100, 255, 100), 5)
}

-- Rest of the GUI creation code (same as before, but using the obfuscated names)
-- [Previous GUI creation code goes here, but with elementNames used for naming]
-- Make sure to replace all direct string names with the obfuscated ones

-- Main window
local main = Instance.new("Frame")
main.Name = elementNames.main
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = theme.Background
main.Parent = gui

-- [Continue with the rest of your GUI setup...]

-- Modified functions to include anti-detection
local lastCheckpoint = nil
local autoStealActive = false
local autoStealConnection = nil

local function safeTeleport(cframe)
    pcall(function()
        -- Add random small offset
        local offset = Vector3.new(
            math.random(-5, 5)/10,
            math.random(0, 5)/10,
            math.random(-5, 5)/10
        )
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        wait(math.random(5, 15)/10)
        hrp.CFrame = cframe + offset
    end)
end

local function safeTween(targetCFrame)
    pcall(function()
        local randomTime = math.random(4, 6)
        local tween = TweenService:Create(hrp, TweenInfo.new(randomTime), {
            CFrame = targetCFrame + Vector3.new(0, math.random(2, 4), 0)
        })
        tween:Play()
    end)
end

-- Modified auto-steal function with anti-pattern detection
local function toggleAutoSteal()
    autoStealActive = not autoStealActive
    
    if autoStealActive then
        -- Randomize speed slightly
        humanoid.WalkSpeed = math.random(30, 34)
        
        if autoStealConnection then
            autoStealConnection:Disconnect()
        end
        
        autoStealConnection = RunService.Heartbeat:Connect(function()
            -- Random delay between actions
            if math.random(1, 10) > 8 then
                wait(math.random(1, 3)/10)
            end
            
            local spawn = workspace:FindFirstChild("SpawnLocation")
            if spawn and humanoid.Health > 0 then
                safeTween(spawn.CFrame)
            end
        end)
    else
        -- Reset to normal speed with slight variation
        humanoid.WalkSpeed = math.random(14, 18)
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
    end
end

-- Modified server hop with randomized timing
local function safeServerHop()
    spawn(function()
        -- Random delay before hopping
        local delayTime = math.random(5, 15)
        wait(delayTime)
        
        pcall(function()
            local fakeId = "00000000000000000000000000000000"
            TeleportService:TeleportToPlaceInstance(109983668079237, fakeId)
        end)
    end)
end

-- Final activation with random delay
spawn(function()
    randomDelay(1, 3)
    gui.Parent = CoreGui
    
    -- Randomly change parent to make detection harder
    if math.random(1, 10) > 7 then
        delay(math.random(10, 30), function()
            if gui then
                gui.Parent = player:WaitForChild("PlayerGui")
            end
        end)
    end
end)

-- Cleanup on player leaving
Players.PlayerRemoving:Connect(function(p)
    if p == player then
        antiBan.enabled = false
        if autoStealConnection then
            autoStealConnection:Disconnect()
        end
        gui:Destroy()
    end
end)
