-- Jump Showdown Script Insano by ChatGPT + Você
-- Recursos: Interface Scroll, Infinite Skill, Aimbot, Defesa Automática, Farm Kill, Combo Insano

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Interface
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JumpShowdownUI"

local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0, 120, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 100)
openButton.Text = "Abrir Menu"
openButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
openButton.TextColor3 = Color3.new(1,1,1)

local menu = Instance.new("ScrollingFrame", gui)
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0, 20, 0, 150)
menu.CanvasSize = UDim2.new(0,0,2,0)
menu.ScrollBarThickness = 6
menu.Visible = false
menu.BackgroundColor3 = Color3.fromRGB(30,30,30)

openButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Estado dos recursos
local infiniteSkill = false
local autoDefend = false
local aimbot = false
local farmKill = false

-- Botão generator
local function createBtn(text, y, callback)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, 5 + ((y-1)*45))
	btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Funções
local function pressSkill(id)
	local vu = game:GetService("VirtualInputManager")
	vu:SendKeyEvent(true, Enum.KeyCode[tostring(id)], false, game)
	task.wait(0.05)
	vu:SendKeyEvent(false, Enum.KeyCode[tostring(id)], false, game)
end

local function getClosestEnemy()
	local closest, dist = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local mag = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
			if mag < dist then
				dist = mag
				closest = p
			end
		end
	end
	return closest
end

-- Botões
local infBtn = createBtn("Infinite Skill: OFF", 1, function()
	infiniteSkill = not infiniteSkill
	infBtn.Text = "Infinite Skill: " .. (infiniteSkill and "ON" or "OFF")
end)

local aimBtn = createBtn("Aimbot: OFF", 2, function()
	aimbot = not aimbot
	aimBtn.Text = "Aimbot: " .. (aimbot and "ON" or "OFF")
end)

local defBtn = createBtn("Defesa Automática: OFF", 3, function()
	autoDefend = not autoDefend
	defBtn.Text = "Defesa Automática: " .. (autoDefend and "ON" or "OFF")
end)

local farmBtn = createBtn("Farm Kill: OFF", 4, function()
	farmKill = not farmKill
	farmBtn.Text = "Farm Kill: " .. (farmKill and "ON" or "OFF")
end)

local comboBtn = createBtn("Combo Insano", 5, function()
	for i = 1, 4 do
		pressSkill(i)
		task.wait(0.1)
	end
end)

-- Loops
RunService.RenderStepped:Connect(function()
	if infiniteSkill and hum then
		hum:SetAttribute("Stamina", 100000)
	end

	if aimbot then
		local target = getClosestEnemy()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local cam = workspace.CurrentCamera
			local root = target.Character.HumanoidRootPart
			cam.CFrame = CFrame.new(cam.CFrame.Position, root.Position)
		end
	end

	if autoDefend and hum then
		if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end
end)

task.spawn(function()
	while true do
		if farmKill then
			local target = getClosestEnemy()
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				local myRoot = char:FindFirstChild("HumanoidRootPart")
				if myRoot then
					myRoot.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
					for i = 1, 4 do pressSkill(i) end
				end
			end
		end
		task.wait(0.5)
	end
end)
