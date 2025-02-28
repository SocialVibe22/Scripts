--[[
    Discord-Style Cheat Menu UI Library for Roblox
    
    This library creates a Discord-inspired UI for cheat menus in Roblox games,
    with a sidebar, channels, categories, and a content area for controls.
]]

local DiscordCheatUI = {}
DiscordCheatUI.__index = DiscordCheatUI

-- Constants for styling (Discord colors)
local COLORS = {
    BACKGROUND = Color3.fromRGB(54, 57, 63),      -- Main background
    SIDEBAR = Color3.fromRGB(47, 49, 54),         -- Sidebar background
    CHANNEL_LIST = Color3.fromRGB(47, 49, 54),    -- Channel list background
    CHANNEL = Color3.fromRGB(142, 146, 151),      -- Channel text
    CHANNEL_HOVER = Color3.fromRGB(255, 255, 255),-- Channel hover text
    CATEGORY = Color3.fromRGB(142, 146, 151),     -- Category text
    SELECTED = Color3.fromRGB(255, 255, 255),     -- Selected channel text
    SELECTED_BG = Color3.fromRGB(66, 70, 77),     -- Selected channel background
    TEXT = Color3.fromRGB(255, 255, 255),         -- General text
    BUTTON = Color3.fromRGB(88, 101, 242),        -- Button color (Discord blurple)
    BUTTON_HOVER = Color3.fromRGB(71, 82, 196),   -- Button hover color
    TOGGLE_ON = Color3.fromRGB(67, 181, 129),     -- Toggle switch on
    TOGGLE_OFF = Color3.fromRGB(114, 118, 125),   -- Toggle switch off
    SLIDER_BG = Color3.fromRGB(32, 34, 37),       -- Slider background
    SLIDER_FILL = Color3.fromRGB(88, 101, 242),   -- Slider fill
    INPUT_BG = Color3.fromRGB(64, 68, 75),        -- Input background
    HEADER = Color3.fromRGB(32, 34, 37),          -- Header background
    EMBED = Color3.fromRGB(47, 49, 54),           -- Embed background
    EMBED_ACCENT = Color3.fromRGB(88, 101, 242),  -- Embed accent color
    SERVER_BG = Color3.fromRGB(32, 34, 37),       -- Server icon background
    SERVER_SELECTED = Color3.fromRGB(255, 255, 255), -- Selected server outline
    MEMBER_LIST_BG = Color3.fromRGB(47, 49, 54),  -- Member list background
    MEMBER_HOVER = Color3.fromRGB(66, 70, 77)     -- Member hover background
}

local PADDING = {
    SIDEBAR = UDim2.new(0, 10, 0, 10),
    CATEGORY = UDim2.new(0, 10, 0, 5),
    CHANNEL = UDim2.new(0, 25, 0, 5)
}

local FONT = Enum.Font.SourceSansSemibold
local TEXT_SIZE = {
    CATEGORY = 12,
    CHANNEL = 14,
    HEADER = 16,
    CONTENT = 14
}

-- Icons (using Unicode characters as placeholders)
local ICONS = {
    SETTINGS = "⚙️",
    HASHTAG = "#",
    TOGGLE_ON = "✓",
    TOGGLE_OFF = "✗",
    DROPDOWN = "▼",
    DROPDOWN_OPEN = "▲"
}

-- Create a new Discord-style cheat menu
function DiscordCheatUI.new(player)
    local self = setmetatable({}, DiscordCheatUI)
    
    self.player = player
    self.categories = {}
    self.channels = {}
    self.callbacks = {}
    self.selectedChannel = nil
    self.selectedServer = nil
    self.controls = {}
    self.servers = {}
    self.serverCallbacks = {}
    
    -- Create the main UI
    self:CreateMainUI()
    
    return self
end

