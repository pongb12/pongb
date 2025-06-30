-- 📛 GUI TỔNG CHỐNG KICK & RAGDOLL AN TOÀN
local lp = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "AntiGUI_" .. math.random(1000, 9999)
gui.ResetOnSpawn = false

-- 🔁 Đổi tên GUI mỗi 15s
task.spawn(function()
	while true do
		task.wait(15)
		gui.Name = "AntiGUI_" .. math.random(1000, 9999)
	end
end)

-- 🖼️ GUI frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 🔘 Toggle Anti-Ragdoll
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.7, -10, 0, 40)
toggle.Position = UDim2.new(0, 5, 0, 5)
toggle.Text = "Anti-Ragdoll: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

-- ❌ Nút X
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0.3, -10, 0, 40)
close.Position = UDim2.new(0.7, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 20

-- Label
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -10, 0, 20)
label.Position = UDim2.new(0, 5, 0, 50)
label.BackgroundTransparency = 1
label.Text = "Anti-Kick đang hoạt động"
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSans
label.TextSize = 14

-- 🧼 Đóng GUI
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- ✅ ANTI-KICK nâng cao (chống BAC remote)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	if tostring(self) == tostring(lp) and method == "Kick" then
		warn("[AntiKick] Kick blocked")
		return nil
	end

	if tostring(self) == tostring(lp) and method == "Destroy" then
		warn("[AntiKick] Destroy blocked")
		return nil
	end

	if (method == "FireServer" or method == "InvokeServer") then
		local name = tostring(self):lower()
		if name:find("kick") or name:find("ban") or name:find("bac") or name:find("log") or name:find("report") then
			warn("[AntiKick] Suspicious Remote blocked: ", name)
			return nil
		end
	end

	return oldNamecall(self, unpack(args))
end)

-- Chặn direct player:Kick()
lp.Kick = function() warn("[AntiKick] player:Kick blocked") end

-- Chặn BindToClose
pcall(function()
	game:BindToClose(function()
		warn("[AntiKick] BindToClose blocked")
		while true do task.wait() end
	end)
end)
setreadonly(mt, true)

-- ✅ ANTI-RAGDOLL AN TOÀN
local antiEnabled = false
local ragdollConnection = nil

local function applyAntiRagdoll(char)
	local hum = char:WaitForChild("Humanoid", 3)
	if not hum then return end

	if ragdollConnection then ragdollConnection:Disconnect() end
	ragdollConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if hum.PlatformStand then
			hum.PlatformStand = false
			warn("[SafeRagdoll] PlatformStand blocked")
		end
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Anchored then
				part.Anchored = false
			end
		end
	end)
end

local function activateAntiRagdoll()
	local char = lp.Character or lp.CharacterAdded:Wait()
	applyAntiRagdoll(char)
	lp.CharacterAdded:Connect(function(c)
		if antiEnabled then
			wait(1)
			applyAntiRagdoll(c)
		end
	end)
end

toggle.MouseButton1Click:Connect(function()
	antiEnabled = not antiEnabled
	toggle.Text = "Anti-Ragdoll: " .. (antiEnabled and "ON" or "OFF")
	print("hi")
	if antiEnabled then
		activateAntiRagdoll()
	else
		if ragdollConnection then ragdollConnection:Disconnect() ragdollConnection = nil end
	end
end)

-- ✅ Hook require để chặn module đáng ngờ
local oldRequire = require
require = function(mod)
	if typeof(mod) == "Instance" and mod:IsA("ModuleScript") then
		local name = mod.Name:lower()
		if name:find("anti") or name:find("bac") or name:find("ban") or name:find("kick") then
			warn("[AntiKick] Blocked suspicious module: " .. name)
			return function() end
		end
	end
	return oldRequire(mod)
end
