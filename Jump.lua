local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Solara = require(game.ReplicatedStorage.Solara)

local indigo = Color3.fromRGB(75, 0, 130)
local periwinkle = Color3.fromRGB(204, 204, 255)

local function JumpShowdownHub()
    local lockedTarget, setLockedTarget = Solara.useState(nil)
    local lockOnActive, setLockOnActive = Solara.useState(false)
    local behindUEnabled, setBehindUEnabled = Solara.useState(false)
    local teleportEnabled, setTeleportEnabled = Solara.useState(false)
    local playerList, setPlayerList = Solara.useState(Players:GetPlayers())

    Solara.useEffect(function()
        local function updatePlayers()
            setPlayerList(Players:GetPlayers())
        end
        Players.PlayerAdded:Connect(updatePlayers)
        Players.PlayerRemoving:Connect(updatePlayers)
    end, {})

    local function handleTeleport()
        if teleportEnabled and lockedTarget and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 3, 0))
            end
        end
    end

    Solara.useRenderStep("CameraControl", function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart")

        if behindUEnabled and targetRoot and myRoot then
            local offset = targetRoot.CFrame.LookVector * -2
            myRoot.CFrame = CFrame.new(targetRoot.Position + offset + Vector3.new(0, 1, 0), targetRoot.Position)
            Camera.CameraType = Enum.CameraType.Custom
        elseif lockOnActive and targetRoot and myRoot then
            local cameraOffset = Vector3.new(0, 4, -8)
            local desiredPos = myRoot.Position + cameraOffset
            local lookAt = targetRoot.Position + Vector3.new(0, 2, 0)
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(desiredPos, lookAt), 0.35)
        else
            Camera.CameraType = Enum.CameraType.Custom
        end
    end)

    return Solara.createFragment{
        MainWindow = Solara.Window {
            Name = "JumpShowdownMobileUI",
            Title = "Jump Showdown Hub (Mobile)",
            Size = UDim2.new(0, 360, 0, 460),
            MinSize = Vector2.new(340, 420),
            BackgroundColor = indigo,
            Draggable = true,

            Solara.Frame {
                Size = UDim2.new(1, 0, 1, 0),
                Padding = 12,
                BackgroundTransparency = 1,

                LayoutOrder = {
                    Solara.Text {
                        Text = "Jump Showdown Lock-On (Mobile)",
                        TextSize = 24,
                        TextColor = periwinkle,
                        Font = Enum.Font.SourceSansBold
                    },

                    Solara.ScrollView {
                        Size = UDim2.new(1, 0, 0, 150),
                        BackgroundColor = indigo,
                        ForEach = playerList,
                        OnRender = function(player)
                            if player == LocalPlayer then return end
                            return Solara.Button {
                                Text = string.format("%s   [%s]", player.DisplayName or player.Name, player.Name),
                                Size = UDim2.new(1, 0, 0, 30),
                                BackgroundColor = periwinkle,
                                TextColor = indigo,
                                OnClick = function() setLockedTarget(player) end,
                                Margin = { Bottom = 4 },
                                CornerRadius = 8
                            }
                        end
                    },

                    Solara.Button {
                        Text = "Lock-On: " .. (lockOnActive and "ON" or "OFF"),
                        OnClick = function() setLockOnActive(not lockOnActive) end,
                        BackgroundColor = periwinkle,
                        TextColor = indigo,
                        CornerRadius = 10
                    },

                    Solara.Button {
                        Text = "BehindU (AutoFarm): " .. (behindUEnabled and "ON" or "OFF"),
                        OnClick = function() setBehindUEnabled(not behindUEnabled) end,
                        BackgroundColor = periwinkle,
                        TextColor = indigo,
                        CornerRadius = 10
                    },

                    Solara.Button {
                        Text = "Teleporte: " .. (teleportEnabled and "ON" or "OFF"),
                        OnClick = function()
                            setTeleportEnabled(true)
                            handleTeleport()
                            task.wait(0.3)
                            setTeleportEnabled(false)
                        end,
                        BackgroundColor = periwinkle,
                        TextColor = indigo,
                        CornerRadius = 10
                    },

                    Solara.Text {
                        Text = "Toque para teleportar.\nSelecione jogador para Lock-On.",
                        TextColor = periwinkle,
                        TextSize = 16
                    }
                }
            }
        }
    }
end

return JumpShowdownHub