-- Create the main UI elements
function DiscordCheatUI:CreateMainUI()
    -- Create ScreenGui
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "DiscordCheatUI"
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Create main frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    self.mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    self.mainFrame.BackgroundColor3 = COLORS.BACKGROUND
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.gui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.mainFrame
    
    -- Add shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993" -- Shadow image
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = self.mainFrame
    
    -- Create server list
    self.serverList = Instance.new("Frame")
    self.serverList.Name = "ServerList"
    self.serverList.Size = UDim2.new(0.06, 0, 1, 0)
    self.serverList.BackgroundColor3 = COLORS.SERVER_BG
    self.serverList.BorderSizePixel = 0
    self.serverList.Parent = self.mainFrame
    
    -- Add corner radius to server list (only left corners)
    local serverListCorner = Instance.new("UICorner")
    serverListCorner.CornerRadius = UDim.new(0, 8)
    serverListCorner.Parent = self.serverList
    
    -- Create a frame to cover the right corners of the server list
    local serverCoverFrame = Instance.new("Frame")
    serverCoverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    serverCoverFrame.Position = UDim2.new(0.5, 0, 0, 0)
    serverCoverFrame.BackgroundColor3 = COLORS.SERVER_BG
    serverCoverFrame.BorderSizePixel = 0
    serverCoverFrame.ZIndex = 2
    serverCoverFrame.Parent = self.serverList
    
    -- Create scrolling frame for servers
    self.serverScrollFrame = Instance.new("ScrollingFrame")
    self.serverScrollFrame.Name = "ServerScrollFrame"
    self.serverScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.serverScrollFrame.BackgroundTransparency = 1
    self.serverScrollFrame.BorderSizePixel = 0
    self.serverScrollFrame.ScrollBarThickness = 0
    self.serverScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as we add servers
    self.serverScrollFrame.Parent = self.serverList
    
    -- Add auto-layout for the server scroll frame
    local serverLayout = Instance.new("UIListLayout")
    serverLayout.SortOrder = Enum.SortOrder.LayoutOrder
    serverLayout.Padding = UDim.new(0, 10)
    serverLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    serverLayout.Parent = self.serverScrollFrame
    
    -- Add padding to the server scroll frame
    local serverPadding = Instance.new("UIPadding")
    serverPadding.PaddingTop = UDim.new(0, 10)
    serverPadding.PaddingBottom = UDim.new(0, 10)
    serverPadding.Parent = self.serverScrollFrame
    
    -- Update canvas size when layout changes
    serverLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.serverScrollFrame.CanvasSize = UDim2.new(0, 0, 0, serverLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Create top bar (server name area in Discord)
    self.topBar = Instance.new("Frame")
    self.topBar.Name = "TopBar"
    self.topBar.Size = UDim2.new(0.2, 0, 0.06, 0)
    self.topBar.Position = UDim2.new(0.06, 0, 0, 0)
    self.topBar.BackgroundColor3 = COLORS.SIDEBAR
    self.topBar.BorderSizePixel = 0
    self.topBar.Parent = self.mainFrame
    
    -- Add top bar title
    self.topBarTitle = Instance.new("TextLabel")
    self.topBarTitle.Name = "Title"
    self.topBarTitle.Size = UDim2.new(1, -20, 1, 0)
    self.topBarTitle.Position = UDim2.new(0, 10, 0, 0)
    self.topBarTitle.BackgroundTransparency = 1
    self.topBarTitle.Font = FONT
    self.topBarTitle.TextSize = TEXT_SIZE.HEADER
    self.topBarTitle.TextColor3 = COLORS.TEXT
    self.topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
    self.topBarTitle.Text = "CHEAT MENU"
    self.topBarTitle.Parent = self.topBar
    
    -- Create sidebar
    self.sidebar = Instance.new("Frame")
    self.sidebar.Name = "Sidebar"
    self.sidebar.Size = UDim2.new(0.2, 0, 0.94, 0)
    self.sidebar.Position = UDim2.new(0.06, 0, 0.06, 0)
    self.sidebar.BackgroundColor3 = COLORS.SIDEBAR
    self.sidebar.BorderSizePixel = 0
    self.sidebar.Parent = self.mainFrame
    
    -- Create scrolling frame for channels and categories
    self.scrollFrame = Instance.new("ScrollingFrame")
    self.scrollFrame.Name = "ChannelList"
    self.scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.scrollFrame.BackgroundTransparency = 1
    self.scrollFrame.BorderSizePixel = 0
    self.scrollFrame.ScrollBarThickness = 4
    self.scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 83, 90)
    self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as we add items
    self.scrollFrame.Parent = self.sidebar
    
    -- Create channel header
    self.channelHeader = Instance.new("Frame")
    self.channelHeader.Name = "ChannelHeader"
    self.channelHeader.Size = UDim2.new(0.54, 0, 0.06, 0)
    self.channelHeader.Position = UDim2.new(0.26, 0, 0, 0)
    self.channelHeader.BackgroundColor3 = COLORS.HEADER
    self.channelHeader.BorderSizePixel = 0
    self.channelHeader.Parent = self.mainFrame
    
    -- Add separator line
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, 0)
    separator.BackgroundColor3 = Color3.fromRGB(60, 63, 69)
    separator.BorderSizePixel = 0
    separator.Parent = self.channelHeader
    
    -- Create channel name label
    self.channelNameLabel = Instance.new("TextLabel")
    self.channelNameLabel.Name = "ChannelName"
    self.channelNameLabel.Size = UDim2.new(1, -20, 1, 0)
    self.channelNameLabel.Position = UDim2.new(0, 10, 0, 0)
    self.channelNameLabel.BackgroundTransparency = 1
    self.channelNameLabel.Font = FONT
    self.channelNameLabel.TextSize = TEXT_SIZE.HEADER
    self.channelNameLabel.TextColor3 = COLORS.TEXT
    self.channelNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.channelNameLabel.Text = "Select a channel"
    self.channelNameLabel.Parent = self.channelHeader
    
    -- Create content frame
    self.content = Instance.new("ScrollingFrame")
    self.content.Name = "Content"
    self.content.Size = UDim2.new(0.54, 0, 0.94, 0)
    self.content.Position = UDim2.new(0.26, 0, 0.06, 0)
    self.content.BackgroundColor3 = COLORS.BACKGROUND
    self.content.BorderSizePixel = 0
    self.content.ScrollBarThickness = 4
    self.content.ScrollBarImageColor3 = Color3.fromRGB(80, 83, 90)
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.Parent = self.mainFrame
    
    -- Create member list
    self.memberList = Instance.new("Frame")
    self.memberList.Name = "MemberList"
    self.memberList.Size = UDim2.new(0.2, 0, 1, 0)
    self.memberList.Position = UDim2.new(0.8, 0, 0, 0)
    self.memberList.BackgroundColor3 = COLORS.MEMBER_LIST_BG
    self.memberList.BorderSizePixel = 0
    self.memberList.Parent = self.mainFrame
    
    -- Add corner radius to member list (only right corners)
    local memberListCorner = Instance.new("UICorner")
    memberListCorner.CornerRadius = UDim.new(0, 8)
    memberListCorner.Parent = self.memberList
    
    -- Create a frame to cover the left corners of the member list
    local memberCoverFrame = Instance.new("Frame")
    memberCoverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    memberCoverFrame.Position = UDim2.new(0, 0, 0, 0)
    memberCoverFrame.BackgroundColor3 = COLORS.MEMBER_LIST_BG
    memberCoverFrame.BorderSizePixel = 0
    memberCoverFrame.ZIndex = 2
    memberCoverFrame.Parent = self.memberList
    
    -- Create member list header
    local memberListHeader = Instance.new("TextLabel")
    memberListHeader.Name = "MemberListHeader"
    memberListHeader.Size = UDim2.new(1, 0, 0.06, 0)
    memberListHeader.BackgroundColor3 = COLORS.MEMBER_LIST_BG
    memberListHeader.BorderSizePixel = 0
    memberListHeader.Font = FONT
    memberListHeader.TextSize = TEXT_SIZE.CATEGORY
    memberListHeader.TextColor3 = COLORS.CATEGORY
    memberListHeader.Text = "MEMBERS"
    memberListHeader.TextXAlignment = Enum.TextXAlignment.Left
    memberListHeader.Parent = self.memberList
    
    -- Add padding to the member list header
    local memberHeaderPadding = Instance.new("UIPadding")
    memberHeaderPadding.PaddingLeft = UDim.new(0, 10)
    memberHeaderPadding.Parent = memberListHeader
    
    -- Create scrolling frame for members
    self.memberScrollFrame = Instance.new("ScrollingFrame")
    self.memberScrollFrame.Name = "MemberScrollFrame"
    self.memberScrollFrame.Size = UDim2.new(1, 0, 0.94, 0)
    self.memberScrollFrame.Position = UDim2.new(0, 0, 0.06, 0)
    self.memberScrollFrame.BackgroundTransparency = 1
    self.memberScrollFrame.BorderSizePixel = 0
    self.memberScrollFrame.ScrollBarThickness = 4
    self.memberScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 83, 90)
    self.memberScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.memberScrollFrame.Parent = self.memberList
    
    -- Add auto-layout for the member scroll frame
    local memberLayout = Instance.new("UIListLayout")
    memberLayout.SortOrder = Enum.SortOrder.LayoutOrder
    memberLayout.Padding = UDim.new(0, 5)
    memberLayout.Parent = self.memberScrollFrame
    
    -- Add padding to the member scroll frame
    local memberPadding = Instance.new("UIPadding")
    memberPadding.PaddingTop = UDim.new(0, 10)
    memberPadding.PaddingBottom = UDim.new(0, 10)
    memberPadding.PaddingLeft = UDim.new(0, 10)
    memberPadding.PaddingRight = UDim.new(0, 10)
    memberPadding.Parent = self.memberScrollFrame
    
    -- Update canvas size when layout changes
    memberLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.memberScrollFrame.CanvasSize = UDim2.new(0, 0, 0, memberLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Create welcome message
    self.welcomeMessage = Instance.new("TextLabel")
    self.welcomeMessage.Name = "WelcomeMessage"
    self.welcomeMessage.Size = UDim2.new(1, -40, 0, 100)
    self.welcomeMessage.Position = UDim2.new(0, 20, 0, 20)
    self.welcomeMessage.BackgroundTransparency = 1
    self.welcomeMessage.Font = FONT
    self.welcomeMessage.TextSize = 16
    self.welcomeMessage.TextColor3 = COLORS.CHANNEL
    self.welcomeMessage.TextWrapped = true
    self.welcomeMessage.Text = "Welcome to the Discord-style cheat menu! Select a channel from the sidebar to access different cheat options."
    self.welcomeMessage.Parent = self.content
    
    -- Add auto-layout for the scroll frame
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.scrollFrame
    
    -- Add padding to the scroll frame
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = self.scrollFrame
    
    -- Add auto-layout for the content frame
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = self.content
    
    -- Add padding to the content frame
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 20)
    contentPadding.PaddingBottom = UDim.new(0, 20)
    contentPadding.PaddingLeft = UDim.new(0, 20)
    contentPadding.PaddingRight = UDim.new(0, 20)
    contentPadding.Parent = self.content
    
    -- Update canvas size when layout changes
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    -- Populate member list
    self:UpdateMemberList()
    
    -- Make the UI draggable
    self:MakeDraggable(self.mainFrame, self.topBar)
    self:MakeDraggable(self.mainFrame, self.channelHeader)
