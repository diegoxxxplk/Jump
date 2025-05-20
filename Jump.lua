-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "JumpShowdownUI"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Abrir Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 240, 0, 300)
menuFrame.Position = UDim2.new(0, 10, 0, 60)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.BorderSizePixel = 0

local function createButton(text, orderY)
	local btn = Instance.new("TextButton", menuFrame)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, 10 + ((orderY - 1) * 40))
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BorderSizePixel = 0
	return btn
end

-- Estados
local skillEnabled = false
local antiRagdoll = false
local autoJump = false
local lowGravity = false
local infiniteAbilities = false
local aimbotEnabled = false
local safePosition = nil

-- Botões
local skillBtn = createButton("Infinite Skill: OFF", 1)
local ragdollBtn = createButton("Anti-Ragdoll: OFF", 2)
local autoJumpBtn = createButton("Auto-Jump: OFF", 3)
local gravityBtn = createButton("Baixa Gravidade: OFF", 4)
local safeBtn = createButton("Salvar/Voltar Posição", 5)
local infAbilityBtn = createButton("Habilidades Infinitas: OFF", 6)
local aimbotBtn = createButton("Aimbot: OFF", 7)

-- Funções

skillBtn.MouseButton1Click:Connect(function()
	skillEnabled = not skillEnabled
	skillBtn.Text = "Infinite Skill: " .. (skillEnabled and "ON" or "OFF")
	pcall(function()
		player.Character.Humanoid.PlatformStand = skillEnabled
	end)
end)

ragdollBtn.MouseButton1Click:Connect(function()
	antiRagdoll = not antiRagdoll
	ragdollBtn.Text = "Anti-Ragdoll: " .. (antiRagdoll and "ON" or "OFF")
end)

autoJumpBtn.MouseButton1Click:Connect(function()
	autoJump = not autoJump
	autoJumpBtn.Text = "Auto-Jump: " .. (autoJump and "ON" or "OFF")
end)

gravityBtn.MouseButton1Click:Connect(function()
	lowGravity = not lowGravity
	gravityBtn.Text = "Baixa Gravidade: " .. (lowGravity and "ON" or "OFF")
	workspace.Gravity = lowGravity and 80 or 196.2
end)

safeBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if not safePosition then
		safePosition = char and char.PrimaryPart and char.PrimaryPart.Position
		safeBtn.Text = "Voltar para posição!"
	else
		char:MoveTo(safePosition)
		safeBtn.Text = "Salvar nova posição"
		safePosition = nil
	end
end)

infAbilityBtn.MouseButton1Click:Connect(function()
	infiniteAbilities = not infiniteAbilities
	infAbilityBtn.Text = "Habilidades Infinitas: " .. (infiniteAbilities and "ON" or "OFF")
end)

aimbotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	aimbotBtn.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

toggleButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Aimbot função
local function getClosestEnemy()
	local closest = nil
	local shortestDist = math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortestDist then
				closest = p
				shortestDist = dist
			end
		end
	end
	return closest
end

-- Loop principal
RunService.RenderStepped:Connect(function()
	local char = player.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if antiRagdoll and hum then
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	if autoJump and root and hum then
		if root.Velocity.Y < -40 then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end

	if infiniteAbilities and hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
	end

	if aimbotEnabled then
		local target = getClosestEnemy()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local camera = workspace.CurrentCamera
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
		end
	end
end)
