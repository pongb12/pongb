function dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm(code)res=''for i in ipairs(code)do res=res..string.char(code[i]/105)end return res end 


-- 📛 Tạo GUI chính
local lp = game:GetService(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8400,11340,10185,12705,10605,11970,12075})).LocalPlayer
local gui = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8715,10395,11970,10605,10605,11550,7455,12285,11025}), lp:WaitForChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8400,11340,10185,12705,10605,11970,7455,12285,11025})))
gui.Name = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6825,11550,12180,11025,7455,8925,7665,9975}) .. math.random(1000, 9999)
gui.ResetOnSpawn = false

-- 🔁 Đổi tên GUI mỗi 15s
task.spawn(function()
	while true do
		wait(15)
		gui.Name = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6825,11550,12180,11025,7455,8925,7665,9975}) .. math.random(1000, 9999)
	end
end)

-- 📦 Frame chính
local frame = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7350,11970,10185,11445,10605}), gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 🔘 Nút bật/tắt anti ragdoll
local toggle = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), frame)
toggle.Size = UDim2.new(0.7, -10, 0, 40)
toggle.Position = UDim2.new(0, 5, 0, 5)
toggle.Text = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6825,11550,12180,11025,4725,8610,10185,10815,10500,11655,11340,11340,6090,3360,8295,7350,7350})
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

-- ❌ Nút X
local close = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}), frame)
close.Size = UDim2.new(0.3, -10, 0, 40)
close.Position = UDim2.new(0.7, 5, 0, 5)
close.Text = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9240})
close.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 20

-- 🔒 Trạng thái
local label = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,10605,12600,12180,7980,10185,10290,10605,11340}), frame)
label.Size = UDim2.new(1, -10, 0, 20)
label.Position = UDim2.new(0, 5, 0, 50)
label.BackgroundTransparency = 1
label.Text = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({20580,15120,10185,11550,10815,3360,10395,10920,23625,19530,16905,12705,3360,6825,11550,12180,11025,4725,7875,11025,10395,11235})
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSans
label.TextSize = 14

-- ❌ Xóa GUI khi ấn X
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- 🛡️ Anti-Kick Nâng Cao
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if tostring(self) == tostring(lp) and method == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7875,11025,10395,11235}) then
		warn(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9555,6825,11550,12180,11025,7875,11025,10395,11235,9765,3360,7875,11025,10395,11235,3360,10290,11340,11655,10395,11235,10605,10500}))
		return nil
	end

	if tostring(self) == tostring(lp) and method == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7140,10605,12075,12180,11970,11655,12705}) then
		warn(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9555,6825,11550,12180,11025,7875,11025,10395,11235,9765,3360,7140,10605,12075,12180,11970,11655,12705,3360,10290,11340,11655,10395,11235,10605,10500}))
		return nil
	end

	if (method == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7350,11025,11970,10605,8715,10605,11970,12390,10605,11970}) or method == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7665,11550,12390,11655,11235,10605,8715,10605,11970,12390,10605,11970})) and tostring(self):lower():find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({11235,11025,10395,11235})) or tostring(self):lower():find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({10290,10185,11550})) then
		warn(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9555,6825,11550,12180,11025,7875,11025,10395,11235,9765,3360,8610,10605,11445,11655,12180,10605,3360,12075,12285,12075,11760,11025,10395,11025,11655,12285,12075,3360,10290,11340,11655,10395,11235,10605,10500,6090}), tostring(self))
		return nil
	end

	return old(self, unpack(args))
end)

-- Chống BindToClose
pcall(function()
	game:BindToClose(function()
		warn(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9555,6825,11550,12180,11025,7875,11025,10395,11235,9765,3360,6930,11025,11550,10500,8820,11655,7035,11340,11655,12075,10605,3360,10290,11340,11655,10395,11235,10605,10500}))
		while true do task.wait() end
	end)
end)
setreadonly(mt, true)

-- 🧍 Anti-Ragdoll Nâng Cao
local antiEnabled = false
local thread

