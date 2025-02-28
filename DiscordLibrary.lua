local DiscordCheatUI = {}
DiscordCheatUI.__index = DiscordCheatUI

local COLORS = {
    BACKGROUND = Color3.fromRGB(54, 57, 63),
    SIDEBAR = Color3.fromRGB(47, 49, 54),
    CHANNEL_LIST = Color3.fromRGB(47, 49, 54),
    CHANNEL = Color3.fromRGB(142, 146, 151),
    CHANNEL_HOVER = Color3.fromRGB(255, 255, 255),
    CATEGORY = Color3.fromRGB(142, 146, 151),
    SELECTED = Color3.fromRGB(255, 255, 255),
    SELECTED_BG = Color3.fromRGB(66, 70, 77),
    TEXT = Color3.fromRGB(255, 255, 255),
    BUTTON = Color3.fromRGB(88, 101, 242),
    BUTTON_HOVER = Color3.fromRGB(71, 82, 196),
    TOGGLE_ON = Color3.fromRGB(67, 181, 129),
    TOGGLE_OFF = Color3.fromRGB(114, 118, 125),
    SLIDER_BG = Color3.fromRGB(32, 34, 37),
    SLIDER_FILL = Color3.fromRGB(88, 101, 242),
    INPUT_BG = Color3.fromRGB(64, 68, 75),
    HEADER = Color3.fromRGB(32, 34, 37),
    EMBED = Color3.fromRGB(47, 49, 54),
    EMBED_ACCENT = Color3.fromRGB(88, 101, 242),
    SERVER_BG = Color3.fromRGB(32, 34, 37),
    SERVER_SELECTED = Color3.fromRGB(88, 101, 242),
    TOOLTIP_BG = Color3.fromRGB(32, 34, 37),
    SCROLLBAR = Color3.fromRGB(80, 83, 90),
    MODAL_BG = Color3.fromRGB(0, 0, 0, 0.7),
    MODAL_CONTENT = Color3.fromRGB(54, 57, 63),
    SUCCESS = Color3.fromRGB(67, 181, 129),
    ERROR = Color3.fromRGB(240, 71, 71),
    WARNING = Color3.fromRGB(250, 166, 26)
}

local FONT = Enum.Font.SourceSansSemibold
local TEXT_SIZE = {
    CATEGORY = 12,
    CHANNEL = 14,
    HEADER = 16,
    CONTENT = 14,
    SERVER = 12
}

local ICONS = {
    SETTINGS = "⚙️",
    HASHTAG = "#",
    TOGGLE_ON = "✓",
    TOGGLE_OFF = "✗",
    DROPDOWN = "▼",
    DROPDOWN_OPEN = "▲",
    CLOSE = "✕",
    PLUS = "+",
    MINUS = "-",
    SEARCH = "🔍",
    INFO = "ℹ️",
    WARNING = "⚠️",
    ERROR = "❌",
    SUCCESS = "✓",
    LOCK = "🔒",
    UNLOCK = "🔓",
    REFRESH = "🔄",
    LINK = "🔗",
    COPY = "📋",
    EDIT = "✏️",
    DELETE = "🗑️",
    SAVE = "💾",
    CANCEL = "✕",
    USER = "👤",
    USERS = "👥",
    SERVER = "🖥️",
    HOME = "🏠",
    MENU = "☰",
    NOTIFICATION = "🔔",
    MUTE = "🔕",
    PIN = "📌",
    STAR = "⭐",
    HEART = "❤️",
    CLOCK = "🕒",
    CALENDAR = "📅",
    MAIL = "📧",
    PHONE = "📱",
    CAMERA = "📷",
    MICROPHONE = "🎤",
    MUSIC = "🎵",
    GAME = "🎮",
    GLOBE = "🌐",
    SHIELD = "🛡️",
    KEY = "🔑",
    ROCKET = "🚀",
    FIRE = "🔥",
    LIGHTNING = "⚡",
    MAGIC = "✨",
    CROWN = "👑"
}

local ANIMATIONS = {
    DURATION = {
        SHORT = 0.15,
        MEDIUM = 0.25,
        LONG = 0.5
    },
    EASING = {
        LINEAR = Enum.EasingStyle.Linear,
        QUAD = Enum.EasingStyle.Quad,
        CUBIC = Enum.EasingStyle.Cubic,
        QUART = Enum.EasingStyle.Quart,
        QUINT = Enum.EasingStyle.Quint,
        SINE = Enum.EasingStyle.Sine,
        BACK = Enum.EasingStyle.Back,
        ELASTIC = Enum.EasingStyle.Elastic,
        BOUNCE = Enum.EasingStyle.Bounce
    },
    DIRECTION = {
        IN = Enum.EasingDirection.In,
        OUT = Enum.EasingDirection.Out,
        INOUT = Enum.EasingDirection.InOut
    }
}

