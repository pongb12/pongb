-- Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CircleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo nút hình tròn
local circleButton = Instance.new("TextButton")
circleButton.Size = UDim2.new(0, 60, 0, 60)
circleButton.Position = UDim2.new(0, 100, 0, 100)
circleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
circleButton.Text = "F1"
circleButton.TextColor3 = Color3.new(1,1,1)
circleButton.Font = Enum.Font.GothamBold
circleButton.TextScaled = true
circleButton.BorderSizePixel = 0
circleButton.Parent = screenGui

-- Làm tròn góc thành hình tròn
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(1, 0)
uicorner.Parent = circleButton

-- Tạo nút X để xóa GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -15, 0, -5)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.BorderSizePixel = 0
closeButton.Parent = circleButton

local uicorner2 = Instance.new("UICorner")
uicorner2.CornerRadius = UDim.new(0.5, 0)
uicorner2.Parent = closeButton

-- Xóa GUI khi bấm nút X
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Giả lập F1 (gắn chức năng vào đây)
circleButton.MouseButton1Click:Connect(function()
	print("higuy") -- thay thế bằng hành động cụ thể nếu cần
end)

-- Cho phép kéo GUI
local dragging = false
local dragInput, mousePos, framePos

circleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = circleButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

circleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		circleButton.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

-- Đổi tên GUI mỗi 2 phút
local randomNames = {
    "ControllerUI",
    "HelperPanel",
    "DebugMode",
    "SystemOverlay",
    "AccessPoint",
    "HiddenUI",
    "ToolModule",
    "Circle",
    "QuickMenu",
    "BubbleCore"
}

task.spawn(function()
	while screenGui and screenGui.Parent do
		task.wait(120) -- 2 phút
		local newName = randomNames[math.random(1, #randomNames)]
		screenGui.Name = newName
		print("GUI name changed to:", newName)
	end
end)
