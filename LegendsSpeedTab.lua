local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local LegendsSpeedTab = Window:CreateTab("Legends of Speed", 4483362458)

local FarmingSection = LegendsSpeedTab:CreateSection("Auto Farming")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        getgenv().AutoOrbs = Value
        
        while getgenv().AutoOrbs do
            pcall(function()
                -- Collect orbs in main workspace
                for _, orb in pairs(workspace.orbFolder:GetChildren()) do
                    if orb:IsA("Part") then
                        local args = {
                            [1] = "collectOrb",
                            [2] = orb
                        }
                        ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                    end
                end

                -- Collect orbs in all worlds
                for _, world in pairs(workspace:GetChildren()) do
                    if world.Name:match("World") then
                        for _, orb in pairs(world:GetDescendants()) do
                            if orb:IsA("Part") and orb.Name == "outerOrb" then
                                local args = {
                                    [1] = "collectOrb",
                                    [2] = orb
                                }
                                ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end
})

-- Enhanced Auto Rebirth with optimization
LegendsSpeedTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        getgenv().AutoRebirth = Value
        
        while getgenv().AutoRebirth do
            pcall(function()
                local args = {
                    [1] = "rebirthRequest"
                }
                ReplicatedStorage.rEvents.rebirthEvent:FireServer(unpack(args))
            end)
            task.wait(0.1)
        end
    end
})

-- Enhanced Auto Race with all tracks
LegendsSpeedTab:CreateToggle({
    Name = "Auto Race",
    CurrentValue = false,
    Flag = "AutoRace",
    Callback = function(Value)
        getgenv().AutoRace = Value
        
        while getgenv().AutoRace do
            pcall(function()
                for _, race in pairs(workspace:GetChildren()) do
                    if race.Name:find("raceStart") then
                        firetouchinterest(rootPart, race, 0)
                        task.wait()
                        firetouchinterest(rootPart, race, 1)
                        break
                    end
                end
            end)
            task.wait(0.5)
        end
    end
})

-- Enhanced Auto Collect Gems with magnet feature
LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Gems",
    CurrentValue = false,
    Flag = "AutoGems",
    Callback = function(Value)
        getgenv().AutoGems = Value
        
        while getgenv().AutoGems do
            pcall(function()
                for _, gem in pairs(workspace.gemFolder:GetChildren()) do
                    if gem:IsA("Part") then
                        -- Magnet effect
                        local oldPos = gem.Position
                        gem.CFrame = rootPart.CFrame
                        
                        local args = {
                            [1] = "collectGem",
                            [2] = gem
                        }
                        ReplicatedStorage.rEvents.gemEvent:FireServer(unpack(args))
                        
                        -- Reset position to prevent detection
                        gem.Position = oldPos
                    end
                end
            end)
            task.wait(0.1)
        end
    end
})

-- Auto Steps Section
local StepsSection = LegendsSpeedTab:CreateSection("Steps & Trails")

-- Enhanced Auto Buy Steps
LegendsSpeedTab:CreateToggle({
    Name = "Auto Buy Steps",
    CurrentValue = false,
    Flag = "AutoSteps",
    Callback = function(Value)
        getgenv().AutoSteps = Value
        
        while getgenv().AutoSteps do
            pcall(function()
                local args = {
                    [1] = "buyAllSteps"
                }
                ReplicatedStorage.rEvents.stepEvent:FireServer(unpack(args))
            end)
            task.wait(1)
        end
    end
})

-- Enhanced Auto Buy Trails
LegendsSpeedTab:CreateToggle({
    Name = "Auto Buy Trails",
    CurrentValue = false,
    Flag = "AutoTrails",
    Callback = function(Value)
        getgenv().AutoTrails = Value
        
        while getgenv().AutoTrails do
            pcall(function()
                local args = {
                    [1] = "buyAllTrails"
                }
                ReplicatedStorage.rEvents.trailEvent:FireServer(unpack(args))
            end)
            task.wait(1)
        end
    end
})

-- Hoops Section with auto collect
local HoopsSection = LegendsSpeedTab:CreateSection("Hoops")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Hoops",
    CurrentValue = false,
    Flag = "AutoHoops",
    Callback = function(Value)
        getgenv().AutoHoops = Value
        
        while getgenv().AutoHoops do
            pcall(function()
                for _, hoop in pairs(workspace.Hoops:GetChildren()) do
                    if hoop:IsA("Part") then
                        local oldPos = rootPart.CFrame
                        rootPart.CFrame = hoop.CFrame
                        
                        local args = {
                            [1] = "collectOrb",
                            [2] = hoop
                        }
                        ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                        
                        rootPart.CFrame = oldPos
                        task.wait(0.1)
                    end
                end
            end)
            task.wait(1)
        end
    end
})

-- World Teleport Section with smooth transitions
local TeleportSection = LegendsSpeedTab:CreateSection("World Teleport")