local function tween(instance, properties, duration, style, direction)
    duration = duration or ANIMATIONS.DURATION.MEDIUM
    style = style or ANIMATIONS.EASING.QUAD
    direction = direction or ANIMATIONS.DIRECTION.OUT
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = game:GetService("TweenService"):Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function createRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    button.MouseButton1Down:Connect(function(x, y)
        local buttonAbsoluteSize = button.AbsoluteSize
        local buttonAbsolutePosition = button.AbsolutePosition
        
        local mousePosition = Vector2.new(x, y)
        local relativePosition = mousePosition - buttonAbsolutePosition
        
        local maxSize = math.max(buttonAbsoluteSize.X, buttonAbsoluteSize.Y) * 2
        
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, relativePosition.X, 0, relativePosition.Y)
        ripple.Parent = button
        
        tween(ripple, {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }, ANIMATIONS.DURATION.MEDIUM, ANIMATIONS.EASING.QUAD, ANIMATIONS.DIRECTION.OUT).Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

local function createShadow(parent, transparency, offset)
    transparency = transparency or 0.5
    offset = offset or 10
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, offset, 1, offset)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    
    return shadow
end

local function createTooltip(parent, text)
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 30)
    tooltip.BackgroundColor3 = COLORS.TOOLTIP_BG
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tooltip
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = FONT
    label.TextSize = TEXT_SIZE.CONTENT
    label.TextColor3 = COLORS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = text
    label.ZIndex = 101
    label.Parent = tooltip
    
    tooltip.Parent = parent.Parent
    
    parent.MouseEnter:Connect(function()
        tooltip.Position = UDim2.new(0, parent.AbsolutePosition.X + parent.AbsoluteSize.X + 5, 0, parent.AbsolutePosition.Y)
        tooltip.Visible = true
    end)
    
    parent.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
    
    return tooltip
end

