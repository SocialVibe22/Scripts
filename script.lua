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
    loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/refs/heads/main/LegendsSpeedTab.lua?token=GHSAT0AAAAAAC7PDVNHCQFDOUGSWI55KEGAZ55AXDA'))()

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
