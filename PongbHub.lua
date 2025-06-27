local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PongbHub"
gui.ResetOnSpawn = false

local lastCheckpoint = nil
local lang = "vi"
local isMinimized = false

-- UI chính
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 330)
main.Position = UDim2.new(0.5, -250, 0.5, -165)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Tiêu đề
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "PongbHub"
title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold

-- Nút thu nhỏ / phóng to
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Text = "-"
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -30, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

-- Khung tabs & nội dung
local tabList = Instance.new("Frame", main)
tabList.Size = UDim2.new(0, 100, 1, -30)
tabList.Position = UDim2.new(0, 0, 0, 30)
tabList.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -100, 1, -30)
content.Position = UDim2.new(0, 100, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Tạo nút tab
local function createTabButton(name, posY)
	local b = Instance.new("TextButton", tabList)
	b.Text = name
	b.Size = UDim2.new(1, 0, 0, 40)
	b.Position = UDim2.new(0, 0, 0, posY)
	b.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
	b.TextSize = 16
	return b
end

-- Tạo khung nội dung tab
local function createTabFrame()
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1, 0, 1, 0)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

-- Tabs
local stealTabBtn = createTabButton("Steal", 0)
local miscTabBtn = createTabButton("Misc", 45)
local settingTabBtn = createTabButton("Setting", 90)

local stealTab = createTabFrame()
local miscTab = createTabFrame()
local settingTab = createTabFrame()

-- Chuyển tab
local function showTab(t)
	stealTab.Visible = false
	miscTab.Visible = false
	settingTab.Visible = false
	t.Visible = true
end

stealTabBtn.MouseButton1Click:Connect(function() showTab(stealTab) end)
miscTabBtn.MouseButton1Click:Connect(function() showTab(miscTab) end)
settingTabBtn.MouseButton1Click:Connect(function() showTab(settingTab) end)

-- Nút ẩn/hiện GUI
toggleBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		content.Visible = false
		tabList.Visible = false
		main.Size = UDim2.new(0, 500, 0, 30)
		toggleBtn.Text = "+"
	else
		content.Visible = true
		tabList.Visible = true
		main.Size = UDim2.new(0, 500, 0, 330)
		toggleBtn.Text = "-"
	end
end)

-- Tạo nút tính năng
local function addBtn(parent, text, posY, callback)
	local b = Instance.new("TextButton", parent)
	b.Text = text
	b.Size = UDim2.new(0, 200, 0, 30)
	b.Position = UDim2.new(0, 20, 0, posY)
	b.MouseButton1Click:Connect(callback)
	return b
end

-- === Steal Tab ===
addBtn(stealTab, "Lưu Checkpoint", 20, function()
	lastCheckpoint = hrp.CFrame
end)

addBtn(stealTab, "Teleport về Checkpoint", 60, function()
	if lastCheckpoint then
		hrp.CFrame = lastCheckpoint
	end
end)

addBtn(stealTab, "Auto Steal (Tốc độ 32)", 100, function()
	humanoid.WalkSpeed = 32
	local spawn = workspace:FindFirstChild("SpawnLocation")
	if spawn then
		local tween = TweenService:Create(hrp, TweenInfo.new(5), {
			CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
		})
		tween:Play()
	end
end)

local note = Instance.new("TextLabel", stealTab)
note.Text = "⚠️ Chỉ dùng khi đã lấy được brainrot trên tay"
note.TextColor3 = Color3.fromRGB(120, 0, 0)
note.Position = UDim2.new(0, 20, 0, 140)
note.Size = UDim2.new(0, 300, 0, 30)
note.BackgroundTransparency = 1
note.TextXAlignment = Enum.TextXAlignment.Left

-- === Misc Tab ===
addBtn(miscTab, "Rejoin Server", 20, function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

addBtn(miscTab, "Hop Server", 60, function()
	local fakeId = "00000000000000000000000000000000" -- sửa nếu có server thật
	TeleportService:TeleportToPlaceInstance(109983668079237, fakeId)
end)

local jobInput = Instance.new("TextBox", miscTab)
jobInput.PlaceholderText = "Nhập Job ID"
jobInput.Size = UDim2.new(0, 200, 0, 30)
jobInput.Position = UDim2.new(0, 20, 0, 100)

addBtn(miscTab, "Join Job ID", 100, function()
	local id = jobInput.Text
	if id and id ~= "" then
		TeleportService:TeleportToPlaceInstance(109983668079237, id)
	end
end)

addBtn(miscTab, "Xoá GUI", 140, function()
	gui:Destroy()
end)

-- === Setting Tab ===
local langLabel = Instance.new("TextLabel", settingTab)
langLabel.Text = "Ngôn ngữ:"
langLabel.Position = UDim2.new(0, 20, 0, 20)
langLabel.Size = UDim2.new(0, 100, 0, 30)
langLabel.BackgroundTransparency = 1
langLabel.TextXAlignment = Enum.TextXAlignment.Left

local langBtn = Instance.new("TextButton", settingTab)
langBtn.Text = "Tiếng Việt / English"
langBtn.Size = UDim2.new(0, 200, 0, 30)
langBtn.Position = UDim2.new(0, 20, 0, 60)
langBtn.MouseButton1Click:Connect(function()
	lang = (lang == "vi") and "en" or "vi"
	langBtn.Text = (lang == "vi") and "Tiếng Việt / English" or "English / Vietnamese"
end)

-- Mở mặc định tab đầu
showTab(stealTab)
