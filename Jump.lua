--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Solara = require(game.ReplicatedStorage.Solara)

local indigo = Color3.fromRGB(75, 0, 130)
local periwinkle = Color3.fromRGB(204, 204, 255)

local function JumpShowdownHub()
    local lockedTarget, setLockedTarget = Solara.useState(nil)
    local lockOnActive, setLockOnActive = Solara.useState(false)
    local behindUEnabled, setBehindUEnabled = Solara.useState(false)
    local ctrlHeld, setCtrlHeld = Solara.useState(false)
    local playerList, setPlayerList = Solara.useState(Players:GetPlayers())

    -- Player list management
    Solara.useEffect(function()
        local function updatePlayers()
            setPlayerList(Players:GetPlayers())
        end
        
        Players.PlayerAdded:Connect(updatePlayers)
        Players.PlayerRemoving:Connect(updatePlayers)
        return function()
            Players.PlayerAdded:Disconnect(updatePlayers)
            Players.PlayerRemoving:Disconnect(updatePlayers)
        end
    end, {})

    -- Input handling
    Solara.useInput(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            setCtrlHeld(input.UserInputState == Enum.UserInputState.Begin)
        end
    end)

    -- Teleportation logic
    local function handleTeleport(target)
        if ctrlHeld and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(target.p + Vector3.new(0, 3, 0))
            end
        end
    end

    -- Camera logic
    Solara.useRenderStep("CameraControl", function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart")

        if behindUEnabled and targetRoot and myRoot then
            local offset = targetRoot.CFrame.LookVector * -2
            local newPos = targetRoot.Position + offset + Vector3.new(0, 1, 0)
            myRoot.CFrame = CFrame.new(newPos, targetRoot.Position)
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
            Name = "JumpShowdownLockOnUI",
            Title = "Jump Showdown Lock-On",
            Size = UDim2.new(0, 340, 0, 420),
            MinSize = Vector2.new(340, 420),
            BackgroundColor = indigo,
            Draggable = true,
            
            Solara.Frame {
                Size = UDim2.new(1, 0, 1, 0),
                Padding = 16,
                BackgroundTransparency = 1,
                
                LayoutOrder = {
                    Solara.Text {
                        Text = "Jump Showdown Lock-On",
                        TextSize = 28,
                        TextColor = periwinkle,
                        Font = Enum.Font.SourceSansBold
                    },
                    
                    Solara.ScrollView {
                        Size = UDim2.new(1, 0, 0, 140),
                        BackgroundColor = indigo,
                        
                        ForEach = playerList,
                        OnRender = function(player)
                            if player == LocalPlayer then return end
                            return Solara.Button {
                                Text = string.format("%s   [%s]", player.DisplayName or player.Name, player.Name),
                                Size = UDim2.new(1, 0, 0, 32),
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
                        CornerRadius = 12
                    },
                    
                    Solara.Button {
                        Text = "BehindU: " .. (behindUEnabled and "ON" or "OFF"),
                        OnClick = function() setBehindUEnabled(not behindUEnabled) end,
                        BackgroundColor = periwinkle,
                        TextColor = indigo,
                        CornerRadius = 12
                    },
                    
                    Solara.Text {
                        Text = "Select a player to lock-on.\nToggle BehindU to autofarm.\nHold LeftCtrl & LeftClick to teleport.",
                        TextColor = periwinkle,
                        TextSize = 18
                    }
                }
            }
        },
        
        ClickHandler = Solara.ClickDetector {
            OnClick = handleTeleport,
            Active = ctrlHeld
        }
    }
end

return JumpShowdownHub