end

-- Update the member list with all players in the game
function DiscordCheatUI:UpdateMemberList()
    -- Clear existing members
    for _, child in pairs(self.memberScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add all players
    local players = game:GetService("Players"):GetPlayers()
    for i, player in ipairs(players) do
        local memberFrame = Instance.new("Frame")
        memberFrame.Name = "Member_" .. player.Name
        memberFrame.Size = UDim2.new(1, 0, 0, 40)
        memberFrame.BackgroundTransparency = 1
        memberFrame.LayoutOrder = i
        
        local memberAvatar = Instance.new("ImageLabel")
        memberAvatar.Name = "Avatar"
        memberAvatar.Size = UDim2.new(0, 30, 0, 30)
        memberAvatar.Position = UDim2.new(0, 0, 0, 5)
        memberAvatar.BackgroundColor3 = COLORS.BACKGROUND
        memberAvatar.BorderSizePixel = 0
        
        -- Add corner radius to avatar
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = memberAvatar
        
        -- Try to load player avatar
        local success, _ = pcall(function()
            memberAvatar.Image = game:GetService("Players"):GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size48x48
            )
        end)
        
        if not success then
            memberAvatar.BackgroundColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
        end
        
        memberAvatar.Parent = memberFrame
        
        local memberName = Instance.new("TextLabel")
        memberName.Name = "Name"
        memberName.Size = UDim2.new(1, -40, 1, 0)
        memberName.Position = UDim2.new(0, 40, 0, 0)
        memberName.BackgroundTransparency = 1
        memberName.Font = FONT
        memberName.TextSize = TEXT_SIZE.CONTENT
        memberName.TextColor3 = COLORS.TEXT
        memberName.TextXAlignment = Enum.TextXAlignment.Left
        memberName.Text = player.Name
        memberName.Parent = memberFrame
        
        -- Add hover effect
        memberFrame.MouseEnter:Connect(function()
            memberFrame.BackgroundTransparency = 0
            memberFrame.BackgroundColor3 = COLORS.MEMBER_HOVER
        end)
        
        memberFrame.MouseLeave:Connect(function()
            memberFrame.BackgroundTransparency = 1
        end)
        
        memberFrame.Parent = self.memberScrollFrame
    end
end