local function restoreMotors(char)
	local humanoid = char:FindFirstChildOfClass(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7560,12285,11445,10185,11550,11655,11025,10500}))
	if not humanoid then return end
	local joints = {
		dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8190,10605,10395,11235}), dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180,3360,8715,10920,11655,12285,11340,10500,10605,11970}), dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11025,10815,10920,12180,3360,8715,10920,11655,12285,11340,10500,10605,11970}),
		dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180,3360,7560,11025,11760}), dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11025,10815,10920,12180,3360,7560,11025,11760}), dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11655,11655,12180,7770,11655,11025,11550,12180})
	}
	for _, name in ipairs(joints) do
		if not char:FindFirstChild(name, true) then
			local m = Instance.new(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8085,11655,12180,11655,11970,5670,7140}))
			m.Name = name
			if name == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8190,10605,10395,11235}) then
				m.Part0 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8925,11760,11760,10605,11970,8820,11655,11970,12075,11655})) or char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,11655,11970,12075,11655}))
				m.Part1 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7560,10605,10185,10500}))
			elseif name == dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11655,11655,12180,7770,11655,11025,11550,12180}) then
				m.Part0 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180}))
				m.Part1 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,11655,12495,10605,11970,8820,11655,11970,12075,11655})) or char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,11655,11970,12075,11655}))
			elseif name:find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8715,10920,11655,12285,11340,10500,10605,11970})) then
				m.Part0 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8925,11760,11760,10605,11970,8820,11655,11970,12075,11655})) or char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,11655,11970,12075,11655}))
				m.Part1 = char:FindFirstChild(name:find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180})) and dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180,3360,6825,11970,11445}) or dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11025,10815,10920,12180,3360,6825,11970,11445}))
			elseif name:find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7560,11025,11760})) then
				m.Part0 = char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,11655,12495,10605,11970,8820,11655,11970,12075,11655})) or char:FindFirstChild(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8820,11655,11970,12075,11655}))
				m.Part1 = char:FindFirstChild(name:find(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180})) and dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7980,10605,10710,12180,3360,7980,10605,10815}) or dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11025,10815,10920,12180,3360,7980,10605,10815}))
			end
			if m.Part0 and m.Part1 then
				m.C0, m.C1 = CFrame.new(), CFrame.new()
				m.Parent = m.Part0
			end
		end
	end
end

local function startRagdollProtect()
	if thread then thread:Disconnect() end
	local function protect(char)
		restoreMotors(char)
		thread = game:GetService(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,12285,11550,8715,10605,11970,12390,11025,10395,10605})).Heartbeat:Connect(function()
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6930,10185,11340,11340,8715,11655,10395,11235,10605,12180,7035,11655,11550,12075,12180,11970,10185,11025,11550,12180})) or v:IsA(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({7560,11025,11550,10815,10605,7035,11655,11550,12075,12180,11970,10185,11025,11550,12180})) or v:IsA(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8715,11760,11970,11025,11550,10815,7035,11655,11550,12075,12180,11970,10185,11025,11550,12180})) or v:IsA(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8610,11655,10500,7035,11655,11550,12075,12180,11970,10185,11025,11550,12180})) then
					v:Destroy()
				end
			end
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6930,10185,12075,10605,8400,10185,11970,12180})) then
					part.BreakJoints = function()
						warn(dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({9555,6825,11550,12180,11025,8610,10185,10815,10500,11655,11340,11340,9765,3360,6930,11970,10605,10185,11235,7770,11655,11025,11550,12180,12075,3360,10290,11340,11655,10395,11235,10605,10500}))
					end
				end
			end
		end)
	end

	local char = lp.Character or lp.CharacterAdded:Wait()
	protect(char)
	lp.CharacterAdded:Connect(function(c)
		if antiEnabled then
			wait(1)
			protect(c)
		end
	end)
end

-- Nút bật tắt
toggle.MouseButton1Click:Connect(function()
	antiEnabled = not antiEnabled
	toggle.Text = dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({6825,11550,12180,11025,4725,8610,10185,10815,10500,11655,11340,11340,6090,3360}) .. (antiEnabled and dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8295,8190}) or dxRDgbAOgjLFnISZGroezCIjpuhdwKiTtFiOjJVSyyifqGdJRWZFAGXDtCWshFAxptcvaoHnWzFCenVrFTDpplJxmVDrvWYztm({8295,7350,7350}))
	if antiEnabled then
		startRagdollProtect()
	else
		if thread then thread:Disconnect() thread = nil end
	end
end)
    
