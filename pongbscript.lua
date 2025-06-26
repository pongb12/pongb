local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Biến hệ thống
local collecting = false
local collectingEnabled = false
local delayTime = 1
local checkpoint = nil
local speedMode = "Chậm"

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GardenAutoGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 240)
frame.Position = UDim2.new(0, 50, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Tabs bên trái
local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(0, 90, 1, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabBar.BorderSizePixel = 0

local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.new(0, 90, 0, 0)
contentFrame.Size = UDim2.new(1, -90, 1, 0)
contentFrame.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", tabBar)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local function createTabButton(name)
	local b = Instance.new("TextButton")
	b.Text = name
	b.Size = UDim2.new(1, -10, 0, 30)
	b.Position = UDim2.new(0, 5, 0, 0)
	b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.Parent = tabBar
	return b
end

local function createPage()
	local page = Instance.new("Frame", contentFrame)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	return page
end

local pages = {}

-- MAIN PAGE
local btnMain = createTabButton("Main")
local pageMain = createPage()
pages.Main = pageMain

local toggleBtn = Instance.new("TextButton", pageMain)
toggleBtn.Text = "Bật Auto (Giữ E)"
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 120, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)

local modeBtn = Instance.new("TextButton", pageMain)
modeBtn.Text = "Tốc độ: Chậm"
modeBtn.Position = UDim2.new(0, 10, 0, 50)
modeBtn.Size = UDim2.new(1, -20, 0, 30)
modeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
modeBtn.TextColor3 = Color3.new(1,1,1)

local customBox = Instance.new("TextBox", pageMain)
customBox.PlaceholderText = "Delay (giây)"
customBox.Position = UDim2.new(0, 10, 0, 90)
customBox.Size = UDim2.new(1, -20, 0, 30)
customBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
customBox.TextColor3 = Color3.new(1,1,1)

-- CHECKPOINT PAGE
local btnOther = createTabButton("Checkpoint")
local pageOther = createPage()
pages.Other = pageOther

local saveBtn = Instance.new("TextButton", pageOther)
saveBtn.Text = "Lưu Checkpoint"
saveBtn.Position = UDim2.new(0, 10, 0, 10)
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
saveBtn.TextColor3 = Color3.new(1,1,1)

local tpBtn = Instance.new("TextButton", pageOther)
tpBtn.Text = "Dịch chuyển"
tpBtn.Position = UDim2.new(0, 10, 0, 50)
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
tpBtn.TextColor3 = Color3.new(1,1,1)

-- DELETE PAGE
local btnDelete = createTabButton("Xóa GUI")
local pageDelete = createPage()
pages.Delete = pageDelete

local delBtn = Instance.new("TextButton", pageDelete)
delBtn.Text = "Xóa giao diện"
delBtn.Position = UDim2.new(0, 10, 0, 30)
delBtn.Size = UDim2.new(1, -20, 0, 35)
delBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
delBtn.TextColor3 = Color3.new(1,1,1)

-- Tab switching
btnMain.MouseButton1Click:Connect(function()
	for _, p in pairs(pages) do p.Visible = false end
	pageMain.Visible = true
end)
btnOther.MouseButton1Click:Connect(function()
	for _, p in pairs(pages) do p.Visible = false end
	pageOther.Visible = true
end)
btnDelete.MouseButton1Click:Connect(function()
	for _, p in pairs(pages) do p.Visible = false end
	pageDelete.Visible = true
end)

-- Mặc định mở tab main
pageMain.Visible = true

-- Điều chỉnh tốc độ
modeBtn.MouseButton1Click:Connect(function()
	if speedMode == "Chậm" then
		speedMode = "Nhanh"
		delayTime = 0.2
	elseif speedMode == "Nhanh" then
		speedMode = "Tùy chỉnh"
		delayTime = tonumber(customBox.Text) or 1
	else
		speedMode = "Chậm"
		delayTime = 1
	end
	modeBtn.Text = "Tốc độ: " .. speedMode
end)

-- Toggle Auto Collect
toggleBtn.MouseButton1Click:Connect(function()
	collectingEnabled = not collectingEnabled
	toggleBtn.Text = collectingEnabled and "Đã bật (giữ E)" or "Bật Auto (Giữ E)"
end)

-- Bắt giữ phím E
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E and collectingEnabled then
		collecting = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		collecting = false
	end
end)

-- Auto Collect logic (Grow a Garden style)
task.spawn(function()
	while true do
		if collecting then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("ProximityPrompt") and (obj.Parent.Position - root.Position).Magnitude < 10 then
						fireproximityprompt(obj)
					end
				end
			end
		end
		if speedMode == "Tùy chỉnh" then
			delayTime = tonumber(customBox.Text) or 1
		end
		task.wait(delayTime)
	end
end)

-- Lưu checkpoint
saveBtn.MouseButton1Click:Connect(function()
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root then
		checkpoint = root.Position
	end
end)

-- Dịch chuyển checkpoint
tpBtn.MouseButton1Click:Connect(function()
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and checkpoint then
		root.CFrame = CFrame.new(checkpoint)
	end
end)

-- Xóa GUI
delBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