-- Make a UI element draggable
function DiscordCheatUI:MakeDraggable(frame, dragArea)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Add a server to the menu
function DiscordCheatUI:AddServer(name, shortName, callback)
    local layoutOrder = #self.servers + 1
    
    -- Create server button
    local serverButton = Instance.new("TextButton")
    serverButton.Name = "Server_" .. name
    serverButton.Size = UDim2.new(0, 48, 0, 48)
    serverButton.BackgroundColor3 = COLORS.SIDEBAR
    serverButton.BorderSizePixel = 0
    serverButton.Text = shortName or string.sub(name, 1, 1)
    serverButton.Font = FONT
    serverButton.TextSize = 18
    serverButton.TextColor3 = COLORS.TEXT
    serverButton.LayoutOrder = layoutOrder
    
    -- Add corner radius
    local serverCorner = Instance.new("UICorner")
    serverCorner.CornerRadius = UDim.new(1, 0)
    serverCorner.Parent = serverButton
    
    -- Add selection indicator
    local selectionIndicator = Instance.new("Frame")
    selectionIndicator.Name = "SelectionIndicator"
    selectionIndicator.Size = UDim2.new(0, 4, 0, 40)
    selectionIndicator.Position = UDim2.new(0, -10, 0.5, -20)
    selectionIndicator.BackgroundColor3 = COLORS.SERVER_SELECTED
    selectionIndicator.BorderSizePixel = 0
    selectionIndicator.Visible = false
    
    -- Add corner radius to selection indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = selectionIndicator
    
    selectionIndicator.Parent = serverButton
    
    -- Add hover effect
    serverButton.MouseEnter:Connect(function()
        if self.selectedServer ~= name then
            serverButton.BackgroundColor3 = COLORS.CHANNEL_HOVER
        end
    end)
    
    serverButton.MouseLeave:Connect(function()
        if self.selectedServer ~= name then
            serverButton.BackgroundColor3 = COLORS.SIDEBAR
        end
    end)
    
    -- Add click event
    serverButton.MouseButton1Click:Connect(function()
        self:SelectServer(name)
        if callback then
            callback()
        end
    end)
    
    serverButton.Parent = self.serverScrollFrame
    
    table.insert(self.servers, {
        name = name,
        instance = serverButton,
        indicator = selectionIndicator,
        layoutOrder = layoutOrder
    })
    
    self.serverCallbacks[name] = callback
    
    return self
end

-- Select a server
function DiscordCheatUI:SelectServer(name)
    -- Reset previous selection
    if self.selectedServer then
        local prevServer = self:FindServerByName(self.selectedServer)
        if prevServer and prevServer.instance then
            prevServer.instance.BackgroundColor3 = COLORS.SIDEBAR
            prevServer.indicator.Visible = false
        end
    end
    
    -- Set new selection
    self.selectedServer = name
    local server = self:FindServerByName(name)
    if server and server.instance then
        server.instance.BackgroundColor3 = COLORS.BUTTON
        server.indicator.Visible = true
    end
    
    -- Update top bar title
    self.topBarTitle.Text = name
    
    -- Clear channels
    for _, child in pairs(self.scrollFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    self.categories = {}
    self.channels = {}
    
    -- Clear content
    for _, control in pairs(self.controls) do
        if control.instance then
            control.instance:Destroy()
        end
    end
    self.controls = {}
    
    -- Reset selected channel
    self.selectedChannel = nil
    self.channelNameLabel.Text = "Select a channel"
    self.welcomeMessage.Visible = true
    
    -- Call server callback to set up channels
    local callback = self.serverCallbacks[name]
    if callback then
        callback()
    end
    
    return self
end

-- Find a server by name
function DiscordCheatUI:FindServerByName(name)
    for _, server in ipairs(self.servers) do
        if server.name == name then
            return server
        end
    end
    return nil
end

-- Add a category to the menu
function DiscordCheatUI:AddCategory(name)
    local layoutOrder = #self.categories + #self.channels + 1
    
    -- Create category label
    local category = Instance.new("TextLabel")
    category.Name = "Category_" .. name
    category.Size = UDim2.new(1, -10, 0, 25)
    category.BackgroundTransparency = 1
    category.Font = FONT
    category.TextSize = TEXT_SIZE.CATEGORY
    category.TextColor3 = COLORS.CATEGORY
    category.TextXAlignment = Enum.TextXAlignment.Left
    category.Text = string.upper(name)
    category.LayoutOrder = layoutOrder
    category.Parent = self.scrollFrame
    
    table.insert(self.categories, {
        name = name,
        instance = category,
        layoutOrder = layoutOrder
    })
    
    return self
end

-- Add a channel to the menu
function DiscordCheatUI:AddChannel(name, callback)
    local layoutOrder = #self.categories + #self.channels + 1
    
    -- Create channel button container
    local channelContainer = Instance.new("Frame")
    channelContainer.Name = "ChannelContainer_" .. name
    channelContainer.Size = UDim2.new(1, -10, 0, 30)
    channelContainer.BackgroundTransparency = 1
    channelContainer.LayoutOrder = layoutOrder
    channelContainer.Parent = self.scrollFrame
    
    -- Create channel button
    local channel = Instance.new("TextButton")
    channel.Name = "Channel_" .. name
    channel.Size = UDim2.new(1, 0, 1, 0)
    channel.BackgroundTransparency = 1
    channel.Font = FONT
    channel.TextSize = TEXT_SIZE.CHANNEL
    channel.TextColor3 = COLORS.CHANNEL
    channel.TextXAlignment = Enum.TextXAlignment.Left
    channel.Text = "# " .. name
    channel.Parent = channelContainer
    
    -- Create selection indicator
    local selectionIndicator = Instance.new("Frame")
    selectionIndicator.Name = "SelectionIndicator"
    selectionIndicator.Size = UDim2.new(1, 0, 1, 0)
    selectionIndicator.BackgroundColor3 = COLORS.SELECTED_BG
    selectionIndicator.BorderSizePixel = 0
    selectionIndicator.ZIndex = 0
    selectionIndicator.Visible = false
    
    -- Add corner radius to selection indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 4)
    indicatorCorner.Parent = selectionIndicator
    
    selectionIndicator.Parent = channelContainer
    
    -- Add hover effect
    channel.MouseEnter:Connect(function()
        if self.selectedChannel ~= name then
            channel.TextColor3 = COLORS.CHANNEL_HOVER
        end
    end)
    
    channel.MouseLeave:Connect(function()
        if self.selectedChannel ~= name then
            channel.TextColor3 = COLORS.CHANNEL
        end
    end)
    
    -- Add click event
    channel.MouseButton1Click:Connect(function()
        self:SelectChannel(name)
        if callback then
            callback()
        end
    end)
    
    table.insert(self.channels, {
        name = name,
        instance = channel,
        container = channelContainer,
        indicator = selectionIndicator,
        layoutOrder = layoutOrder
    })
    
    self.callbacks[name] = callback
    
    return self
