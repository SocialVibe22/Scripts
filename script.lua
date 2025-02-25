if getgenv().ScriptLoaded then return end
getgenv().ScriptLoaded = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ Speed Legend X",
    LoadingTitle = "Speed Legend X",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SpeedLegendX",
        FileName = "Config"
    }
})

local MainTab = Window:CreateTab("🌟 Main")
local StatsTab = Window:CreateTab("📊 Stats")

local State = {
    autoOrbs = false,
    autoHoops = false,
    autoRebirth = false,
    lastOrbPosition = nil,
    lastHoopPosition = nil
}

-- Fixed orb collection function
local function collectOrbs()
    if not State.autoOrbs then return end
    
    local oldPos = rootPart.CFrame
    
    -- Collect main orbs
    for _, orb in ipairs(workspace.orbFolder:GetChildren()) do
        if orb:IsA("Part") and State.autoOrbs then
            -- Fixed: Properly touch the orb
            firetouchinterest(rootPart, orb, 0)
            task.wait()
            firetouchinterest(rootPart, orb, 1)
            
            -- Fixed: Send proper collection event
            local args = {
                [1] = "collectOrb",
                [2] = orb
            }
            ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
            
            State.lastOrbPosition = orb.Position
            task.wait(0.1)
        end
    end
    
    -- Collect world orbs
    for _, world in ipairs(workspace:GetChildren()) do
        if world.Name:match("World") then
            for _, orb in ipairs(world:GetDescendants()) do
                if orb:IsA("Part") and orb.Name == "outerOrb" and State.autoOrbs then
                    -- Fixed: Properly touch the orb
                    firetouchinterest(rootPart, orb, 0)
                    task.wait()
                    firetouchinterest(rootPart, orb, 1)
                    
                    -- Fixed: Send proper collection event
                    local args = {
                        [1] = "collectOrb",
                        [2] = orb
                    }
                    ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                    
                    State.lastOrbPosition = orb.Position
                    task.wait(0.1)
                end
            end
        end
    end
    
    rootPart.CFrame = oldPos
end

-- Fixed hoop collection function
local function collectHoops()
    if not State.autoHoops then return end
    
    local oldPos = rootPart.CFrame
    
    for _, hoop in ipairs(workspace.Hoops:GetChildren()) do
        if hoop:IsA("Part") and State.autoHoops then
            -- Fixed: Properly touch the hoop
            firetouchinterest(rootPart, hoop, 0)
            task.wait()
            firetouchinterest(rootPart, hoop, 1)
            
            -- Fixed: Send proper collection event
            local args = {
                [1] = "collectOrb",
                [2] = hoop
            }
            ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
            
            -- Fixed: Add proper delay
            State.lastHoopPosition = hoop.Position
            task.wait(0.1)
        end
    end
    
    rootPart.CFrame = oldPos
end

local function createVisualEffect(position)
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(1, 1, 1)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.5
    effect.Material = Enum.Material.Neon
    effect.Color = Color3.fromHSV(tick() % 1, 1, 1)
    effect.Parent = workspace
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(effect, tweenInfo, {
        Size = Vector3.new(5, 5, 5),
        Transparency = 1
    }):Play()
    
    game:GetService("Debris"):AddItem(effect, 0.5)
end

MainTab:CreateToggle({
    Name = "🔵 Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        State.autoOrbs = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Orbs Enabled",
                Content = "Now collecting orbs automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "🎯 Auto Collect Hoops",
    CurrentValue = false,
    Flag = "AutoHoops", 
    Callback = function(Value)
        State.autoHoops = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Hoops Enabled",
                Content = "Now collecting hoops automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "♻️ Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        State.autoRebirth = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Rebirth Enabled",
                Content = "Now performing rebirths automatically!",
                Duration = 2
            })
        end
    end
})

StatsTab:CreateToggle({
    Name = "📈 Show Live Stats",
    CurrentValue = false,
    Flag = "ShowStats",
    Callback = function(Value)
        if Value then
            RunService.RenderStepped:Connect(function()
                if not Value then return end
                if not player:FindFirstChild("leaderstats") then return end
                
                Rayfield:Notify({
                    Title = "Current Stats",
                    Content = string.format(
                        "Speed: %s\nRebirths: %s\nGems: %s",
                        tostring(player.leaderstats.Speed.Value),
                        tostring(player.leaderstats.Rebirths.Value),
                        tostring(player.leaderstats.Gems.Value)
                    ),
                    Duration = 1
                })
            end)
        end
    end
})

-- Fixed main loop with proper delays
RunService.Heartbeat:Connect(function()
    if State.autoOrbs then
        collectOrbs()
        task.wait(0.1) -- Added delay to prevent overwhelming
    end
    
    if State.autoHoops then
        collectHoops()
        task.wait(0.1) -- Added delay to prevent overwhelming
    end
    
    if State.autoRebirth then
        ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
        task.wait(1) -- Added longer delay for rebirth
    end
    
    if State.lastOrbPosition then
        createVisualEffect(State.lastOrbPosition)
        State.lastOrbPosition = nil
    end
    
    if State.lastHoopPosition then
        createVisualEffect(State.lastHoopPosition)
        State.lastHoopPosition = nil
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

Rayfield:LoadConfiguration()
