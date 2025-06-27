--PongbHub--
local validKeys = {
    ["Pongbhubscript"] = true,
    ["memaybell"] = true,
    ["joinnow"] = true
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer


local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeySystem"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "🔐 Nhập Key"
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 30)
box.Position = UDim2.new(0.1, 0, 0.2, 0)
box.PlaceholderText = "Nhập key tại đây..."
box.Text = ""
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", box)

local confirmBtn = Instance.new("TextButton", frame)
confirmBtn.Size = UDim2.new(0.8, 0, 0, 30)
confirmBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
confirmBtn.Text = "✅ Xác nhận"
confirmBtn.TextColor3 = Color3.new(1, 1, 1)
confirmBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Instance.new("UICorner", confirmBtn)

local getKeyBtn = Instance.new("TextButton", frame)
getKeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
getKeyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
getKeyBtn.Text = "🔑 Nhận key tại đây"
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
Instance.new("UICorner", getKeyBtn)

local discordBtn = Instance.new("TextButton", frame)
discordBtn.Size = UDim2.new(0.8, 0, 0, 30)
discordBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
discordBtn.Text = "💬 Discord"
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
Instance.new("UICorner", discordBtn)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.88, 0)
status.Text = ""
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.BackgroundTransparency = 1
status.TextScaled = true


confirmBtn.MouseButton1Click:Connect(function()
    local key = box.Text
    if key == "" then
        status.Text = "⚠️ Vui lòng nhập key"
        return
    end
    if validKeys[key] then
        status.Text = "✔️ Đúng key, đang tải script..."
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pongb12/pongb/refs/heads/main/PongbHub.lua"))()
    else
        status.Text = "❌ Sai key, thử lại!"
    end
end)


getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://workink.net/20Ip/cdi7ddxs")
    status.Text = "📋 Link nhận key đã sao chép!"
end)


discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/VEPjWb59")
    status.Text = "📋 Link Discord đã sao chép!"
end)
