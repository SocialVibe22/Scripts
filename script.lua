local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Verificar o jogo atual
local placeId = game.PlaceId

-- Criar janela principal
local Window = Rayfield:CreateWindow({
    Name = "MasterHub",
    LoadingTitle = "MasterHub",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MasterHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/masterhub",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "MasterHub Key System",
        Subtitle = "Key Required",
        Note = "Enter key to access MasterHub",
        FileName = "MasterHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"MasterHub2025"}
    }
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- IDs dos jogos
local GAMES = {
    LEGENDS_OF_SPEED = 3101667897,
    NINJA_LEGENDS = 3956818381,
    DOORS = 6516141723,
    BUILD_A_BOAT = 537413528
}

-- Criar a tab do jogo específico
if placeId == GAMES.LEGENDS_OF_SPEED then
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
local function collectOrbsInArea(area)
    local collected = 0
    for _, orb in ipairs(area:GetChildren()) do
        if orb:IsA("Part") and (orb.Name == "Orb" or orb.Name == "outerOrb") then
            ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
            collected = collected + 1
        end
    end
    return collected
end

LegendsSpeedTab:CreateToggle({
    Name = "Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        getgenv().AutoOrbs = Value
        
        while getgenv().AutoOrbs do
            pcall(function()
                local totalCollected = 0
                
                -- Collect from main area
                totalCollected = totalCollected + collectOrbsInArea(workspace.orbFolder)
                
                -- Collect from all worlds
                for _, world in ipairs(workspace:GetChildren()) do
                    if world.Name:match("World") then
                        totalCollected = totalCollected + collectOrbsInArea(world)
                    end
                end
                
                if totalCollected > 0 then
                    Rayfield:Notify({
                        Title = "Orbs Collected",
                        Content = string.format("Collected %d orbs", totalCollected),
                        Duration = 1
                    })
                end
            end)
            task.wait(0.1)
        end
    end
})

-- Enhanced auto rebirth with progress tracking
LegendsSpeedTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        getgenv().AutoRebirth = Value
        local rebirthCount = 0
        
        while getgenv().AutoRebirth do
            pcall(function()
                local before = player.leaderstats.Rebirths.Value
                ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
                local after = player.leaderstats.Rebirths.Value
                
                if after > before then
                    rebirthCount = rebirthCount + 1
                    Rayfield:Notify({
                        Title = "Rebirth Success",
                        Content = string.format("Completed %d rebirths", rebirthCount),
                        Duration = 1
                    })
                end
            end)
            task.wait(0.1)
        end
    end
})

-- Advanced race system with path prediction
local function findOptimalRacePath()
    local races = {}
    for _, race in ipairs(workspace:GetChildren()) do
        if race.Name:find("raceStart") then
            table.insert(races, race)
        end
    end
    
    -- Sort races by distance
    table.sort(races, function(a, b)
        return (a.Position - rootPart.Position).Magnitude < (b.Position - rootPart.Position).Magnitude
    end)
    
    return races[1]
end

LegendsSpeedTab:CreateToggle({
    Name = "Auto Race",
    CurrentValue = false,
    Flag = "AutoRace",
    Callback = function(Value)
        getgenv().AutoRace = Value
        local raceCount = 0
        
        while getgenv().AutoRace do
            pcall(function()
                local bestRace = findOptimalRacePath()
                if bestRace then
                    -- Smooth teleport to race
                    local targetCFrame = bestRace.CFrame * CFrame.new(0, 0, -5)
                    TweenService:Create(rootPart, 
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad), 
                        {CFrame = targetCFrame}
                    ):Play()
                    
                    task.wait(0.5)
                    firetouchinterest(rootPart, bestRace, 0)
                    task.wait()
                    firetouchinterest(rootPart, bestRace, 1)
                    
                    raceCount = raceCount + 1
                    Rayfield:Notify({
                        Title = "Race Completed",
                        Content = string.format("Completed %d races", raceCount),
                        Duration = 1
                    })
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
    Name = "Teleport to World",
    Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
    CurrentOption = "City",
    Flag = "SelectedWorld",
    Callback = function(Value)
        if worlds[Value] then
            -- Smooth teleport with effects
            local targetCFrame = worlds[Value]
            
            -- Create teleport effect
            local effect = Instance.new("Part")
            effect.Size = Vector3.new(1, 1, 1)
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 0.5
            effect.Material = Enum.Material.Neon
            effect.Color = Color3.fromRGB(0, 255, 255)
            effect.CFrame = rootPart.CFrame
            effect.Parent = workspace
            
            -- Animate effect
            TweenService:Create(effect, 
                TweenInfo.new(0.5), 
                {Size = Vector3.new(5, 5, 5), Transparency = 1}
            ):Play()
            
            -- Teleport player
            TweenService:Create(rootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad),
                {CFrame = targetCFrame}
            ):Play()
            
            -- Cleanup effect
            game:GetService("Debris"):AddItem(effect, 0.5)
            
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to " .. Value,
                Duration = 2
            })
        end
    end
})

