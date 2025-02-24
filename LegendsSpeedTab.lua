local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

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
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsDisplay"
    statsFrame.Size = UDim2.new(0, 200, 0, 120)
    statsFrame.Position = UDim2.new(0, 10, 0.5, -60)
    statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.Parent = player.PlayerGui:FindFirstChild("StatsGui") or Instance.new("ScreenGui", player.PlayerGui)

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

LegendsSpeedTab:CreateToggle({
    Name = "Show Live Stats",
    CurrentValue = false,
    Flag = "ShowStats",
    Callback = function(Value)
        if Value then
            local statsLabel = createStatsDisplay()
            RunService.RenderStepped:Connect(function()
                if not Value then return end
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
            local statsGui = player.PlayerGui:FindFirstChild("StatsGui")
            if statsGui then statsGui:Destroy() end
        end
    end
})

-- Auto Farm Section
local FarmingSection = LegendsSpeedTab:CreateSection("Auto Farming")

-- Optimized orb collection with area scanning
local function collectOrbs()
    if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        -- Collect orbs in main area
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
end

LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        getgenv().AutoOrbs = Value
        
        while getgenv().AutoOrbs do
            collectOrbs()
            wait(0.1)
        end
    end
})

-- Enhanced rebirth system with progress tracking
local function doRebirth()
    pcall(function()
        local args = {
            [1] = "rebirthRequest"
        }
        ReplicatedStorage.rEvents.rebirthEvent:FireServer(unpack(args))
        
        -- Show rebirth notification
        Rayfield:Notify({
            Title = "Rebirth Success",
            Content = "You have successfully rebirthed!",
            Duration = 2
        })
    end)
end

LegendsSpeedTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        getgenv().AutoRebirth = Value
        
        while getgenv().AutoRebirth do
            doRebirth()
            wait(0.1)
        end
    end
})

-- Advanced racing system with path prediction
local function startRace()
    if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        for _, race in pairs(workspace:GetChildren()) do
            if race.Name:find("raceStart") then
                -- Create visual path
                local pathfinding = game:GetService("PathfindingService")
                local path = pathfinding:CreatePath()
                path:ComputeAsync(rootPart.Position, race.Position)
                
                if path.Status == Enum.PathStatus.Success then
                    local waypoints = path:GetWaypoints()
                    for _, waypoint in ipairs(waypoints) do
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(1, 1, 1)
                        part.Position = waypoint.Position
                        part.Anchored = true
                        part.CanCollide = false
                        part.Transparency = 0.5
                        part.Parent = workspace
                        game:GetService("Debris"):AddItem(part, 1)
                    end
                end
                
                firetouchinterest(rootPart, race, 0)
                wait()
                firetouchinterest(rootPart, race, 1)
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
        
        while getgenv().AutoRace do
            startRace()
            wait(0.5)
        end
    end
})

-- Optimized gem collection
local function collectGems()
    if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        for _, gem in pairs(workspace.gemFolder:GetChildren()) do
            if gem:IsA("Part") then
                local args = {
                    [1] = "collectGem",
                    [2] = gem
                }
                ReplicatedStorage.rEvents.gemEvent:FireServer(unpack(args))
            end
        end
    end)
end

LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Gems",
    CurrentValue = false,
    Flag = "AutoGems",
    Callback = function(Value)
        getgenv().AutoGems = Value
        
        while getgenv().AutoGems do
            collectGems()
            wait(0.1)
        end
    end
})

-- World Teleport System
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
        if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        -- Smooth teleport with effects
        local targetCFrame = worlds[Value]
        local tweenInfo = TweenInfo.new(
            1,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        
        -- Create teleport effect
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.CFrame = rootPart.CFrame
        effect.Anchored = true
        effect.CanCollide = false
        effect.Transparency = 0.5
        effect.Parent = workspace
        
        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Rate = 50
        particleEmitter.Lifetime = NumberRange.new(0.5)
        particleEmitter.Speed = NumberRange.new(5)
        particleEmitter.Parent = effect
        
        TweenService:Create(rootPart, tweenInfo, {
            CFrame = targetCFrame
        }):Play()
        
        wait(1)
        effect:Destroy()
    end
})

-- Hoops System
LegendsSpeedTab:CreateButton({
    Name = "Collect All Hoops",
    Callback = function()
        if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        pcall(function()
            for _, hoop in pairs(workspace.Hoops:GetChildren()) do
                if hoop:IsA("Part") then
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
                    
                    TweenService:Create(effect, TweenInfo.new(0.5), {
                        Size = Vector3.new(5, 5, 5),
                        Transparency = 1
                    }):Play()
                    
                    game:GetService("Debris"):AddItem(effect, 0.5)
                    wait(0.1)
                end
            end
        end)
    end
})

-- Steps and Trails System
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
            antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
            end
        end
    end
})

-- Character respawn handler
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

-- Notification on load
Rayfield:Notify({
    Title = "Legends of Speed",
    Content = "Script loaded successfully!",
    Duration = 3
})

return LegendsSpeedTab