end

-- Select a channel
function DiscordCheatUI:SelectChannel(name)
    -- Reset previous selection
    if self.selectedChannel then
        local prevChannel = self:FindChannelByName(self.selectedChannel)
        if prevChannel and prevChannel.instance then
            prevChannel.instance.TextColor3 = COLORS.CHANNEL
            prevChannel.indicator.Visible = false
        end
    end
    
    -- Set new selection
    self.selectedChannel = name
    local channel = self:FindChannelByName(name)
    if channel and channel.instance then
        channel.instance.TextColor3 = COLORS.SELECTED
        channel.indicator.Visible = true
    end
    
    -- Update header
    self.channelNameLabel.Text = "# " .. name
    
    -- Hide welcome message
    self.welcomeMessage.Visible = false
    
    -- Clear previous content
    for _, control in pairs(self.controls) do
        if control.instance then
            control.instance:Destroy()
        end
    end
    self.controls = {}
    
    return self
end

-- Find a channel by name
function DiscordCheatUI:FindChannelByName(name)
    for _, channel in ipairs(self.channels) do
        if channel.name == name then
            return channel
        end
    end
    return nil
end

-- Add a button control
function DiscordCheatUI:AddButton(text, callback)
    if not self.selectedChannel then return self end
    
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = COLORS.BUTTON
    button.BorderSizePixel = 0
    button.Font = FONT
    button.TextSize = TEXT_SIZE.CONTENT
    button.TextColor3 = COLORS.TEXT
    button.Text = text
    button.LayoutOrder = #self.controls + 1
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    -- Add hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = COLORS.BUTTON_HOVER
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = COLORS.BUTTON
    end)
    
    -- Add click event
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    button.Parent = self.content
    
    table.insert(self.controls, {
        type = "button",
        instance = button
    })
    
    return self
end

-- Add a toggle control
function DiscordCheatUI:AddToggle(text, initialState, callback)
    if not self.selectedChannel then return self end
    
    initialState = initialState or false
    
    local container = Instance.new("Frame")
    container.Name = "ToggleContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "ToggleBackground"
    toggleBackground.Size = UDim2.new(0, 40, 0, 20)
    toggleBackground.Position = UDim2.new(0.85, 0, 0.5, -10)
    toggleBackground.BackgroundColor3 = initialState and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF
    toggleBackground.BorderSizePixel = 0
    
    -- Add corner radius
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBackground
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "ToggleIndicator"
    toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    toggleIndicator.Position = UDim2.new(initialState and 0.6 or 0, 2, 0, 2)
    toggleIndicator.BackgroundColor3 = COLORS.TEXT
    toggleIndicator.BorderSizePixel = 0
    
    -- Add corner radius
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = toggleIndicator
    
    toggleIndicator.Parent = toggleBackground
    toggleBackground.Parent = container
    
    -- Make the toggle clickable
    toggleBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            initialState = not initialState
            toggleBackground.BackgroundColor3 = initialState and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF
            toggleIndicator:TweenPosition(
                UDim2.new(initialState and 0.6 or 0, 2, 0, 2),
                Enum.EasingDirection.InOut,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            if callback then
                callback(initialState)
            end
        end
    end)
    
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "toggle",
        instance = container,
        state = initialState
    })
    
    return self
end

-- Add a slider control
function DiscordCheatUI:AddSlider(text, min, max, initialValue, callback)
    if not self.selectedChannel then return self end
    
    min = min or 0
    max = max or 100
    initialValue = initialValue or min
    initialValue = math.clamp(initialValue, min, max)
    
    local container = Instance.new("Frame")
    container.Name = "SliderContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = FONT
    valueLabel.TextSize = TEXT_SIZE.CONTENT
    valueLabel.TextColor3 = COLORS.TEXT
    valueLabel.Text = tostring(initialValue)
    valueLabel.Parent = container
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(1, 0, 0, 10)
    sliderBackground.Position = UDim2.new(0, 0, 0, 30)
    sliderBackground.BackgroundColor3 = COLORS.SLIDER_BG
    sliderBackground.BorderSizePixel = 0
    
    -- Add corner radius
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 5)
    bgCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((initialValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.SLIDER_FILL
    sliderFill.BorderSizePixel = 0
    
    -- Add corner radius
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = sliderFill
    
    sliderFill.Parent = sliderBackground
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((initialValue - min) / (max - min), -10, 0, -5)
    sliderButton.BackgroundColor3 = COLORS.TEXT
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    
    -- Add corner radius
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    sliderButton.Parent = sliderBackground
    sliderBackground.Parent = container
    
    -- Make the slider draggable
    local dragging = false
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            
            local mousePos = input.Position.X
            local sliderPos = sliderBackground.AbsolutePosition.X
            local sliderSize = sliderBackground.AbsoluteSize.X
            
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = min + relativePos * (max - min)
            value = math.floor(value + 0.5) -- Round to nearest integer
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativePos, -10, 0, -5)
            valueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBackground.AbsolutePosition.X
            local sliderSize = sliderBackground.AbsoluteSize.X
            
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = min + relativePos * (max - min)
            value = math.floor(value + 0.5) -- Round to nearest integer
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativePos, -10, 0, -5)
            valueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    container.Parent = self.content
    
    table.insert(self. controls, {
        type = "slider",
        instance = container,
        value = initialValue
    })
    
    return self
end

