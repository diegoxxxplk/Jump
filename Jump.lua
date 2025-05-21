-- GUI Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("ScrollingFrame", ScreenGui)
local UICorner = Instance.new("UICorner", Frame)
local UIListLayout = Instance.new("UIListLayout", Frame)
local ToggleButton = Instance.new("TextButton", ScreenGui)

-- Configurações básicas da interface
ScreenGui.Name = "JumpShowdownUI"
Frame.Size = UDim2.new(0, 250, 0.5, 0)
Frame.Position = UDim2.new(0, 20, 0.2, 0)
Frame.CanvasSize = UDim2.new(0, 0, 2, 0)
Frame.ScrollBarThickness = 6
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
UICorner.CornerRadius = UDim.new(0, 10)

UIListLayout.Padding = UDim.new(0, 6)

-- Botão de abrir/fechar
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0.1, 0)
ToggleButton.Text = "Abrir/Fechar"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Função para criar botões toggle
local function criarToggle(nome, funcAtivar, funcDesativar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = nome .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local ativado = false

    btn.MouseButton1Click:Connect(function()
        ativado = not ativado
        btn.Text = nome .. (ativado and ": ON" or ": OFF")
        btn.BackgroundColor3 = ativado and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        if ativado then
            funcAtivar()
        else
            funcDesativar()
        end
    end)

    btn.Parent = Frame
end

-- ▼▼ Funções ▼▼
criarToggle("Super Run", function()
    game:GetService("RunService").Stepped:Connect(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 120
        end
    end)
end, function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end)

criarToggle("Aimbot", function()
    -- Código básico de aimbot (adaptável ao jogo)
    local camera = game.Workspace.CurrentCamera
    local player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")

    aimbotConnection = RunService.RenderStepped:Connect(function()
        local closest = nil
        local shortest = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = v
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end)
end, function()
    if aimbotConnection then
        aimbotConnection:Disconnect()
    end
end)

-- Crie mais toggles como esse com base nas opções da imagem:
local fakeToggle = function() end -- Use esse para funções que ainda serão definidas

criarToggle("Auto Farm Target", fakeToggle, fakeToggle)
criarToggle("Auto Farm", fakeToggle, fakeToggle)
criarToggle("No Dash Cooldown", fakeToggle, fakeToggle)
criarToggle("Infinite WallRun", fakeToggle, fakeToggle)
criarToggle("No Wall Run Cooldown", fakeToggle, fakeToggle)
criarToggle("No Wall Combo Cooldown", fakeToggle, fakeToggle)
criarToggle("Bigger Wall Combo Hitbox", fakeToggle, fakeToggle)
criarToggle("Lock On", fakeToggle, fakeToggle)

-- Interface visível inicialmente
Frame.Visible = true
