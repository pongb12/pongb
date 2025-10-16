-- Universal Game Script with Uma UI Library
-- Fixed version with bug corrections

local UmaUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/pongb12/Uma-Ui-Library/refs/heads/main/source.lua'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local Settings = {
    Speed = {
        Enabled = false,
        Value = 16,
        Connection = nil
    },
    JumpPower = {
        Enabled = false,
        Value = 50,
        Connection = nil
    },
    FOV = {
        Default = workspace.CurrentCamera.FieldOfView,
        Value = 70
    },
    Fullbright = {
        Enabled = false,
        OriginalSettings = {}
    },
    ESP = {
        Enabled = false,
        Objects = {}
    },
    AutoFarm = {
        Enabled = false,
        Connection = nil
    },
    Noclip = {
        Enabled = false,
        Connection = nil
    }
}

-- Create UI
local UI = UmaUI:CreateWindow({
    Name = "Universal Game Script",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "Uma UI Library v2.0",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "universal_script_config",
        FolderName = "UmaUI/GameScripts"
    },
    Theme = "Default"
})

-- Character updates
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ===== PLAYER TAB =====
UI:Tab("Player")
    :Section("Movement")
    :Toggle("Speed Hack", false, function(value)
        Settings.Speed.Enabled = value
        
        if value then
            -- Fix: Remove old connection if exists
            if Settings.Speed.Connection then
                Settings.Speed.Connection:Disconnect()
            end
            
            Settings.Speed.Connection = RunService.Heartbeat:Connect(function()
                if Character and Humanoid and Settings.Speed.Enabled then
                    Humanoid.WalkSpeed = Settings.Speed.Value
                end
            end)
            
            UI:Notify("Speed Hack", "Enabled at " .. Settings.Speed.Value, 3)
        else
            if Settings.Speed.Connection then
                Settings.Speed.Connection:Disconnect()
                Settings.Speed.Connection = nil
            end
            if Humanoid then
                Humanoid.WalkSpeed = 16
            end
            UI:Notify("Speed Hack", "Disabled", 3)
        end
    end, "Modify your walk speed")
    :Slider("Speed Value", 16, 200, 16, function(value)
        Settings.Speed.Value = value
        if Settings.Speed.Enabled and Humanoid then
            Humanoid.WalkSpeed = value
        end
    end, "studs/s")
    :Toggle("Jump Power", false, function(value)
        Settings.JumpPower.Enabled = value
        
        if value then
            if Settings.JumpPower.Connection then
                Settings.JumpPower.Connection:Disconnect()
            end
            
            Settings.JumpPower.Connection = RunService.Heartbeat:Connect(function()
                if Character and Humanoid and Settings.JumpPower.Enabled then
                    Humanoid.JumpPower = Settings.JumpPower.Value
                end
            end)
        else
            if Settings.JumpPower.Connection then
                Settings.JumpPower.Connection:Disconnect()
                Settings.JumpPower.Connection = nil
            end
            if Humanoid then
                Humanoid.JumpPower = 50
            end
        end
    end)
    :Slider("Jump Value", 50, 300, 50, function(value)
        Settings.JumpPower.Value = value
        if Settings.JumpPower.Enabled and Humanoid then
            Humanoid.JumpPower = value
        end
    end, "power")
    :Toggle("Noclip", false, function(value)
        Settings.Noclip.Enabled = value
        
        if value then
            if Settings.Noclip.Connection then
                Settings.Noclip.Connection:Disconnect()
            end
            
            Settings.Noclip.Connection = RunService.Stepped:Connect(function()
                if Character and Settings.Noclip.Enabled then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            UI:Notify("Noclip", "Enabled - Walk through walls", 3)
        else
            if Settings.Noclip.Connection then
                Settings.Noclip.Connection:Disconnect()
                Settings.Noclip.Connection = nil
            end
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            UI:Notify("Noclip", "Disabled", 3)
        end
    end)

UI:Tab("Player")
    :Section("Actions")
    :Button("Reset Character", function()
        if Humanoid then
            Humanoid.Health = 0
        end
        UI:Notify("Reset", "Character reset requested", 2)
    end)
    :Button("Sit/Stand", function()
        if Humanoid then
            Humanoid.Sit = not Humanoid.Sit
        end
    end)
    :Button("God Mode (FE)", function()
        -- Simple FE God Mode attempt
        if Character and Character:FindFirstChild("Humanoid") then
            local hum = Character.Humanoid
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
            UI:Notify("God Mode", "Attempting FE God Mode", 3)
        end
    end)

-- ===== VISUALS TAB =====
UI:Tab("Visuals")
    :Section("Camera")
    :Slider("Field of View", 70, 120, 70, function(value)
        Settings.FOV.Value = value
        workspace.CurrentCamera.FieldOfView = value
    end, "°")
    :Button("Reset FOV", function()
        workspace.CurrentCamera.FieldOfView = Settings.FOV.Default
        UI:Notify("FOV", "Reset to default", 2)
    end)

UI:Tab("Visuals")
    :Section("Lighting")
    :Toggle("Fullbright", false, function(value)
        Settings.Fullbright.Enabled = value
        
        if value then
            -- Save original settings
            Settings.Fullbright.OriginalSettings = {
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }
            
            -- Apply fullbright
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            
            UI:Notify("Fullbright", "Enabled", 3)
        else
            -- Restore original settings
            local orig = Settings.Fullbright.OriginalSettings
            if orig.Ambient then
                Lighting.Ambient = orig.Ambient
                Lighting.Brightness = orig.Brightness
                Lighting.ClockTime = orig.ClockTime
                Lighting.FogEnd = orig.FogEnd
                Lighting.GlobalShadows = orig.GlobalShadows
                Lighting.OutdoorAmbient = orig.OutdoorAmbient
            end
            
            UI:Notify("Fullbright", "Disabled", 3)
        end
    end)
    :Toggle("Remove Fog", false, function(value)
        if value then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = Settings.Fullbright.OriginalSettings.FogEnd or 10000
        end
    end)

-- ===== TELEPORT TAB =====
UI:Tab("Teleport")
    :Section("Quick Teleports")
    :Button("Teleport to Spawn", function()
        if RootPart then
            local spawnLocation = workspace:FindFirstChild("SpawnLocation") or 
                                 workspace:FindFirstChildOfClass("SpawnLocation")
            if spawnLocation then
                RootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
                UI:Notify("Teleport", "Teleported to spawn", 2)
            else
                RootPart.CFrame = CFrame.new(0, 50, 0)
                UI:Notify("Teleport", "Teleported to origin", 2)
            end
        end
    end)
    :Button("Teleport to Random Player", function()
        local players = Players:GetPlayers()
        local randomPlayer = players[math.random(1, #players)]
        
        if randomPlayer ~= Player and randomPlayer.Character and 
           randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            UI:Notify("Teleport", "Teleported to " .. randomPlayer.Name, 3)
        end
    end)

UI:Tab("Teleport")
    :Section("Custom Coordinates")
    :Label("Enter coordinates manually")
    :Button("Teleport Up (+50)", function()
        if RootPart then
            RootPart.CFrame = RootPart.CFrame + Vector3.new(0, 50, 0)
        end
    end)
    :Button("Teleport Down (-50)", function()
        if RootPart then
            RootPart.CFrame = RootPart.CFrame - Vector3.new(0, 50, 0)
        end
    end)

-- ===== MISC TAB =====
UI:Tab("Misc")
    :Section("Game Info")
    :Label("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    :Label("Players: " .. #Players:GetPlayers())
    :Button("Copy Game Link", function()
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        UI:Notify("Clipboard", "Game link copied!", 2)
    end)
    :Button("Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)

UI:Tab("Misc")
    :Section("Server Info")
    :Button("Server Hop", function()
        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        )
        
        if servers and servers.data then
            local server = servers.data[math.random(1, #servers.data)]
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, Player)
        end
    end)
    :Label("Ping: " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms")

-- ===== SETTINGS TAB =====
UI:Tab("Settings")
    :Section("UI Theme")
    :Button("Dark Theme", function()
        UI:Theme("Default")
        UI:Notify("Theme", "Applied Dark Theme", 2)
    end)
    :Button("Light Theme", function()
        UI:Theme("Light")
        UI:Notify("Theme", "Applied Light Theme", 2)
    end)

UI:Tab("Settings")
    :Section("Configuration")
    :Label("Auto-save is enabled")
    :Button("Save Config Now", function()
        UmaUI:SaveConfiguration()
        UI:Notify("Config", "Configuration saved!", 2)
    end)
    :Button("Reset All Settings", function()
        -- Reset all toggles
        Settings.Speed.Enabled = false
        Settings.JumpPower.Enabled = false
        Settings.Noclip.Enabled = false
        Settings.Fullbright.Enabled = false
        
        -- Disconnect all connections
        if Settings.Speed.Connection then Settings.Speed.Connection:Disconnect() end
        if Settings.JumpPower.Connection then Settings.JumpPower.Connection:Disconnect() end
        if Settings.Noclip.Connection then Settings.Noclip.Connection:Disconnect() end
        
        UI:Notify("Reset", "All settings have been reset", 3)
    end)

-- ===== CREDITS TAB =====
UI:Tab("Credits")
    :Section("About")
    :Label("Universal Game Script")
    :Label("Version: 1.0")
    :Label("Using Uma UI Library v2.0")
    :Button("Discord Server", function()
        setclipboard("discord.gg/example")
        UI:Notify("Discord", "Link copied to clipboard!", 3)
    end)

-- Event Handlers
UI:On("OnThemeChanged", function(themeName)
    print("Theme changed to:", themeName)
end)

UI:On("OnConfigLoaded", function(action)
    if action == "Loaded" then
        UI:Notify("Config", "Settings restored from last session", 3)
    end
end)

-- Welcome notification
UI:Notify("Welcome", "Universal Script loaded successfully!", 5)

-- Cleanup on exit
game:GetService("CoreGui").DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "Uma" or descendant.Parent and descendant.Parent.Name == "Uma" then
        -- Clean up all connections
        if Settings.Speed.Connection then Settings.Speed.Connection:Disconnect() end
        if Settings.JumpPower.Connection then Settings.JumpPower.Connection:Disconnect() end
        if Settings.Noclip.Connection then Settings.Noclip.Connection:Disconnect() end
        if Settings.AutoFarm.Connection then Settings.AutoFarm.Connection:Disconnect() end
    end
end)

print("Universal Game Script initialized with Uma UI Library")