local function createNotification(parent, title, message, type, duration)
    type = type or "info"
    duration = duration or 5
    
    local colors = {
        info = COLORS.EMBED_ACCENT,
        success = COLORS.SUCCESS,
        warning = COLORS.WARNING,
        error = COLORS.ERROR
    }
    
    local icons = {
        info = ICONS.INFO,
        success = ICONS.SUCCESS,
        warning = ICONS.WARNING,
        error = ICONS.ERROR
    }
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 10, 1, -90)
    notification.BackgroundColor3 = COLORS.EMBED
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = notification
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = colors[type]
    accent.BorderSizePixel = 0
    accent.ZIndex = 1001
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 4)
    accentCorner.Parent = accent
    
    accent.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -50, 0, 30)
    titleLabel.Position = UDim2.new(0, 40, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = FONT
    titleLabel.TextSize = TEXT_SIZE.HEADER
    titleLabel.TextColor3 = COLORS.TEXT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.ZIndex = 1001
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = FONT
    messageLabel.TextSize = TEXT_SIZE.CONTENT
    messageLabel.TextColor3 = COLORS.TEXT
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Text = message
    messageLabel.ZIndex = 1001
    messageLabel.Parent = notification
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 5, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = FONT
    iconLabel.TextSize = 20
    iconLabel.TextColor3 = colors[type]
    iconLabel.Text = icons[type]
    iconLabel.ZIndex = 1001
    iconLabel.Parent = notification
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = FONT
    closeButton.TextSize = 16
    closeButton.TextColor3 = COLORS.TEXT
    closeButton.Text = ICONS.CLOSE
    closeButton.ZIndex = 1001
    closeButton.Parent = notification
    
    createShadow(notification, 0.5, 10)
    
    notification.Parent = parent
    
    tween(notification, {
        Position = UDim2.new(1, -310, 1, -90)
    }, ANIMATIONS.DURATION.MEDIUM, ANIMATIONS.EASING.BACK, ANIMATIONS.DIRECTION.OUT)
    
    closeButton.MouseButton1Click:Connect(function()
        tween(notification, {
            Position = UDim2.new(1, 10, 1, -90)
        }, ANIMATIONS.DURATION.MEDIUM, ANIMATIONS.EASING.QUAD, ANIMATIONS.DIRECTION.IN).Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    task.delay(duration, function()
        if notification and notification.Parent then
            tween(notification, {
                Position = UDim2.new(1, 10, 1, -90)
            }, ANIMATIONS.DURATION.MEDIUM, ANIMATIONS.EASING.QUAD, ANIMATIONS.DIRECTION.IN).Completed:Connect(function()
                if notification and notification.Parent then
                    notification:Destroy()
                end
            end)
        end
    end)
    
    return notification
end

local function createModal(parent, title, content, buttons)
    local modalBackground = Instance.new("Frame")
    modalBackground.Name = "ModalBackground"
    modalBackground.Size = UDim2.new(1, 0, 1, 0)
    modalBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    modalBackground.BackgroundTransparency = 0.7
    modalBackground.BorderSizePixel = 0
    modalBackground.ZIndex = 1000
    
    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 400, 0, 250)
    modal.Position = UDim2.new(0.5, -200, 0.5, -125)
    modal.BackgroundColor3 = COLORS.MODAL_CONTENT
    modal.BorderSizePixel = 0
    modal.ZIndex = 1001
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = modal
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = FONT
    titleLabel.TextSize = TEXT_SIZE.HEADER
    titleLabel.TextColor3 = COLORS.TEXT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.ZIndex = 1002
    titleLabel.Parent = modal
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -20, 0, 1)
    separator.Position = UDim2.new(0, 10, 0, 50)
    separator.BackgroundColor3 = Color3.fromRGB(80, 83, 90)
    separator.BorderSizePixel = 0
    separator.ZIndex = 1002
    separator.Parent = modal
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -20, 0, 140)
    contentLabel.Position = UDim2.new(0, 10, 0, 60)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Font = FONT
    contentLabel.TextSize = TEXT_SIZE.CONTENT
    contentLabel.TextColor3 = COLORS.TEXT
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Text = content
    contentLabel.ZIndex = 1002
    contentLabel.Parent = modal
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -20, 0, 40)
    buttonContainer.Position = UDim2.new(0, 10, 1, -50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ZIndex = 1002
    buttonContainer.Parent = modal
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 10)
    buttonLayout.Parent = buttonContainer
    
    for i, buttonInfo in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Name = "Button_" .. buttonInfo.text
        button.Size = UDim2.new(0, 100, 0, 40)
        button.BackgroundColor3 = buttonInfo.primary and COLORS.BUTTON or COLORS.INPUT_BG
        button.BorderSizePixel = 0
        button.Font = FONT
        button.TextSize = TEXT_SIZE.CONTENT
        button.TextColor3 = COLORS.TEXT
        button.Text = buttonInfo.text
        button.LayoutOrder = i
        button.ZIndex = 1003
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button
        
        button.MouseEnter:Connect(function()
            tween(button, {
                BackgroundColor3 = buttonInfo.primary and COLORS.BUTTON_HOVER or Color3.fromRGB(80, 83, 90)
            }, ANIMATIONS.DURATION.SHORT)
        end)
        
        button.MouseLeave:Connect(function()
            tween(button, {
                BackgroundColor3 = buttonInfo.primary and COLORS.BUTTON or COLORS.INPUT_BG
            }, ANIMATIONS.DURATION.SHORT)
        end)
        
        button.MouseButton1Click:Connect(function()
            if buttonInfo.callback then
                buttonInfo.callback()
            end
            
            tween(modalBackground, {
                BackgroundTransparency = 1
            }, ANIMATIONS.DURATION.MEDIUM)
            
            tween(modal, {
                Position = UDim2.new(0.5, -200, 0.5, -125 - 50),
                BackgroundTransparency = 1
            }, ANIMATIONS.DURATION.MEDIUM).Completed:Connect(function()
                modalBackground:Destroy()
            end)
        end)
        
        createRippleEffect(button)
        button.Parent = buttonContainer
    end
    
    createShadow(modal, 0.5, 20)
    
    modal.Parent = modalBackground
    modalBackground.Parent = parent
    
    modal.Position = UDim2.new(0.5, -200, 0.5, -125 - 50)
    modal.BackgroundTransparency = 1
    modalBackground.BackgroundTransparency = 1
    
    tween(modalBackground, {
        BackgroundTransparency = 0.7
    }, ANIMATIONS.DURATION.MEDIUM)
    
    tween(modal, {
        Position = UDim2.new(0.5, -200, 0.5, -125),
        BackgroundTransparency = 0
    }, ANIMATIONS.DURATION.MEDIUM, ANIMATIONS.EASING.BACK, ANIMATIONS.DIRECTION.OUT)
    
    return modalBackground
end

function DiscordCheatUI.new(player)
    local self = setmetatable({}, DiscordCheatUI)
    
    self.player = player
    self.categories = {}
    self.channels = {}
    self.callbacks = {}
    self.selectedChannel = nil
    self.controls = {}
    self.servers = {}
    self.selectedServer = nil
    self.notifications = {}
    
    self:CreateMainUI()
    
    return self
end

function DiscordCheatUI.newWithServers(player)
    local self = DiscordCheatUI.new(player)
    self.useServers = true
    self:CreateServerBar()
    return self
end