-- Auto Buy Section
local ShopSection = LegendsSpeedTab:CreateSection("Auto Buy")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Buy All",
    CurrentValue = false,
    Flag = "AutoBuy",
    Callback = function(Value)
        getgenv().AutoBuy = Value
        
        while getgenv().AutoBuy do
            pcall(function()
                -- Buy steps
                ReplicatedStorage.rEvents.stepEvent:FireServer("buyAllSteps")
                
                -- Buy trails
                ReplicatedStorage.rEvents.trailEvent:FireServer("buyAllTrails")
                
                -- Buy pets
                ReplicatedStorage.rEvents.petEvent:FireServer("buyAllPets")
            end)
            task.wait(1)
        end
    end
})

-- Pet System
local PetSection = LegendsSpeedTab:CreateSection("Pet System")

LegendsSpeedTab:CreateToggle({
    Name = "Auto Hatch Best Egg",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(Value)
        getgenv().AutoHatch = Value
        
        while getgenv().AutoHatch do
            pcall(function()
                ReplicatedStorage.rEvents.openCrystalRemote:FireServer("openCrystal", "Best")
            end)
            task.wait(0.5)
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Equip Best Pets",
    CurrentValue = false,
    Flag = "AutoEquip",
    Callback = function(Value)
        getgenv().AutoEquip = Value
        
        while getgenv().AutoEquip do
            pcall(function()
                ReplicatedStorage.rEvents.petEquipEvent:FireServer("equipBest")
            end)
            task.wait(1)
        end
    end
})