local worlds = {
    ["City"] = CFrame.new(-9682.98, 74.8522, 3099.89),
    ["Snow City"] = CFrame.new(-9676.01, 74.8522, 3782.31),
    ["Magma City"] = CFrame.new(-11054.9, 74.8522, 3819.92),
    ["Space"] = CFrame.new(-8629.7998, 74.8522, 3735.96997),
    ["Candy Land"] = CFrame.new(-11054.9, 74.8522, 4048.97)
}

LegendsSpeedTab:CreateDropdown({
    Name = "Select World",
    Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
    CurrentOption = "City",
    Flag = "SelectedWorld",
    Callback = function(Value)
        pcall(function()
            if worlds[Value] then
                -- Smooth teleport
                local tween = TweenService:Create(rootPart, 
                    TweenInfo.new(1, Enum.EasingStyle.Quad), 
                    {CFrame = worlds[Value]}
                )
                tween:Play()
            end
        end)
    end
})

-- Auto Farm All Worlds
LegendsSpeedTab:CreateToggle({
    Name = "Auto Farm All Worlds",
    CurrentValue = false,
    Flag = "AutoFarmWorlds",
    Callback = function(Value)
        getgenv().AutoFarmWorlds = Value
        
        while getgenv().AutoFarmWorlds do
            pcall(function()
                for worldName, worldCFrame in pairs(worlds) do
                    if not getgenv().AutoFarmWorlds then break end
                    
                    -- Teleport to world
                    local tween = TweenService:Create(rootPart,
                        TweenInfo.new(1, Enum.EasingStyle.Quad),
                        {CFrame = worldCFrame}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    
                    -- Farm orbs in this world
                    for i = 1, 50 do
                        if not getgenv().AutoFarmWorlds then break end
                        
                        for _, orb in pairs(workspace:GetDescendants()) do
                            if orb:IsA("Part") and (orb.Name == "outerOrb" or orb.Name:find("Orb")) then
                                local args = {
                                    [1] = "collectOrb",
                                    [2] = orb
                                }
                                ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                            end
                        end
                        task.wait(0.1)
                    end
                end
            end)
            task.wait(1)
        end
    end
})

-- Speed Boost Section
local BoostSection = LegendsSpeedTab:CreateSection("Speed Boosts")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Use Speed Boosts",
    CurrentValue = false,
    Flag = "AutoBoosts",
    Callback = function(Value)
        getgenv().AutoBoosts = Value
        
        while getgenv().AutoBoosts do
            pcall(function()
                local args = {
                    [1] = "useBoost",
                    [2] = "Speed"
                }
                ReplicatedStorage.rEvents.boostEvent:FireServer(unpack(args))
            end)
            task.wait(1)
        end
    end
})

-- Pet Section
local PetSection = LegendsSpeedTab:CreateSection("Pets")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Hatch Best Egg",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(Value)
        getgenv().AutoHatch = Value
        
        while getgenv().AutoHatch do
            pcall(function()
                local args = {
                    [1] = "openCrystal",
                    [2] = "Best"
                }
                ReplicatedStorage.rEvents.openCrystalRemote:FireServer(unpack(args))
            end)
            task.wait(0.5)
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Equip Best Pets",
    CurrentValue = false,
    Flag = "AutoEquipPets",
    Callback = function(Value)
        getgenv().AutoEquipPets = Value
        
        while getgenv().AutoEquipPets do
            pcall(function()
                local args = {
                    [1] = "equipBest"
                }
                ReplicatedStorage.rEvents.petEquipEvent:FireServer(unpack(args))
            end)
            task.wait(1)
        end
    end
})

-- Stats Section
local StatsSection = LegendsSpeedTab:CreateSection("Stats")

LegendsSpeedTab:CreateToggle({
    Name = "Show Stats",
    CurrentValue = false,
    Flag = "ShowStats",
    Callback = function(Value)
        if Value then
            -- Create stats GUI
            local statsGui = Instance.new("ScreenGui")
            statsGui.Name = "SpeedStats"
            statsGui.Parent = player.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 100)
            frame.Position = UDim2.new(0, 10, 0.5, -50)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.Parent = statsGui
            
            local stats = Instance.new("TextLabel")
            stats.Size = UDim2.new(1, -10, 1, -10)
            stats.Position = UDim2.new(0, 5, 0, 5)
            stats.BackgroundTransparency = 1
            stats.TextColor3 = Color3.fromRGB(255, 255, 255)
            stats.TextSize = 14
            stats.Font = Enum.Font.GothamBold
            stats.Parent = frame
            
            -- Update stats
            RunService.RenderStepped:Connect(function()
                if not Value then return end
                stats.Text = string.format(
                    "Speed: %d\nRebirths: %d\nGems: %d",
                    player.leaderstats.Speed.Value,
                    player.leaderstats.Rebirths.Value,
                    player.leaderstats.Gems.Value
                )
            end)
        else
            local statsGui = player.PlayerGui:FindFirstChild("SpeedStats")
            if statsGui then statsGui:Destroy() end
        end
    end
})

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

Rayfield:Notify({
    Title = "Legends of Speed",
    Content = "Enhanced script loaded successfully!",
    Duration = 3
})
