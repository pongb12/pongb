local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")


local collecting = false
local collectingEnabled = false
local delayTime = 1
local checkpoint = nil


local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BetterAutoGui"
gui.ResetOnSpawn = false


local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 380, 0, 240)
frame.Position = UDim2.new(0, 50, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundTransparency = 0
frame.Name = "MainFrame"
frame:ApplyStrokeMode(Enum.ApplyStrokeMode.Border)
frame:ApplyCornerRadius(12)


local sideTab = Instance.new("Frame", frame)
sideTab.Size = UDim2.new(0, 90, 1, 0)
sideTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sideTab.BorderSizePixel = 0
sideTab:ApplyCornerRadius(12)

local uiList = Instance.new("UIListLayout", sideTab)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BorderSizePixel = 0
	btn:ApplyCornerRadius(8)
	return btn
end


local tabButtons = {}
local pages = {}

local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.new(0, 95, 0, 0)
contentFrame.Size = UDim2.new(1, -100, 1, 0)
contentFrame.BackgroundTransparency = 1

local function addTab(name)
	local page = Instance.new("Frame", contentFrame)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Visible = false
	page.BackgroundTransparency = 1

	local btn = createTabButton(name)
	btn.Parent = sideTab
	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		page.Visible = true
	end)

	table.insert(tabButtons, btn)
	table.insert(pages, page)
	return page
end


local mainTab = addTab("Main")

local toggleBtn = Instance.new("TextButton", mainTab)
toggleBtn.Text = "Bật Auto Collect"
toggleBtn.Size = UDim2.new(1, -20, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 130, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BorderSizePixel = 0
toggleBtn:ApplyCornerRadius(8)

local statusLabel = Instance.new("TextLabel", mainTab)
statusLabel.Text = "Trạng thái: Đã tắt"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local modeBtn = Instance.new("TextButton", mainTab)
modeBtn.Text = "Tốc độ: Chậm"
modeBtn.Size = UDim2.new(1, -20, 0, 30)
modeBtn.Position = UDim2.new(0, 10, 0, 90)
modeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
modeBtn.TextColor3 = Color3.new(1,1,1)
modeBtn.BorderSizePixel = 0
modeBtn:ApplyCornerRadius(6)

local timeBox = Instance.new("TextBox", mainTab)
timeBox.PlaceholderText = "Tùy chỉnh delay (giây)"
timeBox.Position = UDim2.new(0, 10, 0, 130)
timeBox.Size = UDim2.new(1, -20, 0, 30)
timeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
timeBox.TextColor3 = Color3.new(1,1,1)
timeBox.BorderSizePixel = 0
timeBox:ApplyCornerRadius(6)


local otherTab = addTab("Other")

local saveBtn = Instance.new("TextButton", otherTab)
saveBtn.Text = "Lưu Checkpoint"
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 10)
saveBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 80)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.BorderSizePixel = 0
saveBtn:ApplyCornerRadius(6)

local tpBtn = Instance.new("TextButton", otherTab)
tpBtn.Text = "Dịch chuyển"
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, 50)
tpBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.BorderSizePixel = 0
tpBtn:ApplyCornerRadius(6)


local deleteTab = addTab("Xóa GUI")
local deleteBtn = Instance.new("TextButton", deleteTab)
deleteBtn.Text = "Xóa GUI"
deleteBtn.Size = UDim2.new(1, -20, 0, 35)
deleteBtn.Position = UDim2.new(0, 10, 0, 20)
deleteBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
deleteBtn.TextColor3 = Color3.new(1,1,1)
deleteBtn.BorderSizePixel = 0
deleteBtn:ApplyCornerRadius(6)

deleteBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)


local speedMode = "Chậm"
modeBtn.MouseButton1Click:Connect(function()
	if speedMode == "Chậm" then
		speedMode = "Nhanh"
		delayTime = 0.2
	elseif speedMode == "Nhanh" then
		speedMode = "Tùy chỉnh"
		delayTime = tonumber(timeBox.Text) or 1
	else
		speedMode = "Chậm"
		delayTime = 1
	end
	modeBtn.Text = "Tốc độ: " .. speedMode
end)


toggleBtn.MouseButton1Click:Connect(function()
	collectingEnabled = not collectingEnabled
	statusLabel.Text = collectingEnabled and "Trạng thái: Đang bật. Giữ phím E" or "Trạng thái: Đã tắt"
end)


uis.InputBegan:Connect(function(input)
	if collectingEnabled and input.KeyCode == Enum.KeyCode.E then
		collecting = true
	end
end)

uis.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		collecting = false
	end
end)


task.spawn(function()
	while true do
		if collecting then
			
			print("[AUTO] Thu thập hoạt động...")
		end
		if speedMode == "Tùy chỉnh" then
			delayTime = tonumber(timeBox.Text) or 1
		end
		task.wait(delayTime)
	end
end)


saveBtn.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		checkpoint = hrp.Position
		saveBtn.Text = "Đã lưu!"
		task.delay(1, function()
			saveBtn.Text = "Lưu Checkpoint"
		end)
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp and checkpoint then
		hrp.CFrame = CFrame.new(checkpoint)
	end
end)


pages[1].Visible = true