elseif placeId == GAMES.DOORS then
    -- Doors Tab
    local DoorsTab = Window:CreateTab("Doors", 4483362458)
    
    -- Entity ESP Section
    local ESPSection = DoorsTab:CreateSection("Entity ESP")

    local function createESP(model, color)
        if not model:IsA("Model") then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = color or Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = model
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP_Info"
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = model.PrimaryPart or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = model.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboardGui
        
        -- Add distance counter
        RunService.RenderStepped:Connect(function()
            if model.PrimaryPart and rootPart then
                local distance = (model.PrimaryPart.Position - rootPart.Position).Magnitude
                nameLabel.Text = string.format("%s\n%.1f studs", model.Name, distance)
            end
        end)
    end

    local function updateESP()
        -- Clear existing ESP
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ESP_Highlight") then
                v.ESP_Highlight:Destroy()
            end
            if v:FindFirstChild("ESP_Info") then
                v.ESP_Info:Destroy()
            end
        end
        
        if not getgenv().EntityESP then return end
        
        -- Add ESP to all entities
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and (
                v.Name:match("Monster") or
                v.Name:match("Rush") or
                v.Name:match("Ambush") or
                v.Name:match("Eyes") or
                v.Name:match("Screech")
            ) then
                createESP(v)
            end
        end
    end

    DoorsTab:CreateToggle({
        Name = "Entity ESP",
        CurrentValue = false,
        Flag = "EntityESP",
        Callback = function(Value)
            getgenv().EntityESP = Value
            updateESP()
        end
    })

    -- Auto Dodge Section
    local DodgeSection = DoorsTab:CreateSection("Auto Dodge")

    local function setupAutoDodge()
        if not getgenv().AutoDodge then return end
        
        workspace.ChildAdded:Connect(function(child)
            if not getgenv().AutoDodge then return end
            
            if child.Name:match("Rush") or child.Name:match("Ambush") then
                -- Hide in nearest closet or behind obstacle
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:match("Closet") or v.Name:match("Wardrobe")) then
                        local primaryPart = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then
                            local distance = (primaryPart.Position - rootPart.Position).Magnitude
                            if distance < 20 then
                                -- Smooth teleport to hiding spot
                                local targetCFrame = primaryPart.CFrame * CFrame.new(0, 0, -3)
                                TweenService:Create(rootPart, 
                                    TweenInfo.new(0.5, Enum.EasingStyle.Quad), 
                                    {CFrame = targetCFrame}
                                ):Play()
                                break
                            end
                        end
                    end
                end
            end
        end)
    end

    DoorsTab:CreateToggle({
        Name = "Auto Dodge",
        CurrentValue = false,
        Flag = "AutoDodge",
        Callback = function(Value)
            getgenv().AutoDodge = Value
            if Value then
                setupAutoDodge()
            end
        end
    })

    -- Item ESP Section
    local ItemSection = DoorsTab:CreateSection("Item ESP")

    local function updateItemESP()
        -- Clear existing ESP
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ItemESP") then
                v.ItemESP:Destroy()
            end
        end
        
        if not getgenv().ItemESP then return end
        
        -- Add ESP to all items
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and (
                v.Name:match("Key") or
                v.Name:match("Flashlight") or
                v.Name:match("Battery") or
                v.Name:match("Crucifix") or
                v.Name:match("Vitamin")
            ) then
                createESP(v, Color3.fromRGB(0, 255, 255))
            end
        end
    end

    DoorsTab:CreateToggle({
        Name = "Item ESP",
        CurrentValue = false,
        Flag = "ItemESP",
        Callback = function(Value)
            getgenv().ItemESP = Value
            updateItemESP()
        end
    })

    -- Anti Screamer Section
    local ScreamerSection = DoorsTab:CreateSection("Anti Screamer")

    DoorsTab:CreateToggle({
        Name = "No Screamer",
        CurrentValue = false,
        Flag = "NoScreamer",
        Callback = function(Value)
            if Value then
                -- Disable screamer effects
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.Brightness = 3
                
                -- Remove screamer sounds
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Sound") and (
                        v.Name:match("Screech") or
                        v.Name:match("Scream") or
                        v.Name:match("Jumpscare")
                    ) then
                        v.Volume = 0
                    end
                end
            end
        end
    })

    -- Auto Revive Section
    local ReviveSection = DoorsTab:CreateSection("Auto Revive")

    DoorsTab:CreateToggle({
        Name = "Auto Revive",
        CurrentValue = false,
        Flag = "AutoRevive",
        Callback = function(Value)
            if Value then
                humanoid.Died:Connect(function()
                    if not getgenv().AutoRevive then return end
                    
                    task.wait(2)
                    -- Revive character
                    local args = {
                        [1] = "Revive"
                    }
                    ReplicatedStorage.EntityInfo:FireServer(unpack(args))
                end)
            end
        end
    })

    -- God Mode Section
    local GodSection = DoorsTab:CreateSection("God Mode")

    DoorsTab:CreateToggle({
        Name = "God Mode",
        CurrentValue = false,
        Flag = "GodMode",
        Callback = function(Value)
            if Value then
                -- Make character invincible
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                
                -- Prevent damage
                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    
                    if method == "FireServer" and self.Name == "DamageHandler" then
                        return
                    end
                    
                    return oldNamecall(self, unpack(args))
                end)
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    })

elseif placeId == GAMES.NINJA_LEGENDS then
    -- Carregar Ninja Legends Tab
    loadstring(game:HttpGet('https://raw.githubusercontent.com/yourrepo/NinjaLegendsTab.lua'))()
    
elseif placeId == GAMES.BUILD_A_BOAT then
    -- Carregar Build a Boat Tab
    loadstring(game:HttpGet('https://raw.githubusercontent.com/yourrepo/BuildABoatTab.lua'))()
else
    -- Notificar que o jogo não é suportado
    Rayfield:Notify({
        Title = "Game Not Supported",
        Content = "This game is not currently supported by MasterHub!",
        Duration = 5
    })
end

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

-- Load configuration
Rayfield:LoadConfiguration()