function DiscordCheatUI:CreateMainUI()
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "DiscordCheatUI"
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    self.mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    self.mainFrame.BackgroundColor3 = COLORS.BACKGROUND
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.mainFrame
    
    createShadow(self.mainFrame)
    
    self.topBar = Instance.new("Frame")
    self.topBar.Name = "TopBar"
    self.topBar.Size = UDim2.new(0.2, 0, 0.06, 0)
    self.topBar.BackgroundColor3 = COLORS.SIDEBAR
    self.topBar.BorderSizePixel = 0
    self.topBar.Parent = self.mainFrame
    
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
    
    self.sidebar = Instance.new("Frame")
    self.sidebar.Name = "Sidebar"
    self.sidebar.Size = UDim2.new(0.2, 0, 0.94, 0)
    self.sidebar.Position = UDim2.new(0, 0, 0.06, 0)
    self.sidebar.BackgroundColor3 = COLORS.SIDEBAR
    self.sidebar.BorderSizePixel = 0
    self.sidebar.Parent = self.mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = self.sidebar
    
    local coverFrame = Instance.new("Frame")
    coverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    coverFrame.Position = UDim2.new(0.5, 0, 0, 0)
    coverFrame.BackgroundColor3 = COLORS.SIDEBAR
    coverFrame.BorderSizePixel = 0
    coverFrame.ZIndex = 2
    coverFrame.Parent = self.sidebar
    
    self.scrollFrame = Instance.new("ScrollingFrame")
    self.scrollFrame.Name = "ChannelList"
    self.scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.scrollFrame.BackgroundTransparency = 1
    self.scrollFrame.BorderSizePixel = 0
    self.scrollFrame.ScrollBarThickness = 4
    self.scrollFrame.ScrollBarImageColor3 = COLORS.SCROLLBAR
    self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.scrollFrame.Parent = self.sidebar
    
    self.channelHeader = Instance.new("Frame")
    self.channelHeader.Name = "ChannelHeader"
    self.channelHeader.Size = UDim2.new(0.8, 0, 0.06, 0)
    self.channelHeader.Position = UDim2.new(0.2, 0, 0, 0)
    self.channelHeader.BackgroundColor3 = COLORS.HEADER
    self.channelHeader.BorderSizePixel = 0
    self.channelHeader.Parent = self.mainFrame
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, 0)
    separator.BackgroundColor3 = Color3.fromRGB(60, 63, 69)
    separator.BorderSizePixel = 0
    separator.Parent = self.channelHeader
    
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
    
    self.content = Instance.new("ScrollingFrame")
    self.content.Name = "Content"
    self.content.Size = UDim2.new(0.8, 0, 0.94, 0)
    self.content.Position = UDim2.new(0.2, 0, 0.06, 0)
    self.content.BackgroundColor3 = COLORS.BACKGROUND
    self.content.BorderSizePixel = 0
    self.content.ScrollBarThickness = 4
    self.content.ScrollBarImageColor3 = COLORS.SCROLLBAR
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.Parent = self.mainFrame
    
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
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = self.scrollFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = self.content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 20)
    contentPadding.PaddingBottom = UDim.new(0, 20)
    contentPadding.PaddingLeft = UDim.new(0, 20)
    contentPadding.PaddingRight = UDim.new(0, 20)
    contentPadding.Parent = self.content
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    self:MakeDraggable(self.mainFrame, self.topBar)
    
    self.notificationContainer = Instance.new("Frame")
    self.notificationContainer.Name = "NotificationContainer"
    self.notificationContainer.Size = UDim2.new(1, 0, 1, 0)
    self.notificationContainer.BackgroundTransparency = 1
    self.notificationContainer.Parent = self.gui
end

