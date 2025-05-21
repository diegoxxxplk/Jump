-- GUI Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JumpShowdownUI"

local Frame = Instance.new("ScrollingFrame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0.5, 0)
Frame.Position = UDim2.new(0, 20, 0.25, 0)
Frame.CanvasSize = UDim2.new(0, 0, 2, 0)
Frame.ScrollBarThickness = 6
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Visible = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)

-- Botão de abrir/fechar
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0.15, 0)
ToggleButton.Text = "Abrir/Fechar"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Função para criar toggles
local function criarToggle(nome, funcAtivar, funcDesativar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = nome .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

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

-- Super Run com controle de velocidade
local superRunConnection
local velocidade = 100

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -10, 0, 35)
SpeedBox.PlaceholderText = "Velocidade do Super Run"
SpeedBox.Text = tostring(velocidade)
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Frame

SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num then
        velocidade = num
    end
end)

criarToggle("Super Run", function()
    superRunConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = velocidade
        end
    end)
end, function()
    if superRunConnection then
        superRunConnection:Disconnect()
        superRunConnection = nil
    end
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end)

-- Aimbot (exemplo simples)
local aimbotConnection
criarToggle("Aimbot", function()
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    aimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local closest
        local shortest = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local pos, visible = camera:WorldToViewportPoint(p.Character.Head.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = p
                    end
                end
            end
        end
        if closest then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end)
end, function()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end)

-- Carregar script externo
criarToggle("Carregar Script Remoto", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/diegoxxxplk/Jump/refs/heads/main/Jump.lua"))()
end, function()
    print("Script remoto desativado (sem ação)")
end)
