-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Initialize player references
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Ultimate Troll GUI V8",
    LoadingTitle = "Ultimate Troll GUI",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltimateTrollGUI",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/trollgui",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create Build a Boat Tab
local BoatTab = Window:CreateTab("Build a Boat", 4483362458)

-- Auto Build Section
local BuildSection = BoatTab:CreateSection("Auto Build")

-- Load saved builds
local savedBuilds = {}
for _, build in pairs(workspace:GetDescendants()) do
    if build:IsA("Model") and build.Name:match("SavedBuild") then
        table.insert(savedBuilds, build.Name)
    end
end

BoatTab:CreateDropdown({
    Name = "Select Build",
    Options = savedBuilds,
    CurrentOption = savedBuilds[1] or "None",
    Flag = "SelectedBuild",
    Callback = function(Value)
        -- Selected build will be used by auto build
    end
})

local function autoBuild()
    if not getgenv().AutoBuild then return end
    
    pcall(function()
        -- Load selected build
        local args = {
            [1] = "LoadBoat",
            [2] = Rayfield.Flags.SelectedBuild.Value
        }
        ReplicatedStorage.BuildingEvents:FireServer(unpack(args))
        
        -- Place blocks optimally
        for _, block in pairs(workspace.BoatParts:GetChildren()) do
            local args = {
                [1] = "PlaceBlock",
                [2] = block.Name,
                [3] = block.CFrame
            }
            ReplicatedStorage.BuildingEvents:FireServer(unpack(args))
            task.wait(0.1) -- Prevent server overload
        end
    end)
end

BoatTab:CreateToggle({
    Name = "Auto Build",
    CurrentValue = false,
    Flag = "AutoBuild",
    Callback = function(Value)
        getgenv().AutoBuild = Value
        if Value then
            autoBuild()
        end
    end
})

-- Auto Farm Section
local FarmSection = BoatTab:CreateSection("Auto Farm")

local function collectGold()
    for _, gold in pairs(workspace.CollectibleGold:GetChildren()) do
        if gold:IsA("Part") then
            local oldPos = rootPart.CFrame
            rootPart.CFrame = gold.CFrame
            task.wait(0.1)
            rootPart.CFrame = oldPos
        end
    end
end

BoatTab:CreateToggle({
    Name = "Auto Farm Gold",
    CurrentValue = false,
    Flag = "AutoFarmGold",
    Callback = function(Value)
        getgenv().AutoFarmGold = Value
        
        while getgenv().AutoFarmGold do
            pcall(function()
                collectGold()
            end)
            task.wait(0.5)
        end
    end
})

-- Auto Win Section
local WinSection = BoatTab:CreateSection("Auto Win")

local function autoWin()
    if not getgenv().AutoWin then return end
    
    pcall(function()
        -- Teleport to end
        local endPart = workspace.BoatStages:FindFirstChild("EndStage")
        if endPart then
            local targetPos = endPart.Position + Vector3.new(0, 10, 0)
            local tweenInfo = TweenInfo.new(
                5, -- Time
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            
            local tween = TweenService:Create(rootPart, tweenInfo, {
                CFrame = CFrame.new(targetPos)
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

BoatTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Flag = "AutoWin",
    Callback = function(Value)
        getgenv().AutoWin = Value
        if Value then
            autoWin()
        end
    end
})

-- Infinite Blocks Section
local BlocksSection = BoatTab:CreateSection("Infinite Blocks")

BoatTab:CreateToggle({
    Name = "Infinite Blocks",
    CurrentValue = false,
    Flag = "InfiniteBlocks",
    Callback = function(Value)
        if Value then
            -- Hook block placement
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" and self.Name == "BlockLimitCheck" then
                    return true -- Always allow block placement
                end
                
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Speed Build Section
local SpeedSection = BoatTab:CreateSection("Speed Build")

BoatTab:CreateToggle({
    Name = "Speed Build",
    CurrentValue = false,
    Flag = "SpeedBuild",
    Callback = function(Value)
        if Value then
            -- Increase build speed
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" and self.Name == "BuildDelay" then
                    return 0 -- No build delay
                end
                
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Anti Water Section
local WaterSection = BoatTab:CreateSection("Anti Water")

BoatTab:CreateToggle({
    Name = "Anti Water",
    CurrentValue = false,
    Flag = "AntiWater",
    Callback = function(Value)
        if Value then
            -- Make boat float above water
            RunService.Heartbeat:Connect(function()
                if not getgenv().AntiWater then return end
                
                local boat = workspace.Boats:FindFirstChild(player.Name .. "Boat")
                if boat then
                    for _, part in pairs(boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
})

-- Flight Section
local FlightSection = BoatTab:CreateSection("Flight")

BoatTab:CreateToggle({
    Name = "Flight",
    CurrentValue = false,
    Flag = "Flight",
    Callback = function(Value)
        getgenv().Flight = Value
        
        if Value then
            -- Create flight
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlightVelocity"
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            RunService:BindToRenderStep("Flight", 100, function()
                local moveDirection = Vector3.new(
                    UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0),
                    UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0),
                    UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0)
                )
                
                bodyVelocity.Velocity = moveDirection * 50
            end)
        else
            RunService:UnbindFromRenderStep("Flight")
            local bodyVelocity = rootPart:FindFirstChild("FlightVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end
})

-- God Mode Section
local GodSection = BoatTab:CreateSection("God Mode")

BoatTab:CreateToggle({
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
                
                return oldNamecall(self, ...)
            end)
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
})

-- Character respawn handler
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Restore toggles
    if Rayfield.Flags.GodMode.Value then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Notification on load
Rayfield:Notify({
    Title = "Build a Boat",
    Content = "Script loaded successfully!",
    Duration = 3
})
