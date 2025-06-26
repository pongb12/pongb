
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")


local autoCollect = false
local delayTime = 1
local checkpoint = nil
local guiVisible = true
local mode = "Chậm" 


local gui = Instance.new("ScreenGui")
gui.Name = "BypassAutoGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui") 


local frame = Instance.new("Frame")
frame.Position = UDim2.new(0, 50, 0.3, 0)
frame.Size = UDim2.new(0, 320, 0, 220)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui


local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame


local openBtn = Instance.new("TextButton")
openBtn.Text = "✕"
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.Visible = false
openBtn.Parent = gui


local tabMain = Instance.new("TextButton", frame)
tabMain.Text = "Main"
tabMain.Position = UDim2.new(0, 10, 0, 10)
tabMain.Size = UDim2.new(0, 140, 0, 30)

local tabOther = Instance.new("TextButton", frame)
tabOther.Text = "Other"
tabOther.Position = UDim2.new(0, 170, 0, 10)
tabOther.Size = UDim2.new(0, 140, 0, 30)


local mainFrame = Instance.new("Frame", frame)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.Size = UDim2.new(1, -20, 1, -60)
mainFrame.Visible = true
mainFrame.BackgroundTransparency = 1

local autoBtn = Instance.new("TextButton", mainFrame)
autoBtn.Text = "Auto Collect (E)"
autoBtn.Position = UDim2.new(0, 0, 0, 0)
autoBtn.Size = UDim2.new(1, 0, 0, 30)

local modeBtn = Instance.new("TextButton", mainFrame)
modeBtn.Text = "Tốc độ: Chậm"
modeBtn.Position = UDim2.new(0, 0, 0, 40)
modeBtn.Size = UDim2.new(1, 0, 0, 30)

local timeBox = Instance.new("TextBox", mainFrame)
timeBox.PlaceholderText = "Nhập thời gian delay (giây)"
timeBox.Position = UDim2.new(0, 0, 0, 80)
timeBox.Size = UDim2.new(1, 0, 0, 30)


local otherFrame = Instance.new("Frame", frame)
otherFrame.Position = mainFrame.Position
otherFrame.Size = mainFrame.Size
otherFrame.Visible = false
otherFrame.BackgroundTransparency = 1

local saveBtn = Instance.new("TextButton", otherFrame)
saveBtn.Text = "Lưu Checkpoint"
saveBtn.Position = UDim2.new(0, 0, 0, 0)
saveBtn.Size = UDim2.new(1, 0, 0, 30)

local tpBtn = Instance.new("TextButton", otherFrame)
tpBtn.Text = "Dịch chuyển về Checkpoint"
tpBtn.Position = UDim2.new(0, 0, 0, 40)
tpBtn.Size = UDim2.new(1, 0, 0, 30)


tabMain.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	otherFrame.Visible = false
end)

tabOther.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	otherFrame.Visible = true
end)


modeBtn.MouseButton1Click:Connect(function()
	if mode == "Chậm" then
		mode = "Nhanh"
		delayTime = 0.2
	elseif mode == "Nhanh" then
		mode = "Tùy chỉnh"
		delayTime = tonumber(timeBox.Text) or 1
	else
		mode = "Chậm"
		delayTime = 1
	end
	modeBtn.Text = "Tốc độ: " .. mode
end)


uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then
		autoCollect = not autoCollect
		autoBtn.Text = autoCollect and "Đang Auto Collect..." or "Auto Collect"
	end
end)


task.spawn(function()
	while true do
		if autoCollect then
			
			uis.InputBegan:Fire(Enum.KeyCode.E, false)
		end
		if mode == "Tùy chỉnh" then
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


closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)
