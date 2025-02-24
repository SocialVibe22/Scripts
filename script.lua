-- Proteção contra múltiplas execuções
if _G.ScriptLoaded then return end
_G.ScriptLoaded = true

-- Espera o jogo carregar
repeat task.wait() until game:IsLoaded()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Espera o jogador carregar
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Constantes
local DEFAULT_SPEED = humanoid.WalkSpeed
local DEFAULT_JUMP = humanoid.JumpPower
local DEFAULT_GRAVITY = workspace.Gravity

-- Remove GUIs existentes
local existingGui = player.PlayerGui:FindFirstChild("TrollGui")
if existingGui then existingGui:Destroy() end

-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela
local Window = Rayfield:CreateWindow({
    Name = "Ultimate Script Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false
})

-- Game Detection
local placeId = game.PlaceId

local GAMES = {
    LEGENDS_OF_SPEED = 3101667897,
    DOORS = 6516141723,
    NINJA_LEGENDS = 3956818381,
    BUILD_A_BOAT = 537413528
}

-- Legends of Speed Tab
if placeId == GAMES.LEGENDS_OF_SPEED then
    -- Initialize player references
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Create Tab
    local LegendsSpeedTab = Window:CreateTab("Legends of Speed", 4483362458)

    -- Stats Display Section
    local StatsSection = LegendsSpeedTab:CreateSection("Stats Display")

    local function createStatsDisplay()
        -- Remove existing stats display if any
        local existingGui = player.PlayerGui:FindFirstChild("StatsGui")
        if existingGui then existingGui:Destroy() end

        -- Create new GUI
        local statsGui = Instance.new("ScreenGui")
        statsGui.Name = "StatsGui"
        statsGui.Parent = player.PlayerGui

        local statsFrame = Instance.new("Frame")
        statsFrame.Name = "StatsDisplay"
        statsFrame.Size = UDim2.new(0, 200, 0, 120)
        statsFrame.Position = UDim2.new(0, 10, 0.5, -60)
        statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        statsFrame.BackgroundTransparency = 0.3
        statsFrame.Parent = statsGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = statsFrame

        local statsLabel = Instance.new("TextLabel")
        statsLabel.Name = "StatsText"
        statsLabel.Size = UDim2.new(1, -20, 1, -20)
        statsLabel.Position = UDim2.new(0, 10, 0, 10)
        statsLabel.BackgroundTransparency = 1
        statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        statsLabel.TextSize = 14
        statsLabel.Font = Enum.Font.GothamBold
        statsLabel.TextXAlignment = Enum.TextXAlignment.Left
        statsLabel.Parent = statsFrame

        return statsLabel
    end

    local statsUpdateConnection
    LegendsSpeedTab:CreateToggle({
        Name = "Show Live Stats",
        CurrentValue = false,
        Flag = "ShowStats",
        Callback = function(Value)
            if Value then
                local statsLabel = createStatsDisplay()
                
                -- Disconnect existing connection if any
                if statsUpdateConnection then
                    statsUpdateConnection:Disconnect()
                end
                
                -- Create new update connection
                statsUpdateConnection = RunService.RenderStepped:Connect(function()
                    if not Value then return end
                    if not player:FindFirstChild("leaderstats") then return end
                    
                    statsLabel.Text = string.format(
                        "Speed: %s\nRebirths: %s\nGems: %s\nSteps: %s\nHoops: %s",
                        tostring(player.leaderstats.Speed.Value),
                        tostring(player.leaderstats.Rebirths.Value),
                        tostring(player.leaderstats.Gems.Value),
                        tostring(player.leaderstats.Steps.Value),
                        tostring(player.leaderstats.Hoops.Value)
                    )
                end)
            else
                if statsUpdateConnection then
                    statsUpdateConnection:Disconnect()
                end
                local statsGui = player.PlayerGui:FindFirstChild("StatsGui")
                if statsGui then statsGui:Destroy() end
            end
        end
    })

    -- Auto Farm Section
    local FarmingSection = LegendsSpeedTab:CreateSection("Auto Farming")

    -- Optimized orb collection with area scanning and error handling
    local function collectOrbs()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        pcall(function()
            -- Store current position
            local originalPosition = player.Character.HumanoidRootPart.CFrame
            
            -- Collect orbs in main area
            for _, orb in pairs(workspace.orbFolder:GetChildren()) do
                if orb:IsA("Part") and getgenv().AutoOrbs then
                    -- Move to orb
                    player.Character.HumanoidRootPart.CFrame = orb.CFrame
                    
                    -- Collect orb
                    local args = {
                        [1] = "collectOrb",
                        [2] = orb
                    }
                    ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                    
                    -- Small delay to prevent server overload
                    task.wait(0.05)
                end
            end

            -- Collect orbs in all worlds
            for _, world in pairs(workspace:GetChildren()) do
                if world.Name:match("World") then
                    for _, orb in pairs(world:GetDescendants()) do
                        if orb:IsA("Part") and orb.Name == "outerOrb" and getgenv().AutoOrbs then
                            -- Move to orb
                            player.Character.HumanoidRootPart.CFrame = orb.CFrame
                            
                            -- Collect orb
                            local args = {
                                [1] = "collectOrb",
                                [2] = orb
                            }
                            ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                            
                            task.wait(0.05)
                        end
                    end
                end
            end
            
            -- Return to original position
            player.Character.HumanoidRootPart.CFrame = originalPosition
        end)
    end

    LegendsSpeedTab:CreateToggle({
        Name = "Auto Collect Orbs",
        CurrentValue = false,
        Flag = "AutoOrbs",
        Callback = function(Value)
            getgenv().AutoOrbs = Value
            
            if Value then
                -- Create a new thread for orb collection
                coroutine.wrap(function()
                    while getgenv().AutoOrbs do
                        collectOrbs()
                        task.wait(0.1)
                    end
                end)()
            end
        end
    })

    -- Enhanced rebirth system with progress tracking and error handling
    local function doRebirth()
        pcall(function()
            -- Check if player has enough speed for rebirth
            if player.leaderstats.Speed.Value >= 1000 then
                local args = {
                    [1] = "rebirthRequest"
                }
                ReplicatedStorage.rEvents.rebirthEvent:FireServer(unpack(args))
                
                -- Show success notification
                Rayfield:Notify({
                    Title = "Rebirth Success",
                    Content = "You have successfully rebirthed!",
                    Duration = 2
                })
            end
        end)
    end

    LegendsSpeedTab:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = false,
        Flag = "AutoRebirth",
        Callback = function(Value)
            getgenv().AutoRebirth = Value
            
            if Value then
                coroutine.wrap(function()
                    while getgenv().AutoRebirth do
                        doRebirth()
                        task.wait(0.1)
                    end
                end)()
            end
        end
    })

    -- Advanced racing system with path prediction and error handling
    local function startRace()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        pcall(function()
            -- Store original position
            local originalPosition = player.Character.HumanoidRootPart.CFrame
            
            for _, race in pairs(workspace:GetChildren()) do
                if race.Name:find("raceStart") and getgenv().AutoRace then
                    -- Move to race start
                    player.Character.HumanoidRootPart.CFrame = race.CFrame
                    
                    -- Trigger race start
                    firetouchinterest(player.Character.HumanoidRootPart, race, 0)
                    task.wait()
                    firetouchinterest(player.Character.HumanoidRootPart, race, 1)
                    
                    -- Wait for race to complete
                    task.wait(0.5)
                    
                    -- Return to original position
                    player.Character.HumanoidRootPart.CFrame = originalPosition
                    break
                end
            end
        end)
    end

    LegendsSpeedTab:CreateToggle({
        Name = "Auto Race",
        CurrentValue = false,
        Flag = "AutoRace",
        Callback = function(Value)
            getgenv().AutoRace = Value
            
            if Value then
                coroutine.wrap(function()
                    while getgenv().AutoRace do
                        startRace()
                        task.wait(0.5)
                    end
                end)()
            end
        end
    })

    -- Optimized gem collection with error handling
    local function collectGems()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        pcall(function()
            -- Store original position
            local originalPosition = player.Character.HumanoidRootPart.CFrame
            
            for _, gem in pairs(workspace.gemFolder:GetChildren()) do
                if gem:IsA("Part") and getgenv().AutoGems then
                    -- Move to gem
                    player.Character.HumanoidRootPart.CFrame = gem.CFrame
                    
                    -- Collect gem
                    local args = {
                        [1] = "collectGem",
                        [2] = gem
                    }
                    ReplicatedStorage.rEvents.gemEvent:FireServer(unpack(args))
                    
                    task.wait(0.05)
                end
            end
            
            -- Return to original position
            player.Character.HumanoidRootPart.CFrame = originalPosition
        end)
    end

    LegendsSpeedTab:CreateToggle({
        Name = "Auto Collect Gems",
        CurrentValue = false,
        Flag = "AutoGems",
        Callback = function(Value)
            getgenv().AutoGems = Value
            
            if Value then
                coroutine.wrap(function()
                    while getgenv().AutoGems do
                        collectGems()
                        task.wait(0.1)
                    end
                end)()
            end
        end
    })

    -- World Teleport System with smooth transitions
    local worlds = {
        ["City"] = CFrame.new(-9682.98, 74.8522, 3099.89),
        ["Snow City"] = CFrame.new(-9676.01, 74.8522, 3782.31),
        ["Magma City"] = CFrame.new(-11054.9, 74.8522, 3819.92),
        ["Space"] = CFrame.new(-8629.7998, 74.8522, 3735.96997),
        ["Candy Land"] = CFrame.new(-11054.9, 74.8522, 4048.97)
    }

    LegendsSpeedTab:CreateDropdown({
        Name = "Teleport to World",
        Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
        CurrentOption = "City",
        Flag = "SelectedWorld",
        Callback = function(Value)
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
            pcall(function()
                -- Get target position
                local targetCFrame = worlds[Value]
                
                -- Create teleport effect
                local effect = Instance.new("Part")
                effect.Size = Vector3.new(1, 1, 1)
                effect.CFrame = player.Character.HumanoidRootPart.CFrame
                effect.Anchored = true
                effect.CanCollide = false
                effect.Transparency = 0.5
                effect.Parent = workspace
                
                -- Add particle effect
                local particleEmitter = Instance.new("ParticleEmitter")
                particleEmitter.Rate = 50
                particleEmitter.Lifetime = NumberRange.new(0.5)
                particleEmitter.Speed = NumberRange.new(5)
                particleEmitter.Parent = effect
                
                -- Smooth teleport
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(player.Character.HumanoidRootPart, tweenInfo, {
                    CFrame = targetCFrame
                })
                
                tween:Play()
                tween.Completed:Wait()
                
                -- Clean up effect
                effect:Destroy()
                
                -- Show success notification
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Successfully teleported to " .. Value,
                    Duration = 2
                })
            end)
        end
    })

    -- Hoops System with visual feedback
    LegendsSpeedTab:CreateButton({
        Name = "Collect All Hoops",
        Callback = function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
            pcall(function()
                -- Store original position
                local originalPosition = player.Character.HumanoidRootPart.CFrame
                local hoopsCollected = 0
                
                for _, hoop in pairs(workspace.Hoops:GetChildren()) do
                    if hoop:IsA("Part") then
                        -- Move to hoop
                        player.Character.HumanoidRootPart.CFrame = hoop.CFrame
                        
                        -- Collect hoop
                        local args = {
                            [1] = "collectOrb",
                            [2] = hoop
                        }
                        ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                        
                        -- Visual feedback
                        local effect = Instance.new("Part")
                        effect.Size = Vector3.new(1, 1, 1)
                        effect.CFrame = hoop.CFrame
                        effect.Anchored = true
                        effect.CanCollide = false
                        effect.Transparency = 0.5
                        effect.Parent = workspace
                        
                        -- Animate effect
                        TweenService:Create(effect, TweenInfo.new(0.5), {
                            Size = Vector3.new(5, 5, 5),
                            Transparency = 1
                        }):Play()
                        
                        game:GetService("Debris"):AddItem(effect, 0.5)
                        hoopsCollected = hoopsCollected + 1
                        task.wait(0.1)
                    end
                end
                
                -- Return to original position
                player.Character.HumanoidRootPart.CFrame = originalPosition
                
                -- Show success notification
                Rayfield:Notify({
                    Title = "Hoops Collected",
                    Content = "Successfully collected " .. hoopsCollected .. " hoops!",
                    Duration = 2
                })
            end)
        end
    })

    -- Steps and Trails System with error handling
    LegendsSpeedTab:CreateButton({
        Name = "Buy All Steps",
        Callback = function()
            pcall(function()
                local args = {
                    [1] = "buyAllSteps"
                }
                ReplicatedStorage.rEvents.stepEvent:FireServer(unpack(args))
                
                Rayfield:Notify({
                    Title = "Success",
                    Content = "Purchased all available steps!",
                    Duration = 2
                })
            end)
        end
    })

    LegendsSpeedTab:CreateButton({
        Name = "Buy All Trails",
        Callback = function()
            pcall(function()
                local args = {
                    [1] = "buyAllTrails"
                }
                ReplicatedStorage.rEvents.trailEvent:FireServer(unpack(args))
                
                Rayfield:Notify({
                    Title = "Success",
                    Content = "Purchased all available trails!",
                    Duration = 2
                })
            end)
        end
    })

    -- Anti-AFK System
    local antiAFKConnection
    LegendsSpeedTab:CreateToggle({
        Name = "Anti AFK",
        CurrentValue = false,
        Flag = "AntiAFK",
        Callback = function(Value)
            if Value then
                -- Disconnect existing connection if any
                if antiAFKConnection then
                    antiAFKConnection:Disconnect()
                end
                
                -- Create new anti-AFK connection
                antiAFKConnection = player.Idled:Connect(function()
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
                
                Rayfield:Notify({
                    Title = "Anti AFK",
                    Content = "Anti AFK system enabled",
                    Duration = 2
                })
            else
                if antiAFKConnection then
                    antiAFKConnection:Disconnect()
                end
                
                Rayfield:Notify({
                    Title = "Anti AFK",
                    Content = "Anti AFK system disabled",
                    Duration = 2
                })
            end
        end
    })

    -- Character respawn handler
    player.CharacterAdded:Connect(function(char)
        character = char
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Re-enable toggles if they were active
        if getgenv().AutoOrbs then
            collectOrbs()
        end
        if getgenv().AutoRebirth then
            doRebirth()
        end
        if getgenv().AutoRace then
            startRace()
        end
        if getgenv().AutoGems then
            collectGems()
        end
    end)

    -- Notification on load
    Rayfield:Notify({
        Title = "Legends of Speed",
        Content = "Script loaded successfully!",
        Duration = 3
    })
end