function DiscordCheatUI:CreateServerBar()
    self.serverBar = Instance.new("Frame")
    self.serverBar.Name = "ServerBar"
    self.serverBar.Size = UDim2.new(0.06, 0, 1, 0)
    self.serverBar.BackgroundColor3 = COLORS.SERVER_BG
    self.serverBar.BorderSizePixel = 0
    self.serverBar.Parent = self.mainFrame
    
    local serverBarCorner = Instance.new("UICorner")
    serverBarCorner.CornerRadius = UDim.new(0, 8)
    serverBarCorner.Parent = self.serverBar
    
    local coverFrame = Instance.new("Frame")
    coverFrame.Size = UDim2.new(0.5, 0, 1, 0)
    coverFrame.Position = UDim2.new(0.5, 0, 0, 0)
    coverFrame.BackgroundColor3 = COLORS.SERVER_BG
    coverFrame.BorderSizePixel = 0
    coverFrame.ZIndex = 2
    coverFrame.Parent = self.serverBar
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0.7, 0, 0, 2)
    separator.Position = UDim2.new(0.15, 0, 0, 70)
    separator.BackgroundColor3 = Color3.fromRGB(60, 63, 69)
    separator.BorderSizePixel = 0
    separator.Parent = self.serverBar
    
    self.serverScroll = Instance.new("ScrollingFrame")
    self.serverScroll.Name = "ServerScroll"
    self.serverScroll.Size = UDim2.new(1, 0, 1, -80)
    self.serverScroll.Position = UDim2.new(0, 0, 0, 80)
    self.serverScroll.BackgroundTransparency = 1
    self.serverScroll.BorderSizePixel = 0
    self.serverScroll.ScrollBarThickness = 0
    self.serverScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.serverScroll.Parent = self.serverBar
    
    local serverLayout = Instance.new("UIListLayout")
    serverLayout.SortOrder = Enum.SortOrder.LayoutOrder
    serverLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    serverLayout.Padding = UDim.new(0, 10)
    serverLayout.Parent = self.serverScroll
    
    local serverPadding = Instance.new("UIPadding")
    serverPadding.PaddingTop = UDim.new(0, 10)
    serverPadding.PaddingBottom = UDim.new(0, 10)
    serverPadding.Parent = self.serverScroll
    
    serverLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.serverScroll.CanvasSize = UDim2.new(0, 0, 0, serverLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local homeButton = Instance.new("TextButton")
    homeButton.Name = "HomeButton"
    homeButton.Size = UDim2.new(0, 40, 0, 40)
    homeButton.Position = UDim2.new(0.5, -20, 0, 15)
    homeButton.BackgroundColor3 = COLORS.BUTTON
    homeButton.BorderSizePixel = 0
    homeButton.Font = FONT
    homeButton.TextSize = 18
    homeButton.TextColor3 = COLORS.TEXT
    homeButton.Text = ICONS.HOME
    homeButton.Parent = self.serverBar
    
    local homeCorner = Instance.new("UICorner")
    homeCorner.CornerRadius = UDim.new(1, 0)
    homeCorner.Parent = homeButton
    
    homeButton.MouseButton1Click:Connect(function()
        self:SelectServer("HOME")
    end)
    
    createRippleEffect(homeButton)
    
    self.mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    self.topBar.Size = UDim2.new(0.2, 0, 0.06, 0)
    self.topBar.Position = UDim2.new(0.06, 0, 0, 0)
    self.sidebar.Size = UDim2.new(0.2, 0, 0.94, 0)
    self.sidebar.Position = UDim2.new(0.06, 0, 0.06, 0)
    self.channelHeader.Size = UDim2.new(0.74, 0, 0.06, 0)
    self.channelHeader.Position = UDim2.new(0.26, 0, 0, 0)
    self.content.Size = UDim2.new(0.74, 0, 0.94, 0)
    self.content.Position = UDim2.new(0.26, 0, 0.06, 0)
    
    self:AddServer("HOME", "H", function()
        self:AddCategory("WELCOME")
        self:AddChannel("welcome", function()
            self:AddSectionTitle("Welcome to Discord Cheat Menu")
            self:AddEmbed("Getting Started", "This Discord-style cheat menu provides various hacks and tools for your game. Select a server from the sidebar to access different categories of cheats.", COLORS.EMBED_ACCENT, {
                {name = "Navigation", value = "Use the server icons on the left to switch between different cheat categories."},
                {name = "Channels", value = "Each server contains channels with specific cheat functions."},
                {name = "Controls", value = "Interact with buttons, sliders, and toggles to activate cheats."}
            })
            
            self:AddButton("Show Tutorial", function()
                self:ShowNotification("Tutorial", "Click on the server icons on the left to navigate between different cheat categories. Each server contains channels with specific cheat functions.", "info", 10)
            end)
        end)
    end)
end

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

function DiscordCheatUI:AddServer(name, icon, callback)
    if not self.useServers then
        self.useServers = true
        self:CreateServerBar()
    end
    
    local layoutOrder = #self.servers + 1
    
    local serverButton = Instance.new("TextButton")
    serverButton.Name = "Server_" .. name
    serverButton.Size = UDim2.new(0, 40, 0, 40)
    serverButton.BackgroundColor3 = COLORS.SIDEBAR
    serverButton.BorderSizePixel = 0
    serverButton.Font = FONT
    serverButton.TextSize = TEXT_SIZE.SERVER
    serverButton.TextColor3 = COLORS.TEXT
    serverButton.Text = icon or string.sub(name, 1, 1)
    serverButton.LayoutOrder = layoutOrder
    
    local serverCorner = Instance.new("UICorner")
    serverCorner.CornerRadius = UDim.new(1, 0)
    serverCorner.Parent = serverButton
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 5, 0, 0)
    indicator.Position = UDim2.new(0, -10, 0.5, 0)
    indicator.BackgroundColor3 = COLORS.TEXT
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = serverButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    serverButton.MouseEnter:Connect(function()
        if self.selectedServer ~= name then
            tween(serverButton, {
                BackgroundColor3 = Color3.fromRGB(80, 83, 90)
            }, ANIMATIONS.DURATION.SHORT)
            
            if indicator.Size.Y.Offset == 0 then
                indicator.Position = UDim2.new(0, -10, 0.5, -10)
                indicator.Size = UDim2.new(0, 5, 0, 20)
                indicator.Visible = true
            end
        end
    end)
    
    serverButton.MouseLeave:Connect(function()
        if self.selectedServer ~= name then
            tween(serverButton, {
                BackgroundColor3 = COLORS.SIDEBAR
            }, ANIMATIONS.DURATION.SHORT)
            
            tween(indicator, {
                Size = UDim2.new(0, 5, 0, 0),
                Position = UDim2.new(0, -10, 0.5, 0)
            }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                if indicator.Size.Y.Offset == 0 then
                    indicator.Visible = false
                end
            end)
        end
    end)
    
    serverButton.MouseButton1Click:Connect(function()
        self:SelectServer(name)
        
        if callback then
            callback()
        end
    end)
    
    createRippleEffect(serverButton)
    createTooltip(serverButton, name)
    
    serverButton.Parent = self.serverScroll
    
    table.insert(self.servers, {
        name = name,
        instance = serverButton,
        indicator = indicator,
        callback = callback,
        layoutOrder = layoutOrder
    })
    
    if name == "HOME" and not self.selectedServer then
        self:SelectServer(name)
        if callback then
            callback()
        end
    end
    
    return self