-- Add a dropdown control
function DiscordCheatUI:AddDropdown(text, options, initialSelection, callback)
    if not self.selectedChannel then return self end
    
    options = options or {}
    initialSelection = initialSelection or (options[1] or "")
    
    local container = Instance.new("Frame")
    container.Name = "DropdownContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0.6, 0, 1, 0)
    dropdownButton.Position = UDim2.new(0.4, 0, 0, 0)
    dropdownButton.BackgroundColor3 = COLORS.INPUT_BG
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Font = FONT
    dropdownButton.TextSize = TEXT_SIZE.CONTENT
    dropdownButton.TextColor3 = COLORS.TEXT
    dropdownButton.Text = initialSelection .. " " .. ICONS.DROPDOWN
    
    -- Add corner radius
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = dropdownButton
    
    dropdownButton.Parent = container
    
    -- Create dropdown menu
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "DropdownMenu"
    dropdownMenu.Size = UDim2.new(0.6, 0, 0, #options * 30)
    dropdownMenu.Position = UDim2.new(0.4, 0, 1, 5)
    dropdownMenu.BackgroundColor3 = COLORS.INPUT_BG
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 10
    
    -- Add corner radius
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 4)
    menuCorner.Parent = dropdownMenu
    
    -- Add options
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optionButton.BackgroundTransparency = 1
        optionButton.Font = FONT
        optionButton.TextSize = TEXT_SIZE.CONTENT
        optionButton.TextColor3 = COLORS.TEXT
        optionButton.Text = option
        optionButton.ZIndex = 10
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundTransparency = 0.8
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundTransparency = 1
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option .. " " .. ICONS.DROPDOWN
            dropdownMenu.Visible = false
            
            if callback then
                callback(option)
            end
        end)
        
        optionButton.Parent = dropdownMenu
    end
    
    dropdownMenu.Parent = container
    
    -- Toggle dropdown menu
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownMenu.Visible = not dropdownMenu.Visible
        dropdownButton.Text = initialSelection .. " " .. (dropdownMenu.Visible and ICONS.DROPDOWN_OPEN or ICONS.DROPDOWN)
    end)
    
    -- Close dropdown when clicking elsewhere
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local dropdownPos = dropdownMenu.AbsolutePosition
            local dropdownSize = dropdownMenu.AbsoluteSize
            
            if dropdownMenu.Visible and (
                mousePos.X < dropdownPos.X or
                mousePos.Y < dropdownPos.Y or
                mousePos.X > dropdownPos.X + dropdownSize.X or
                mousePos.Y > dropdownPos.Y + dropdownSize.Y
            ) and (
                mousePos.X < dropdownButton.AbsolutePosition.X or
                mousePos.Y < dropdownButton.AbsolutePosition.Y or
                mousePos.X > dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X or
                mousePos.Y > dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y
            ) then
                dropdownMenu.Visible = false
                dropdownButton.Text = initialSelection .. " " .. ICONS.DROPDOWN
            end
        end
    end)
    
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "dropdown",
        instance = container,
        selection = initialSelection
    })
    
    return self
end

-- Add a text input control
function DiscordCheatUI:AddTextInput(text, placeholder, initialValue, callback)
    if not self.selectedChannel then return self end
    
    placeholder = placeholder or "Enter text..."
    initialValue = initialValue or ""
    
    local container = Instance.new("Frame")
    container.Name = "InputContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(0.6, 0, 1, 0)
    inputBox.Position = UDim2.new(0.4, 0, 0, 0)
    inputBox.BackgroundColor3 = COLORS.INPUT_BG
    inputBox.BorderSizePixel = 0
    inputBox.Font = FONT
    inputBox.TextSize = TEXT_SIZE.CONTENT
    inputBox.TextColor3 = COLORS.TEXT
    inputBox.PlaceholderText = placeholder
    inputBox.Text = initialValue
    inputBox.ClearTextOnFocus = false
    
    -- Add corner radius
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    -- Add padding
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.PaddingRight = UDim.new(0, 10)
    inputPadding.Parent = inputBox
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(inputBox.Text, enterPressed)
        end
    end)
    
    inputBox.Parent = container
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "textInput",
        instance = container,
        value = initialValue
    })
    
    return self
end

-- Add a section header
function DiscordCheatUI:AddSectionTitle(text)
    if not self.selectedChannel then return self end
    
    local title = Instance.new("TextLabel")
    title.Name = "SectionTitle_" .. text
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = FONT
    title.TextSize = TEXT_SIZE.HEADER
    title.TextColor3 = COLORS.TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text
    title.LayoutOrder = #self.controls + 1
    
    -- Add separator line
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, -1)
    separator.BackgroundColor3 = Color3.fromRGB(60, 63, 69)
    separator.BorderSizePixel = 0
    separator.Parent = title
    
    title.Parent = self.content
    
    table.insert(self.controls, {
        type = "sectionTitle",
        instance = title
    })
    
    return self
end

