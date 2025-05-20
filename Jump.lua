-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "JumpShowdownUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Botão abrir/fechar
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextScaled = true
openBtn.Text = "Abrir Menu"
openBtn.Parent = gui

-- Menu com scroll
local menu = Instance.new("ScrollingFrame")
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0, 20, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(30,30,30)
menu.ScrollBarThickness = 6
menu.CanvasSize = UDim2.new(0, 0, 0, 0) -- Ajustado dinamicamente
menu.Visible = false
menu.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = menu

-- Estados
local states = {
    aimbot = false,
    autoFarmKill = false,
    comboAutomatico = false,
    defesaAutomatica = false,
    superRun = false,
}

-- Função para criar botão toggle
local function createToggleButton(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = name .. ": OFF"
    btn.Parent = menu

    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        btn.Text = name .. ": " .. (states[key] and "ON" or "OFF")
    end)

    return btn
end

-- Criar os botões
local aimbotBtn = createToggleButton("Aimbot", "aimbot")
local autoFarmBtn = createToggleButton("Auto Farm Kill", "autoFarmKill")
local comboBtn = createToggleButton("Combo Automático", "comboAutomatico")
local defesaBtn = createToggleButton("Defesa Automática", "defesaAutomatica")
local superRunBtn = createToggleButton("Super Run", "superRun")

-- Abrir/fechar menu
openBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    openBtn.Text = menu.Visible and "Fechar Menu" or "Abrir Menu"
end)

-- Funções base (você pode personalizar aqui)
local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
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

local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local cam = workspace.CurrentCamera
            local root = target.Character.HumanoidRootPart
            cam.CFrame = CFrame.new(cam.CFrame.Position, root.Position)
        end
    end

    if states.defesaAutomatica and hum then
        if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    if states.superRun and hum then
        hum.WalkSpeed = 50
    else
        if hum then hum.WalkSpeed = 16 end
    end
end)

-- Loop farm kill e combo automático
task.spawn(function()
    while true do
        if states.autoFarmKill then
            local target = getClosestEnemy()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    myRoot.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    -- Aqui você pode adicionar a função para ativar a skill
                    print("AutoFarmKill ativando skill")
                end
            end
        end

        if states.comboAutomatico then
            -- Aqui você pode colocar o combo automático
            print("Combo automático rodando")
        end

        task.wait(0.5)
    end
end)