end

function DiscordCheatUI:SelectServer(name)
    for _, category in ipairs(self.categories) do
        if category.instance then
            category.instance:Destroy()
        end
    end
    self.categories = {}
    
    for _, channel in ipairs(self.channels) do
        if channel.instance then
            channel.instance:Destroy()
        end
    end
    self.channels = {}
    
    for _, control in pairs(self.controls) do
        if control.instance then
            control.instance:Destroy()
        end
    end
    self.controls = {}
    
    if self.selectedServer then
        local prevServer = self:FindServerByName(self.selectedServer)
        if prevServer and prevServer.instance then
            tween(prevServer.instance, {
                BackgroundColor3 = COLORS.SIDEBAR
            }, ANIMATIONS.DURATION.SHORT)
            
            if prevServer.indicator then
                tween(prevServer.indicator, {
                    Size = UDim2.new(0, 5, 0, 0),
                    Position = UDim2.new(0, -10, 0.5, 0)
                }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                    if prevServer.indicator.Size.Y.Offset == 0 then
                        prevServer.indicator.Visible = false
                    end
                end)
            end
        end
    }
    
    self.selectedServer = name
    self.selectedChannel = nil
    
    local server = self:FindServerByName(name)
    if server and server.instance then
        tween(server.instance, {
            BackgroundColor3 = COLORS.SERVER_SELECTED
        }, ANIMATIONS.DURATION.SHORT)
        
        if server.indicator then
            server.indicator.Position = UDim2.new(0, -10, 0.5, -15)
            server.indicator.Size = UDim2.new(0, 5, 0, 30)
            server.indicator.Visible = true
        end
    end
    
    self.channelNameLabel.Text = "Select a channel"
    self.welcomeMessage.Visible = true
    
    return self
end

function DiscordCheatUI:FindServerByName(name)
    for _, server in ipairs(self.servers) do
        if server.name == name then
            return server
        end
    end
    return nil
end

function DiscordCheatUI:AddCategory(name)
    local layoutOrder = #self.categories + #self.channels + 1
    
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
        layoutOrder = layout Order = layoutOrder
    })
    
    return self
end

function DiscordCheatUI:AddChannel(name, callback)
    local layoutOrder = #self.categories + #self.channels + 1
    
    local channelContainer = Instance.new("Frame")
    channelContainer.Name = "ChannelContainer_" .. name
    channelContainer.Size = UDim2.new(1, -10, 0, 30)
    channelContainer.BackgroundTransparency = 1
    channelContainer.LayoutOrder = layoutOrder
    channelContainer.Parent = self.scrollFrame
    
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
    
    local selectionIndicator = Instance.new("Frame")
    selectionIndicator.Name = "SelectionIndicator"
    selectionIndicator.Size = UDim2.new(1, 0, 1, 0)
    selectionIndicator.BackgroundColor3 = COLORS.SELECTED_BG
    selectionIndicator.BorderSizePixel = 0
    selectionIndicator.ZIndex = 0
    selectionIndicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 4)
    indicatorCorner.Parent = selectionIndicator
    
    selectionIndicator.Parent = channelContainer
    
    channel.MouseEnter:Connect(function()
        if self.selectedChannel ~= name then
            tween(channel, {
                TextColor3 = COLORS.CHANNEL_HOVER
            }, ANIMATIONS.DURATION.SHORT)
        end
    end)
    
    channel.MouseLeave:Connect(function()
        if self.selectedChannel ~= name then
            tween(channel, {
                TextColor3 = COLORS.CHANNEL
            }, ANIMATIONS.DURATION.SHORT)
        end
    end)
    
    channel.MouseButton1Click:Connect(function()
        self:SelectChannel(name)
        if callback then
            callback()
        end
    end)
    
    createRippleEffect(channel)
    
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

