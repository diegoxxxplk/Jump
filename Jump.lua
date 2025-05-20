-- Jump Showdown Script Insano Mobile Edition
-- Feito por ChatGPT + Você

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JumpMenu"

local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 100)
openButton.Text = "Abrir Menu"
openButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
openButton.TextColor3 = Color3.new(1,1,1)

local menu = Instance.new("ScrollingFrame", gui)
menu.Size = UDim2.new(0, 260, 0, 330)
menu.Position = UDim2.new(0, 20, 0, 150)
menu.CanvasSize = UDim2.new(0, 0, 2, 0)
menu.ScrollBarThickness = 6
menu.Visible = false
menu.BackgroundColor3 = Color3.fromRGB(40,40,40)

openButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Estados
local superRun = false
local turboAttack = false
local autoDash = false
local godstep = false
local antiRagdoll = false
local resetCooldown = false

-- Cria botão
local function criarBotao(texto, ordem, callback)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, 5 + ((ordem - 1) * 45))
	btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.Text = texto
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Funções dos botões

local btnRun = criarBotao("Super Run: OFF", 1, function()
	superRun = not superRun
	btnRun.Text = "Super Run: " .. (superRun and "ON" or "OFF")
end)

local btnAtk = criarBotao("Ataque Turbo: OFF", 2, function()
	turboAttack = not turboAttack
	btnAtk.Text = "Ataque Turbo: " .. (turboAttack and "ON" or "OFF")
end)

local btnDash = criarBotao("Auto Dash: OFF", 3, function()
	autoDash = not autoDash
	btnDash.Text = "Auto Dash: " .. (autoDash and "ON" or "OFF")
end)

local btnRagdoll = criarBotao("Anti-Ragdoll Extremo: OFF", 4, function()
	antiRagdoll = not antiRagdoll
	btnRagdoll.Text = "Anti-Ragdoll Extremo: " .. (antiRagdoll and "ON" or "OFF")
end)

local btnGod = criarBotao("Godstep: OFF", 5, function()
	godstep = not godstep
	btnGod.Text = "Godstep: " .. (godstep and "ON" or "OFF")
end)

local btnReset = criarBotao("Reset Cooldown", 6, function()
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("NumberValue") and v.Name:lower():find("cooldown") then
				v.Value = 0
			end
		end
	end
end)

-- Loop de execução
RunService.RenderStepped:Connect(function()
	if superRun and hum then
		hum.WalkSpeed = 60
	else
		hum.WalkSpeed = 16
	end

	if antiRagdoll and hum then
		local state = hum:GetState()
		if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end

	if autoDash then
		for _, enemy in pairs(Players:GetPlayers()) do
			if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (enemy.Character.HumanoidRootPart.Position - root.Position).Magnitude
				if dist < 8 then
					root.CFrame = root.CFrame * CFrame.new(0, 0, -10)
				end
			end
		end
	end

	if godstep then
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			root.CFrame = root.CFrame * CFrame.new(0, 0, -2)
		end
	end
end)

task.spawn(function()
	while true do
		if turboAttack then
			VirtualInput:SendKeyEvent(true, Enum.KeyCode.ButtonR2, false, game)
			task.wait(0.2)
		end
		task.wait(0.1)
	end
end)
