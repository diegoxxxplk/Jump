-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar a interface
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "JumpShowdownUI"

-- Botão de abrir/fechar menu
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Abrir Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Menu principal
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 220, 0, 250)
menuFrame.Position = UDim2.new(0, 10, 0, 60)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.BorderSizePixel = 0

-- Função para criar botões
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
local safePosition = nil

-- Botões
local skillBtn = createButton("Infinite Skill: OFF", 1)
local ragdollBtn = createButton("Anti-Ragdoll: OFF", 2)
local autoJumpBtn = createButton("Auto-Jump: OFF", 3)
local gravityBtn = createButton("Baixa Gravidade: OFF", 4)
local safeBtn = createButton("Voltar para Posição Segura", 5)
local infAbilityBtn = createButton("Habilidades Infinitas: OFF", 6)

-- Funções

-- Infinite Skill
skillBtn.MouseButton1Click:Connect(function()
	skillEnabled = not skillEnabled
	skillBtn.Text = "Infinite Skill: " .. (skillEnabled and "ON" or "OFF")
	pcall(function()
		player.Character.Humanoid.PlatformStand = skillEnabled
	end)
end)

-- Anti-ragdoll
ragdollBtn.MouseButton1Click:Connect(function()
	antiRagdoll = not antiRagdoll
	ragdollBtn.Text = "Anti-Ragdoll: " .. (antiRagdoll and "ON" or "OFF")
end)

-- Auto-Jump
autoJumpBtn.MouseButton1Click:Connect(function()
	autoJump = not autoJump
	autoJumpBtn.Text = "Auto-Jump: " .. (autoJump and "ON" or "OFF")
end)

-- Baixa Gravidade
gravityBtn.MouseButton1Click:Connect(function()
	lowGravity = not lowGravity
	gravityBtn.Text = "Baixa Gravidade: " .. (lowGravity and "ON" or "OFF")
	workspace.Gravity = lowGravity and 80 or 196.2
end)

-- Posição segura
safeBtn.MouseButton1Click:Connect(function()
	if safePosition then
		player.Character:MoveTo(safePosition)
	else
		safePosition = player.Character.PrimaryPart.Position
		safeBtn.Text = "Posição Salva!"
	end
end)

-- Habilidades infinitas
infAbilityBtn.MouseButton1Click:Connect(function()
	infiniteAbilities = not infiniteAbilities
	infAbilityBtn.Text = "Habilidades Infinitas: " .. (infiniteAbilities and "ON" or "OFF")
end)

-- Toggle do menu
toggleButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
	if antiRagdoll then
		pcall(function()
			player.Character.Humanoid.PlatformStand = false
			player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end

	if autoJump then
		pcall(function()
			local root = player.Character:WaitForChild("HumanoidRootPart")
			if root and root.Velocity.Y < -30 then
				player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end

	if infiniteAbilities then
		pcall(function()
			local skills = player.Character:FindFirstChild("Skills")
			if skills then
				for _, skill in pairs(skills:GetChildren()) do
					if skill:IsA("NumberValue") then
						skill.Value = 999999
					end
				end
			end
		end)
	end
end)