function DiscordCheatUI:SelectChannel(name)
    if self.selectedChannel then
        local prevChannel = self:FindChannelByName(self.selectedChannel)
        if prevChannel and prevChannel.instance then
            tween(prevChannel.instance, {
                TextColor3 = COLORS.CHANNEL
            }, ANIMATIONS.DURATION.SHORT)
            
            if prevChannel.indicator then
                tween(prevChannel.indicator, {
                    BackgroundTransparency = 1
                }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                    prevChannel.indicator.Visible = false
                end)
            end
        end
    }
    
    self.selectedChannel = name
    local channel = self:FindChannelByName(name)
    if channel and channel.instance then
        tween(channel.instance, {
            TextColor3 = COLORS.SELECTED
        }, ANIMATIONS.DURATION.SHORT)
        
        if channel.indicator then
            channel.indicator.BackgroundTransparency = 1
            channel.indicator.Visible = true
            tween(channel.indicator, {
                BackgroundTransparency = 0
            }, ANIMATIONS.DURATION.SHORT)
        end
    end
    
    self.channelNameLabel.Text = "# " .. name
    
    self.welcomeMessage.Visible = false
    
    for _, control in pairs(self.controls) do
        if control.instance then
            control.instance:Destroy()
        end
    end
    self.controls = {}
    
    return self
end

function DiscordCheatUI:FindChannelByName(name)
    for _, channel in ipairs(self.channels) do
        if channel.name == name then
            return channel
        end
    end
    return nil
end

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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        tween(button, {
            BackgroundColor3 = COLORS.BUTTON_HOVER
        }, ANIMATIONS.DURATION.SHORT)
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = COLORS.BUTTON
        }, ANIMATIONS.DURATION.SHORT)
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    createRippleEffect(button)
    button.Parent = self.content
    
    table.insert(self.controls, {
        type = "button",
        instance = button
    })
    
    return self
end

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
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBackground
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "ToggleIndicator"
    toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    toggleIndicator.Position = UDim2.new(initialState and 0.6 or 0, 2, 0, 2)
    toggleIndicator.BackgroundColor3 = COLORS.TEXT
    toggleIndicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = toggleIndicator
    
    toggleIndicator.Parent = toggleBackground
    toggleBackground.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(0.85, 0, 0.5, -10)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    toggleButton.MouseButton1Click:Connect(function()
        initialState = not initialState
        
        tween(toggleBackground, {
            BackgroundColor3 = initialState and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF
        }, ANIMATIONS.DURATION.SHORT)
        
        tween(toggleIndicator, {
            Position = UDim2.new(initialState and 0.6 or 0, 2, 0, 2)
        }, ANIMATIONS.DURATION.SHORT)
        
        if callback then
            callback(initialState)
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
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 5)
    bgCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((initialValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.SLIDER_FILL
    sliderFill.BorderSizePixel = 0
    
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
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    sliderButton.Parent = sliderBackground
    sliderBackground.Parent = container
    
    local dragging = false
    
    local function updateSlider(mousePos)
        local sliderPos = sliderBackground.AbsolutePosition.X
        local sliderSize = sliderBackground.AbsoluteSize.X
        
        local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        local value = min + relativePos * (max - min)
        value = math.floor(value + 0.5)
        
        tween(sliderFill, {
            Size = UDim2.new(relativePos, 0, 1, 0)
        }, ANIMATIONS.DURATION.SHORT)
        
        tween(sliderButton, {
            Position = UDim2.new(relativePos, -10, 0, -5)
        }, ANIMATIONS.DURATION.SHORT)
        
        valueLabel.Text = tostring(value)
        
        if callback then
            callback(value)
        end
    end
    
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
            updateSlider(input.Position.X)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
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
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = dropdownButton
    
    dropdownButton.Parent = container
    
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "DropdownMenu"
    dropdownMenu.Size = UDim2.new(0.6, 0, 0, #options * 30)
    dropdownMenu.Position = UDim2.new(0.4, 0, 1, 5)
    dropdownMenu.BackgroundColor3 = COLORS.INPUT_BG
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 10
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 4)
    menuCorner.Parent = dropdownMenu
    
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
            tween(optionButton, {
                BackgroundTransparency = 0.8
            }, ANIMATIONS.DURATION.SHORT)
        end)
        
        optionButton.MouseLeave:Connect(function()
            tween(optionButton, {
                BackgroundTransparency = 1
            }, ANIMATIONS.DURATION.SHORT)
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option .. " " .. ICONS.DROPDOWN
            
            tween(dropdownMenu, {
                Size = UDim2.new(0.6, 0, 0, 0),
                Position = UDim2.new(0.4, 0, 1, 5)
            }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                dropdownMenu.Visible = false
                dropdownMenu.Size = UDim2.new(0.6, 0, 0, #options * 30)
            end)
            
            if callback then
                callback(option)
            end
        end)
        
        createRippleEffect(optionButton)
        optionButton.Parent = dropdownMenu
    end
    
    dropdownMenu.Parent = container
    
    dropdownButton.MouseButton1Click:Connect(function()
        if dropdownMenu.Visible then
            tween(dropdownMenu, {
                Size = UDim2.new(0.6, 0, 0, 0),
                Position = UDim2.new(0.4, 0, 1, 5)
            }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                dropdownMenu.Visible = false
                dropdownMenu.Size = UDim2.new(0.6, 0, 0, #options * 30)
            end)
            
            dropdownButton.Text = initialSelection .. " " .. ICONS.DROPDOWN
        else
            dropdownMenu.Size = UDim2.new(0.6, 0, 0, 0)
            dropdownMenu.Position = UDim2.new(0.4, 0, 1, 5)
            dropdownMenu.Visible = true
            
            tween(dropdownMenu, {
                Size = UDim2.new(0.6, 0, 0, #options * 30),
                Position = UDim2.new(0.4, 0, 1, 5)
            }, ANIMATIONS.DURATION.SHORT)
            
            dropdownButton.Text = initialSelection .. " " .. ICONS.DROPDOWN_OPEN
        end
    end)
    
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
                tween(dropdownMenu, {
                    Size = UDim2.new(0.6, 0, 0, 0),
                    Position = UDim2.new(0.4, 0, 1, 5)
                }, ANIMATIONS.DURATION.SHORT).Completed:Connect(function()
                    dropdownMenu.Visible = false
                    dropdownMenu.Size = UDim2.new(0.6, 0, 0, #options * 30)
                end)
                
                dropdownButton.Text = initialSelection .. " " .. ICONS.DROPDOWN
            end
        end
    end)
    
    createRippleEffect(dropdownButton)
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "dropdown",
        instance = container,
        selection = initialSelection
    })
    
    return self
end

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
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.PaddingRight = UDim.new(0, 10)
    inputPadding.Parent = inputBox
    
    inputBox.Focused:Connect(function()
        tween(inputBox, {
            BackgroundColor3 = Color3.fromRGB(80, 83, 90)
        }, ANIMATIONS.DURATION.SHORT)
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        tween(inputBox, {
            BackgroundColor3 = COLORS.INPUT_BG
        }, ANIMATIONS.DURATION.SHORT)
        
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = embed
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = color
    accent.BorderSizePixel = 0
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 4)
    accentCorner.Parent = accent
    
    accent.Parent = embed
    
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
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = keyButton
    
    keyButton.Parent = container
    
    local listening = false
    
    keyButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        keyButton.Text = "..."
        
        tween(keyButton, {
            BackgroundColor3 = COLORS.BUTTON
        }, ANIMATIONS.DURATION.SHORT)
        
        local connection
        connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = string.sub(tostring(input.KeyCode), 14)
                keyButton.Text = keyName
                listening = false
                
                tween(keyButton, {
                    BackgroundColor3 = COLORS.INPUT_BG
                }, ANIMATIONS.DURATION.SHORT)
                
                connection:Disconnect()
                
                if callback then
                    callback(input.KeyCode)
                end
            end
        end)
    end)
    
    createRippleEffect(keyButton)
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "keybind",
        instance = container,
        key = defaultKey
    })
    
    return self
