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

-- Fixed auto build function
local function autoBuild()
    if not getgenv().AutoBuild then return end
    
    pcall(function()
        -- Get boat model
        local boat = workspace.BoatStages.BoatStage:FindFirstChild(player.Name .. "Boat")
        if not boat then return end
        
        -- Place blocks in optimal pattern
        local blockTypes = {"WoodBlock", "MetalBlock", "PlasticBlock"}
        local startPos = boat.PrimaryPart.Position
        
        for x = -2, 2 do
            for z = -2, 2 do
                local blockType = blockTypes[math.random(1, #blockTypes)]
                local pos = startPos + Vector3.new(x * 2, 0, z * 2)
                
                local args = {
                    [1] = blockType,
                    [2] = CFrame.new(pos),
                    [3] = boat
                }
                ReplicatedStorage.PlaceBlock:FireServer(unpack(args))
                task.wait(0.1)
            end
        end
    end)
end

BoatTab:CreateToggle({
    Name = "Auto Build",
    CurrentValue = false,
    Flag = "AutoBuild",
    Callback = function(Value)
        getgenv().AutoBuild = Value
        while getgenv().AutoBuild do
            autoBuild()
            task.wait(1)
        end
    end
})

-- Fixed auto farm gold function
local function collectGold()
    pcall(function()
        for _, gold in pairs(workspace:GetDescendants()) do
            if gold:IsA("Part") and gold.Name == "Gold" then
                local oldPos = rootPart.CFrame
                rootPart.CFrame = gold.CFrame
                task.wait(0.1)
                rootPart.CFrame = oldPos
                
                -- Fire touch interest
                firetouchinterest(rootPart, gold, 0)
                task.wait()
                firetouchinterest(rootPart, gold, 1)
            end
        end
    end)
end

BoatTab:CreateToggle({
    Name = "Auto Farm Gold",
    CurrentValue = false,
    Flag = "AutoFarmGold",
    Callback = function(Value)
        getgenv().AutoFarmGold = Value
        while getgenv().AutoFarmGold do
            collectGold()
            task.wait(0.5)
        end
    end
})

-- Improved auto win function
local function autoWin()
    if not getgenv().AutoWin then return end
    
    pcall(function()
        -- Get end point
        local endPoint = workspace.BoatStages:FindFirstChild("EndStage")
        if not endPoint then return end
        
        -- Get boat
        local boat = workspace.BoatStages.BoatStage:FindFirstChild(player.Name .. "Boat")
        if not boat then return end
        
        -- Smooth teleport to end
        local targetPos = endPoint.Position + Vector3.new(0, 10, 0)
        local tweenInfo = TweenInfo.new(
            5, -- Duration
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        local tween = TweenService:Create(boat.PrimaryPart, tweenInfo, {
            CFrame = CFrame.new(targetPos)
        })
        tween:Play()
        tween.Completed:Wait()
        
        -- Wait for win
        task.wait(1)
        
        -- Return to start
        boat.PrimaryPart.CFrame = workspace.BoatStages.BoatStage.DockLocation.CFrame
    end)
end

BoatTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Flag = "AutoWin",
    Callback = function(Value)
        getgenv().AutoWin = Value
        while getgenv().AutoWin do
            autoWin()
            task.wait(1)
        end
    end
})

-- Fixed infinite blocks
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
                
                if method == "FireServer" and self.Name == "PlaceBlock" then
                    -- Bypass block limit
                    return true
                end
                
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Improved speed build
BoatTab:CreateToggle({
    Name = "Speed Build",
    CurrentValue = false,
    Flag = "SpeedBuild",
    Callback = function(Value)
        if Value then
            -- Remove build delay
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" and self.Name == "PlaceBlock" then
                    -- Remove delay
                    task.wait()
                    return oldNamecall(self, unpack(args))
                end
                
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Enhanced anti water
BoatTab:CreateToggle({
    Name = "Anti Water",
    CurrentValue = false,
    Flag = "AntiWater",
    Callback = function(Value)
        getgenv().AntiWater = Value
        
        if Value then
            RunService.Heartbeat:Connect(function()
                if not getgenv().AntiWater then return end
                
                pcall(function()
                    -- Get boat
                    local boat = workspace.BoatStages.BoatStage:FindFirstChild(player.Name .. "Boat")
                    if not boat then return end
                    
                    -- Make boat float
                    for _, part in pairs(boat:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                            part.CanCollide = true
                            part.Velocity = Vector3.new(0, 5, 0)
                        end
                    end
                end)
            end)
        end
    end
})

-- Improved flight
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

BoatTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if Value then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" and self.Name == "DamageHandler" then
                    return
                end
                
                return oldNamecall(self, ...)
            end)
            
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
    end
})

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if Rayfield.Flags.GodMode.Value then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
end)

player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({
    Title = "Build a Boat",
    Content = "Script loaded successfully!",
    Duration = 3
})