-- Add an embed (Discord-style message embed)
function DiscordCheatUI:AddEmbed(title, description, color, fields)
    if not self.selectedChannel then return self end
    
    color = color or COLORS.EMBED_ACCENT
    fields = fields or {}
    
    local embed = Instance.new("Frame")
    embed.Name = "Embed_" .. title
    embed.Size = UDim2.new(1, 0, 0, 100 + (#fields * 30))
    embed.BackgroundColor3 = COLORS.EMBED
    embed.BorderSizePixel = 0
    embed.LayoutOrder = #self.controls + 1
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = embed
    
    -- Add accent bar
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = color
    accent.BorderSizePixel = 0
    
    -- Add corner radius to accent
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 4)
    accentCorner.Parent = accent
    
    accent.Parent = embed
    
    -- Add title
    local embedTitle = Instance.new("TextLabel")
    embedTitle.Name = "Title"
    embedTitle.Size = UDim2.new(1, -20, 0, 30)
    embedTitle.Position = UDim2.new(0, 10, 0, 10)
    embedTitle.BackgroundTransparency = 1
    embedTitle.Font = FONT
    embedTitle.TextSize = TEXT_SIZE.HEADER
    embedTitle.TextColor3 = COLORS.TEXT
    embedTitle.TextXAlignment = Enum.TextXAlignment.Left
    embedTitle.Text = title
    embedTitle.Parent = embed
    
    -- Add description
    local embedDescription = Instance.new("TextLabel")
    embedDescription.Name = "Description"
    embedDescription.Size = UDim2.new(1, -20, 0, 40)
    embedDescription.Position = UDim2.new(0, 10, 0, 40)
    embedDescription.BackgroundTransparency = 1
    embedDescription.Font = FONT
    embedDescription.TextSize = TEXT_SIZE.CONTENT
    embedDescription.TextColor3 = COLORS.TEXT
    embedDescription.TextXAlignment = Enum.TextXAlignment.Left
    embedDescription.TextWrapped = true
    embedDescription.Text = description
    embedDescription.Parent = embed
    
    -- Add fields
    for i, field in ipairs(fields) do
        local fieldName = Instance.new("TextLabel")
        fieldName.Name = "FieldName_" .. i
        fieldName.Size = UDim2.new(0.3, 0, 0, 20)
        fieldName.Position = UDim2.new(0, 10, 0, 80 + ((i-1) * 30))
        fieldName.BackgroundTransparency = 1
        fieldName.Font = FONT
        fieldName.TextSize = TEXT_SIZE.CONTENT
        fieldName.TextColor3 = COLORS.TEXT
        fieldName.TextXAlignment = Enum.TextXAlignment.Left
        fieldName.Text = field.name
        fieldName.Parent = embed
        
        local fieldValue = Instance.new("TextLabel")
        fieldValue.Name = "FieldValue_" .. i
        fieldValue.Size = UDim2.new(0.7, -20, 0, 20)
        fieldValue.Position = UDim2.new(0.3, 0, 0, 80 + ((i-1) * 30))
        fieldValue.BackgroundTransparency = 1
        fieldValue.Font = FONT
        fieldValue.TextSize = TEXT_SIZE.CONTENT
        fieldValue.TextColor3 = COLORS.TEXT
        fieldValue.TextXAlignment = Enum.TextXAlignment.Left
        fieldValue.Text = field.value
        fieldValue.Parent = embed
    end
    
    embed.Parent = self.content
    
    table.insert(self.controls, {
        type = "embed",
        instance = embed
    })
    
    return self
end

-- Add a keybind control
function DiscordCheatUI:AddKeybind(text, defaultKey, callback)
    if not self.selectedChannel then return self end
    
    defaultKey = defaultKey or "E"
    
    local container = Instance.new("Frame")
    container.Name = "KeybindContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local keyButton = Instance.new("TextButton")
    keyButton.Name = "KeyButton"
    keyButton.Size = UDim2.new(0.3, 0, 0.8, 0)
    keyButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    keyButton.BackgroundColor3 = COLORS.INPUT_BG
    keyButton.BorderSizePixel = 0
    keyButton.Font = FONT
    keyButton.TextSize = TEXT_SIZE.CONTENT
    keyButton.TextColor3 = COLORS.TEXT
    keyButton.Text = defaultKey
    
    -- Add corner radius
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = keyButton
    
    keyButton.Parent = container
    
    local listening = false
    
    keyButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        keyButton.Text = "..."
        
        local connection
        connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = string.sub(tostring(input.KeyCode), 14)
                keyButton.Text = keyName
                listening = false
                connection:Disconnect()
                
                if callback then
                    callback(input.KeyCode)
                end
            end
        end)
    end)
    
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "keybind",
        instance = container,
        key = defaultKey
    })
    
    return self
end

-- Add a color picker control
function DiscordCheatUI:AddColorPicker(text, defaultColor, callback)
    if not self.selectedChannel then return self end
    
    defaultColor = defaultColor or Color3.fromRGB(255, 0, 0)
    
    local container = Instance.new("Frame")
    container.Name = "ColorPickerContainer_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.controls + 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = container
    
    local colorButton = Instance.new("TextButton")
    colorButton.Name = "ColorButton"
    colorButton.Size = UDim2.new(0.3, 0, 0.8, 0)
    colorButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    colorButton.BackgroundColor3 = defaultColor
    colorButton.BorderSizePixel = 0
    colorButton.Text = ""
    
    -- Add corner radius
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorButton
    
    colorButton.Parent = container
    
    -- Create color picker popup
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = "ColorPicker"
    colorPicker.Size = UDim2.new(0.8, 0, 0, 200)
    colorPicker.Position = UDim2.new(0.1, 0, 1, 10)
    colorPicker.BackgroundColor3 = COLORS.EMBED
    colorPicker.BorderSizePixel = 0
    colorPicker.Visible = false
    colorPicker.ZIndex = 10
    
    -- Add corner radius
    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 4)
    pickerCorner.Parent = colorPicker
    
    -- Add color sliders (simplified for this example)
    local redSlider = Instance.new("Frame")
    redSlider.Name = "RedSlider"
    redSlider.Size = UDim2.new(0.9, 0, 0, 20)
    redSlider.Position = UDim2.new(0.05, 0, 0, 20)
    redSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    redSlider.BorderSizePixel = 0
    redSlider.ZIndex = 11
    
    -- Add corner radius
    local redCorner = Instance.new("UICorner")
    redCorner.CornerRadius = UDim.new(0, 4)
    redCorner.Parent = redSlider
    
    redSlider.Parent = colorPicker
    
    local greenSlider = Instance.new("Frame")
    greenSlider.Name = "GreenSlider"
    greenSlider.Size = UDim2.new(0.9, 0, 0, 20)
    greenSlider.Position = UDim2.new(0.05, 0, 0, 60)
    greenSlider.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    greenSlider.BorderSizePixel = 0
    greenSlider.ZIndex = 11
    
    -- Add corner radius
    local greenCorner = Instance.new("UICorner")
    greenCorner.CornerRadius = UDim.new(0, 4)
    greenCorner.Parent = greenSlider
    
    greenSlider.Parent = colorPicker
    
    local blueSlider = Instance.new("Frame")
    blueSlider.Name = "BlueSlider"
    blueSlider.Size = UDim2.new(0.9, 0, 0, 20)
    blueSlider.Position = UDim2.new(0.05, 0, 0, 100)
    blueSlider.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    blueSlider.BorderSizePixel = 0
    blueSlider.ZIndex = 11
    
    -- Add corner radius
    local blueCorner = Instance.new("UICorner")
    blueCorner.CornerRadius = UDim.new(0, 4)
    blueCorner.Parent = blueSlider
    
    blueSlider.Parent = colorPicker
    
    -- Add apply button
    local applyButton = Instance.new("TextButton")
    applyButton.Name = "ApplyButton"
    applyButton.Size = UDim2.new(0.9, 0, 0, 30)
    applyButton.Position = UDim2.new(0.05, 0, 0, 140)
    applyButton.BackgroundColor3 = COLORS.BUTTON
    applyButton.BorderSizePixel = 0
    applyButton.Font = FONT
    applyButton.TextSize = TEXT_SIZE.CONTENT
    applyButton.TextColor3 = COLORS.TEXT
    applyButton.Text = "Apply"
    applyButton.ZIndex = 11
    
    -- Add corner radius
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 4)
    applyCorner.Parent = applyButton
    
    applyButton.Parent = colorPicker
    
    colorPicker.Parent = container
    
    -- Toggle color picker
    colorButton.MouseButton1Click:Connect(function()
        colorPicker.Visible = not colorPicker.Visible
    end)
    
    -- Apply button
    applyButton.MouseButton1Click:Connect(function()
        colorPicker.Visible = false
        
        if callback then
            callback(colorButton.BackgroundColor3)
        end
    end)
    
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "colorPicker",
        instance = container,
        color = defaultColor
    })
    
    return self
