-- Gắn script này vào LocalScript trong StarterPlayerScripts hoặc trong GUI
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

-- Biến lưu
local autoCollect = false
local delayTime = 1
local checkpoint = nil

-- GUI khởi tạo (nếu bạn muốn tạo bằng script)
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoGui"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.Size = UDim2.new(0, 220, 0, 250)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

-- MAIN tab
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Text = "Auto Collect (E)"
autoBtn.Position = UDim2.new(0, 10, 0, 10)
autoBtn.Size = UDim2.new(1, -20, 0, 30)

local modeDropdown = Instance.new("TextButton", frame)
modeDropdown.Text = "Tốc độ: Chậm"
modeDropdown.Position = UDim2.new(0, 10, 0, 50)
modeDropdown.Size = UDim2.new(1, -20, 0, 30)

local customTimeBox = Instance.new("TextBox", frame)
customTimeBox.PlaceholderText = "Nhập thời gian (giây)"
customTimeBox.Position = UDim2.new(0, 10, 0, 90)
customTimeBox.Size = UDim2.new(1, -20, 0, 30)

-- OTHER tab
local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Lưu Checkpoint"
saveBtn.Position = UDim2.new(0, 10, 0, 140)
saveBtn.Size = UDim2.new(1, -20, 0, 30)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "Dịch chuyển về Checkpoint"
tpBtn.Position = UDim2.new(0, 10, 0, 180)
tpBtn.Size = UDim2.new(1, -20, 0, 30)

-- Logic chọn tốc độ
local mode = "Chậm" -- Chậm, Nhanh, Tùy chỉnh
modeDropdown.MouseButton1Click:Connect(function()
	if mode == "Chậm" then
		mode = "Nhanh"
		delayTime = 0.2
	elseif mode == "Nhanh" then
		mode = "Tùy chỉnh"
		delayTime = tonumber(customTimeBox.Text) or 1
	else
		mode = "Chậm"
		delayTime = 1
	end
	modeDropdown.Text = "Tốc độ: " .. mode
end)

-- Bắt phím E để bật autoCollect
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then
		autoCollect = not autoCollect
		autoBtn.Text = autoCollect and "Đang Auto Collect..." or "Auto Collect (E)"
	end
end)

-- Auto Collect loop
task.spawn(function()
	while true do
		if autoCollect then
			-- Giả lập nhấn E (nếu game cho phép)
			-- hoặc gọi hàm thu thập (tùy vào game)
			uis.InputBegan:Fire(Enum.KeyCode.E, false)
		end
		if mode == "Tùy chỉnh" then
			delayTime = tonumber(customTimeBox.Text) or 1
		end
		task.wait(delayTime)
	end
end)

-- Lưu Checkpoint
saveBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		checkpoint = char.HumanoidRootPart.Position
		saveBtn.Text = "Đã lưu!"
		task.wait(1)
		saveBtn.Text = "Lưu Checkpoint"
	end
end)

-- Teleport về Checkpoint
tpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and checkpoint then
		char.HumanoidRootPart.CFrame = CFrame.new(checkpoint)
	end
end)
