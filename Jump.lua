-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MultiFunctionUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Botão abrir/fechar
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 130, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextScaled = true
openBtn.Text = "Abrir Menu"
openBtn.Parent = gui

-- Menu scroll
local menu = Instance.new("ScrollingFrame")
menu.Size = UDim2.new(0, 270, 0, 400)
menu.Position = UDim2.new(0, 20, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.ScrollBarThickness = 6
menu.CanvasSize = UDim2.new(0, 0, 0, 0) -- Ajustado dinamicamente
menu.Visible = false
menu.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = menu

-- Estados
local states = {
    aimbot = false,
    autoFarmKill = false,
    comboAutomatico = false,
    defesaAutomatica = false,
    superRun = false,
    infiniteStamina = false,
    autoJump = false,
    teleportClosest = false,
    autoHeal = false,
    antiRagdoll = false,
}

-- Criar botão toggle
local function createToggleButton(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
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

-- Criar botões
local btnAimbot = createToggleButton("Aimbot", "aimbot")
local btnAutoFarm = createToggleButton("Auto Farm Kill", "autoFarmKill")
local btnCombo = createToggleButton("Combo Automático", "comboAutomatico")
local btnDefesa = createToggleButton("Defesa Automática", "defesaAutomatica")
local btnSuperRun = createToggleButton("Super Run", "superRun")
local btnInfiniteStamina = createToggleButton("Infinite Stamina", "infiniteStamina")
local btnAutoJump = createToggleButton("Auto Jump", "autoJump")
local btnTeleportClosest = createToggleButton("Teleport to Closest", "teleportClosest")
local btnAutoHeal = createToggleButton("Auto Heal", "autoHeal")
local btnAntiRagdoll = createToggleButton("Anti Ragdoll", "antiRagdoll")

-- Abrir/fechar menu
openBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    openBtn.Text = menu.Visible and "Fechar Menu" or "Abrir Menu"
end)

-- Funções auxiliares
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

local function pressSkill(id)
    -- Exemplo: envia input virtual (não funciona em mobile)
    local vu = game:GetService("VirtualInputManager")
    vu:SendKeyEvent(true, Enum.KeyCode[tostring(id)], false, game)
    task.wait(0.05)
    vu:SendKeyEvent(false, Enum.KeyCode[tostring(id)], false, game)
end

local hum = nil
local char = nil

local function updateChar()
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:FindFirstChildOfClass("Humanoid")
end

updateChar()
player.CharacterAdded:Connect(updateChar)

-- Loop principal
RunService.RenderStepped:Connect(function()
    if not hum then return end

    -- Aimbot
    if states.aimbot then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local cam = workspace.CurrentCamera
            local root = target.Character.HumanoidRootPart
            cam.CFrame = CFrame.new(cam.CFrame.Position, root.Position)
        end
    end

    -- Defesa automática
    if states.defesaAutomatica then
        if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    -- Super Run
    if states.superRun then
        hum.WalkSpeed = 50
    else
        hum.WalkSpeed = 16
    end

    -- Infinite Stamina (se existir atributo stamina)
    if states.infiniteStamina then
        if hum:GetAttribute("Stamina") then
            hum:SetAttribute("Stamina", 100000)
        end
    end

    -- Auto Jump
    if states.autoJump then
        if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum.Jump = true
        end
    end

    -- Auto Heal (se o humanoid tiver Health)
    if states.autoHeal then
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end

    -- Anti Ragdoll
    if states.antiRagdoll then
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    -- Teleport to closest enemy
    if states.teleportClosest then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
        end
    end
end)

-- Loop farm kill e combo automático
task.spawn(function()
    while true do
        if states.autoFarmKill then
            -- Exemplo: ativar skill (você pode modificar para ativar evento do jogo)
            print("Auto Farm Kill ativo - ativando skill")
            pressSkill(1) -- tenta ativar skill 1
        end

        if states.comboAutomatico then
            print("Combo automático rodando")
            for i = 1, 4 do
                pressSkill(i)
                task.wait(0.1)
            end
        end

        task.wait(0.5)
    end
end)
