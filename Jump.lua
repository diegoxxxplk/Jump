-- Jump Showdown Mobile Hub - Roblox Script
-- Recursos: Super Run, Aimbot de Peito, Defesa Automática, Combo Automático

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações
local SPEED_MULTIPLIER = 2.5
local COMBO_DISTANCE = 8

-- Estado dos recursos
local superRun = false
local aimbotActive = false
local autoGuard = false
local autoCombo = false

-- Interface simples
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 10, 0.4, 0)
Frame.Size = UDim2.new(0, 180, 0, 200)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0

local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton("Super Run", 0, function()
    superRun = not superRun
end)

createButton("Aimbot Peito", 40, function()
    aimbotActive = not aimbotActive
end)

createButton("Defesa Auto", 80, function()
    autoGuard = not autoGuard
end)

createButton("Auto Combo", 120, function()
    autoCombo = not autoCombo
end)

-- Função de aimbot no peito do alvo mais próximo
local function getNearestEnemy()
    local closest
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortest then
                closest = player
                shortest = distance
            end
        end
    end
    return closest
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if superRun and humanoid then
        humanoid.WalkSpeed = 16 * SPEED_MULTIPLIER
    else
        humanoid.WalkSpeed = 16
    end

    if aimbotActive then
        local target = getNearestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local aimPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
        end
    end

    if autoGuard then
        if character:FindFirstChild("Ragdoll") then
            character.Ragdoll:Destroy()
        end
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end

    if autoCombo then
        local target = getNearestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if (target.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= COMBO_DISTANCE then
                for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = character
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

print("Jump Showdown Hub Ativado para Mobile.")