end

-- Show the menu
function DiscordCheatUI:Show()
    self.gui.Parent = self.player:WaitForChild("PlayerGui")
    return self
end

-- Hide the menu
function DiscordCheatUI:Hide()
    self.gui.Parent = nil
    return self
end

-- Toggle the menu visibility
function DiscordCheatUI:Toggle()
    if self.gui.Parent then
        self:Hide()
    else
        self:Show()
    end
    return self
end

function DiscordCheatUI:AddServer(name, icon, callback)
    local serverButton = Instance.new("TextButton")
    serverButton.Name = "Server_" .. name
    serverButton.Size = UDim2.new(0, 50, 0, 50)
    serverButton.Position = UDim2.new(0, 10, 0, 10 + (#self.servers * 60))
    serverButton.BackgroundColor3 = COLORS.SIDEBAR
    serverButton.BorderSizePixel = 0
    serverButton.Text = icon or string.sub(name, 1, 1)
    serverButton.Font = FONT
    serverButton.TextSize = 20
    serverButton.TextColor3 = COLORS.TEXT
    
    -- Add corner radius
    local serverCorner = Instance.new("UICorner")
    serverCorner.CornerRadius = UDim.new(0, 25)
    serverCorner.Parent = serverButton
    
    -- Add hover effect
    serverButton.MouseEnter:Connect(function()
        serverButton:TweenSize(
            UDim2.new(0, 55, 0, 55),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
        )
    end)
    
    serverButton.MouseLeave:Connect(function()
        serverButton:TweenSize(
            UDim2.new(0, 50, 0, 50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
        )
    end)
    
    -- Add click event
    serverButton.MouseButton1Click:Connect(function()
        self:SelectServer(name)
        if callback then
            callback()
        end
    end)
    
    serverButton.Parent = self.serverList
    
    table.insert(self.servers, {
        name = name,
        instance = serverButton,
        callback = callback
    })
    
    -- Select this server if it's the first one
    if #self.servers == 1 then
        self:SelectServer(name)
    end
    
    return self
end

-- Select a server
function DiscordCheatUI:SelectServer(name)
    -- Reset previous selection
    if self.selectedServer then
        local prevServer = self:FindServerByName(self.selectedServer)
        if prevServer and prevServer.instance then
            prevServer.instance.BackgroundColor3 = COLORS.SIDEBAR
        end
    end
    
    -- Set new selection
    self.selectedServer = name
    local server = self:FindServerByName(name)
    if server and server.instance then
        server.instance.BackgroundColor3 = COLORS.BUTTON
    end
    
    -- Clear channels and categories
    for _, category in ipairs(self.categories) do
        if category.instance then
            category.instance:Destroy()
        end
    end
    
    for _, channel in ipairs(self.channels) do
        if channel.instance then
            channel.instance:Destroy()
        end
    end
    
    self.categories = {}
    self.channels = {}
    
    -- Clear content
    for _, control in pairs(self.controls) do
        if control.instance then
            control.instance:Destroy()
        end
    end
    self.controls = {}
    
    -- Reset selected channel
    self.selectedChannel = nil
    self.channelNameLabel.Text = "Select a channel"
    self.welcomeMessage.Visible = true
    
    -- Call server callback
    local server = self:FindServerByName(name)
    if server and server.callback then
        server.callback()
    end
    
    return self
end

-- Find a server by name
function DiscordCheatUI:FindServerByName(name)
    for _, server in ipairs(self.servers) do
        if server.name == name then
            return server
        end
    end
    return nil
end

-- Initialize the UI with servers
function DiscordCheatUI:Initialize()
    -- Create server list
    self.serverList = Instance.new("Frame")
    self.serverList.Name = "ServerList"
    self.serverList.Size = UDim2.new(0, 70, 1, 0)
    self.serverList.BackgroundColor3 = COLORS.SIDEBAR
    self.serverList.BorderSizePixel = 0
    self.serverList.Parent = self.mainFrame
    
    -- Add corner radius to server list (only left corners)
    local serverListCorner = Instance.new("UICorner")
    serverListCorner.CornerRadius = UDim.new(0, 8)
    serverListCorner.Parent = self.serverList
    
    -- Create a frame to cover the right corners of the server list
    local coverFrame = Instance.new("Frame")
    coverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    coverFrame.Position = UDim2.new(0.5, 0, 0, 0)
    coverFrame.BackgroundColor3 = COLORS.SIDEBAR
    coverFrame.BorderSizePixel = 0
    coverFrame.ZIndex = 2
    coverFrame.Parent = self.serverList
    
    -- Adjust sidebar position
    self.sidebar.Size = UDim2.new(0.2, 0, 1, 0)
    self.sidebar.Position = UDim2.new(0, 70, 0, 0)
    
    -- Adjust content area position
    self.contentArea.Size = UDim2.new(0.8, -70, 1, 0)
    self.contentArea.Position = UDim2.new(0.2, 70, 0, 0)
    
    self.servers = {}
    
    return self
end

-- Create a new Discord-style cheat menu with servers
function DiscordCheatUI.newWithServers(player)
    local self = DiscordCheatUI.new(player)
    self:Initialize()
    return self
end

return DiscordCheatUI
