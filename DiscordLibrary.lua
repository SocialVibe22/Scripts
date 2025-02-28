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
    HEADER = Color3.fromRGB(32, 34, 37)           -- Header background
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
    self.controls = {}
    
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
    
    -- Create top bar (server name area in Discord)
    self.topBar = Instance.new("Frame")
    self.topBar.Name = "TopBar"
    self.topBar.Size = UDim2.new(0.2, 0, 0.06, 0)
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
    self.sidebar.Position = UDim2.new(0, 0, 0.06, 0)
    self.sidebar.BackgroundColor3 = COLORS.SIDEBAR
    self.sidebar.BorderSizePixel = 0
    self.sidebar.Parent = self.mainFrame
    
    -- Add corner radius to sidebar (only left corners)
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = self.sidebar
    
    -- Create a frame to cover the right corners of the sidebar
    local coverFrame = Instance.new("Frame")
    coverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    coverFrame.Position = UDim2.new(0.5, 0, 0, 0)
    coverFrame.BackgroundColor3 = COLORS.SIDEBAR
    coverFrame.BorderSizePixel = 0
    coverFrame.ZIndex = 2
    coverFrame.Parent = self.sidebar
    
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
    self.channelHeader.Size = UDim2.new(0.8, 0, 0.06, 0)
    self.channelHeader.Position = UDim2.new(0.2, 0, 0, 0)
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
    self.content.Size = UDim2.new(0.8, 0, 0.94, 0)
    self.content.Position = UDim2.new(0.2, 0, 0.06, 0)
    self.content.BackgroundColor3 = COLORS.BACKGROUND
    self.content.BorderSizePixel = 0
    self.content.ScrollBarThickness = 4
    self.content.ScrollBarImageColor3 = Color3.fromRGB(80, 83, 90)
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.Parent = self.mainFrame
    
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
    
    -- Make the UI draggable
    self:MakeDraggable(self.mainFrame, self.topBar)
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
    
    table.insert(self.controls, {
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

return DiscordCheatUI
