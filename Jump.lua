-- Roblox Mobile Script: Jump Showdown Exploit GUI
-- Feito para Solara (UI framework) e compatível com celular

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Solara = require(game.ReplicatedStorage.Solara)

local function createExploitUI()
    local uiOpen, setUiOpen = Solara.useState(true)
    local autoFarm, setAutoFarm = Solara.useState(false)
    local noDashCooldown, setNoDashCooldown = Solara.useState(false)
    local infiniteWallRun, setInfiniteWallRun = Solara.useState(false)
    local noWallRunCooldown, setNoWallRunCooldown = Solara.useState(false)
    local noWallComboCooldown, setNoWallComboCooldown = Solara.useState(false)
    local biggerWallComboHitbox, setBiggerWallComboHitbox = Solara.useState(false)
    local lockOn, setLockOn = Solara.useState(false)
    local superRun, setSuperRun = Solara.useState(false)
    local autoGuard, setAutoGuard = Solara.useState(false)
    local aimbot, setAimbot = Solara.useState(false)

    Solara.useRenderStep("SuperRun", function()
        if superRun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 150
        end
    end)

    Solara.useRenderStep("AutoGuard", function()
        if autoGuard and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)

    Solara.useRenderStep("Aimbot", function()
        if aimbot then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                    end
                end
            end
        end
    end)

    return Solara.createFragment {
        ToggleUI = Solara.Button {
            Text = uiOpen and "Fechar Menu" or "Abrir Menu",
            Position = UDim2.new(0.05, 0, 0.05, 0),
            Size = UDim2.new(0, 120, 0, 40),
            OnClick = function() setUiOpen(not uiOpen) end,
            BackgroundColor = Color3.fromRGB(60, 60, 60),
            TextColor = Color3.fromRGB(255, 255, 255),
            CornerRadius = 8
        },

        MainUI = uiOpen and Solara.Window {
            Name = "JumpShowdownExploitUI",
            Title = "Clandestine Menu",
            Size = UDim2.new(0, 340, 0, 420),
            BackgroundColor = Color3.fromRGB(25, 25, 25),
            Draggable = true,
            Position = UDim2.new(0.25, 0, 0.2, 0),

            Solara.Frame {
                Size = UDim2.new(1, -20, 1, -20),
                Padding = 10,
                BackgroundTransparency = 1,
                LayoutOrder = {
                    Solara.Toggle { Text = "Auto Farm", Value = autoFarm, OnToggle = setAutoFarm },
                    Solara.Toggle { Text = "No Dash Cooldown", Value = noDashCooldown, OnToggle = setNoDashCooldown },
                    Solara.Toggle { Text = "Infinite WallRun", Value = infiniteWallRun, OnToggle = setInfiniteWallRun },
                    Solara.Toggle { Text = "No Wall Run Cooldown", Value = noWallRunCooldown, OnToggle = setNoWallRunCooldown },
                    Solara.Toggle { Text = "No Wall Combo Cooldown", Value = noWallComboCooldown, OnToggle = setNoWallComboCooldown },
                    Solara.Toggle { Text = "Bigger WallCombo Hitbox", Value = biggerWallComboHitbox, OnToggle = setBiggerWallComboHitbox },
                    Solara.Toggle { Text = "Lock On", Value = lockOn, OnToggle = setLockOn },
                    Solara.Toggle { Text = "Super Run", Value = superRun, OnToggle = setSuperRun },
                    Solara.Toggle { Text = "Auto Guard", Value = autoGuard, OnToggle = setAutoGuard },
                    Solara.Toggle { Text = "Aimbot (peito)", Value = aimbot, OnToggle = setAimbot },
                }
            }
        }
    }
end

return createExploitUI