end

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
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorButton
    
    colorButton.Parent = container
    
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = "ColorPicker"
    colorPicker.Size = UDim2.new(0.8, 0, 0, 200)
    colorPicker.Position = UDim2.new(0.1, 0, 1, 10)
    colorPicker.BackgroundColor3 = COLORS.EMBED
    colorPicker.BorderSizePixel = 0
    colorPicker.Visible = false
    colorPicker.ZIndex = 10
    
    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 4)
    pickerCorner.Parent = colorPicker
    
    local redSlider = Instance.new("Frame")
    redSlider.Name = "RedSlider"
    redSlider.Size = UDim2.new(0.9, 0, 0, 20)
    redSlider.Position = UDim2.new(0.05, 0, 0, 20)
    redSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    redSlider.BorderSizePixel = 0
    redSlider.ZIndex = 11
    
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
    
    local blueCorner = Instance.new("UICorner")
    blueCorner.CornerRadius = UDim.new(0, 4)
    blueCorner.Parent = blueSlider
    
    blueSlider.Parent = colorPicker
    
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
    
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 4)
    applyCorner.Parent = applyButton
    
    applyButton.Parent = colorPicker
    
    colorPicker.Parent = container
    
    colorButton.MouseButton1Click:Connect(function()
        colorPicker.Visible = not colorPicker.Visible
    end)
    
    applyButton.MouseButton1Click:Connect(function()
        colorPicker.Visible = false
        
        if callback then
            callback(colorButton.BackgroundColor3)
        end
    end)
    
    createRippleEffect(colorButton)
    createRippleEffect(applyButton)
    container.Parent = self.content
    
    table.insert(self.controls, {
        type = "colorPicker",
        instance = container,
        color = defaultColor
    })
    
    return self
end

function DiscordCheatUI:ShowNotification(title, message, type, duration)
    return createNotification(self.notificationContainer, title, message, type, duration)
end

function DiscordCheatUI:ShowModal(title, content, buttons)
    return createModal(self.gui, title, content, buttons)
end

function DiscordCheatUI:Show()
    self.gui.Parent = self.player:WaitForChild("PlayerGui")
    return self
end

function DiscordCheatUI:Hide()
    self.gui.Parent = nil
    return self
end

function DiscordCheatUI:Toggle()
    if self.gui.Parent then
        self:Hide()
    else
        self:Show()
    end
    return self
end

return DiscordCheatUI
