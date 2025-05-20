-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "JumpShowdownUI"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Abrir Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Frame com Scroll
local scrollContainer = Instance.new("ScrollingFrame", screenGui)
scrollContainer.Size = UDim2.new(0, 240, 0, 300)
scrollContainer.Position = UDim2.new(0, 10, 0, 60)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollContainer.BorderSizePixel = 0
scrollContainer.Visible = false
scrollContainer.ScrollBarThickness = 8

-- Criar botão
local function createButton(text, y)
	local btn = Instance.new("TextButton", scrollContainer)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, 10 + ((y - 1) * 40))
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BorderSizePixel = 0
	return btn
end

-- Estados
local infiniteAbilities = false
local aimbotEnabled = false
local autoDefend = false
local safePosition = nil

-- Botões
local infSkillBtn = createButton("Habilidades Infinitas: OFF", 1)
local aimBtn = createButton("Aimbot: OFF", 2)
local defendBtn = createButton("Auto-Defesa: OFF", 3)
local saveBtn = createButton("Salvar/Voltar Posição", 4)

-- Funções de estado
infSkillBtn.MouseButton1Click:Connect(function()
	infiniteAbilities = not infiniteAbilities
	infSkillBtn.Text = "Habilidades Infinitas: " .. (infiniteAbilities and "ON" or "OFF")
end)

aimBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	aimBtn.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

defendBtn.MouseButton1Click:Connect(function()
	autoDefend = not autoDefend
	defendBtn.Text = "Auto-Defesa: " .. (autoDefend and "ON" or "OFF")
end)

saveBtn.MouseButton1Click:Connect(function()
	if not safePosition then
		safePosition = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position
		saveBtn.Text = "Voltar para Posição"
	else
		player.Character:MoveTo(safePosition)
		saveBtn.Text = "Salvar Nova Posição"
		safePosition = nil
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	scrollContainer.Visible = not scrollContainer.Visible
end)

-- Buscar inimigo mais próximo
local function getClosestEnemy()
	local closest = nil
	local shortest = math.huge
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
			if dist < shortest then
				shortest = dist
				closest = p
			end
		end
	end
	return closest
end

-- Loop Principal
RunService.RenderStepped:Connect(function()
	if infiniteAbilities and hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	end

	if aimbotEnabled then
		local target = getClosestEnemy()
		if target and target.Character then
			local part = target.Character:FindFirstChild("HumanoidRootPart")
			if part then
				local cam = workspace.CurrentCamera
				cam.CFrame = CFrame.new(cam.CFrame.Position, part.Position)
			end
		end
	end

	if autoDefend and char:FindFirstChild("Humanoid") then
		-- Simples exemplo de "defesa automática":
		local shieldKey = "F" -- Mude para a tecla real se necessário
		-- Aqui você pode acionar a habilidade de defesa
		-- Exemplo: chamar uma RemoteEvent de defesa se existir
	end
end)
