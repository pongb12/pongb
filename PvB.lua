

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ========================================
-- GLOBAL STATE & CONFIGURATION
-- ========================================

local API_BASE = "https://stock-predicitions-api.vercel.app/api"
local CACHE_DURATION = 60 -- seconds
local MAX_RETRIES = 3
local RETRY_DELAY = 1

-- Connection tracking để cleanup
local activeConnections = {}
local isFetching = false

-- Cache system
local cache = {}

-- Premium UI Colors
local COLOR_SCHEME = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(0, 150, 255),
    Success = Color3.fromRGB(85, 255, 127),
    Warning = Color3.fromRGB(255, 193, 7),
    Error = Color3.fromRGB(255, 87, 87),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(180, 180, 200)
}

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- Safe instance creation
local function secureCreate(className, properties)
    local success, instance = pcall(function()
        local obj = Instance.new(className)
        for prop, value in pairs(properties or {}) do
            pcall(function()
                obj[prop] = value
            end)
        end
        return obj
    end)
    return success and instance or nil
end

-- Obfuscated naming
local function getObfuscatedName(baseName)
    local prefixes = {"UI", "Frame", "Container", "Display", "View"}
    local suffixes = {"Manager", "Handler", "Controller", "Interface"}
    local randomId = math.random(1000, 9999)
    return prefixes[math.random(1, #prefixes)] .. suffixes[math.random(1, #suffixes)] .. randomId
end

-- Track connections for cleanup
local function trackConnection(connection)
    table.insert(activeConnections, connection)
    return connection
end

-- Cleanup all connections
local function cleanupConnections()
    for _, connection in ipairs(activeConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    activeConnections = {}
end

-- Format Unix timestamp to readable time
local function formatUnixTime(unix)
    local currentTime = os.time()
    local diff = unix - currentTime
    
    if diff < 0 then
        return "Passed"
    elseif diff < 60 then
        return diff .. "s"
    elseif diff < 3600 then
        return math.floor(diff / 60) .. "m"
    elseif diff < 86400 then
        return math.floor(diff / 3600) .. "h"
    else
        return math.floor(diff / 86400) .. "d"
    end
end

-- Input validation
local function validateItemName(name)
    if not name or type(name) ~= "string" then
        return false, "Invalid item name"
    end
    
    name = name:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
    
    if #name < 2 then
        return false, "Name too short (min 2 characters)"
    end
    
    if #name > 50 then
        return false, "Name too long (max 50 characters)"
    end
    
    return true, name
end

local function validateAmount(amount)
    local num = tonumber(amount)
    if not num then
        return false, "Amount must be a number"
    end
    
    if num < 1 or num > 10 then
        return false, "Amount must be between 1-10"
    end
    
    return true, math.floor(num)
end

-- ========================================
-- UI COMPONENTS
-- ========================================

local function createGradient(parent)
    local gradient = secureCreate("UIGradient", {
        Rotation = 45,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLOR_SCHEME.Background),
            ColorSequenceKeypoint.new(1, COLOR_SCHEME.Secondary)
        })
    })
    if gradient and parent then
        gradient.Parent = parent
    end
    return gradient
end

local function createModernButton(parent, text, size, position)
    local buttonContainer = secureCreate("Frame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local button = secureCreate("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLOR_SCHEME.Accent,
        TextColor3 = COLOR_SCHEME.TextPrimary,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = buttonContainer
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    -- Hover effects
    trackConnection(button.MouseEnter:Connect(function()
        if button and button.Parent then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            }):Play()
        end
    end))
    
    trackConnection(button.MouseLeave:Connect(function()
        if button and button.Parent then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = COLOR_SCHEME.Accent
            }):Play()
        end
    end))
    
    return button
end

local function createModernInput(parent, placeholder, size, position)
    local container = secureCreate("Frame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local input = secureCreate("TextBox", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        TextColor3 = COLOR_SCHEME.TextPrimary,
        PlaceholderText = placeholder,
        PlaceholderColor3 = COLOR_SCHEME.TextSecondary,
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        Parent = container
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = input
    })
    
    local padding = secureCreate("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = input
    })
    
    -- Focus effects
    trackConnection(input.Focused:Connect(function()
        if input and input.Parent then
            TweenService:Create(input, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            }):Play()
        end
    end))
    
    trackConnection(input.FocusLost:Connect(function()
        if input and input.Parent then
            TweenService:Create(input, TweenInfo.new(0.2), {
                BackgroundColor3 = COLOR_SCHEME.Secondary
            }):Play()
        end
    end))
    
    return input
end

local function createLoadingSpinner(parent)
    local spinner = secureCreate("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0.5, -20, 0.5, -20),
        BackgroundTransparency = 1,
        ZIndex = 10,
        Parent = parent
    })
    
    local circle = secureCreate("ImageLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -15, 0.5, -15),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = COLOR_SCHEME.Accent,
        Parent = spinner
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = circle
    })
    
    local rotation = 0
    local connection = trackConnection(RunService.Heartbeat:Connect(function(delta)
        if spinner and spinner.Parent and circle and circle.Parent then
            rotation = (rotation + 360 * delta * 2) % 360
            circle.Rotation = rotation
        else
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
    end))
    
    return spinner, connection
end

-- ========================================
-- API FUNCTIONS
-- ========================================

-- Fetch with retry logic and proper error handling
local function fetchStockPredictions(itemName, amount)
    -- Check cache first
    local cacheKey = itemName:lower() .. "_" .. amount
    local cached = cache[cacheKey]
    
    if cached and (os.time() - cached.time) < CACHE_DURATION then
        return cached.data, nil, true -- true = from cache
    end
    
    local encodedName = HttpService:UrlEncode(itemName)
    local url = API_BASE .. "/Stock?name=" .. encodedName .. "&amount=" .. tostring(amount)
    
    for attempt = 1, MAX_RETRIES do
        local success, result = pcall(function()
            return HttpService:RequestAsync({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            })
        end)
        
        -- Check if request succeeded
        if success and type(result) == "table" and result.Success then
            -- Try to parse JSON
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(result.Body)
            end)
            
            if parseSuccess and type(data) == "table" then
                -- Cache the result
                cache[cacheKey] = {
                    data = data,
                    time = os.time()
                }
                return data, nil, false
            else
                return nil, "Failed to parse API response"
            end
        end
        
        -- Retry logic
        if attempt < MAX_RETRIES then
            wait(RETRY_DELAY)
        else
            local errorMsg = "API request failed"
            if type(result) == "string" then
                errorMsg = errorMsg .. ": " .. result
            elseif type(result) == "table" and result.StatusMessage then
                errorMsg = errorMsg .. ": " .. result.StatusMessage
            end
            return nil, errorMsg
        end
    end
    
    return nil, "Failed after " .. MAX_RETRIES .. " attempts"
end

-- ========================================
-- GUI CREATION
-- ========================================

local function createCompactGUI()
    local screenGui = secureCreate("ScreenGui", {
        Name = getObfuscatedName("MainGUI"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    if not screenGui then return nil end

    -- Main Container
    local mainContainer = secureCreate("Frame", {
        Size = UDim2.new(0, 400, 0, 450),
        Position = UDim2.new(0.5, -200, 0.5, -225),
        BackgroundColor3 = COLOR_SCHEME.Background,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    
    createGradient(mainContainer)
    
    local mainCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainContainer
    })

    -- Header
    local header = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        BorderSizePixel = 0,
        Parent = mainContainer
    })
    
    createGradient(header)
    
    local headerCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = header
    })

    -- Title
    local title = secureCreate("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "📈 STOCK PREDICTIONS",
        TextColor3 = COLOR_SCHEME.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    -- Close button
    local closeBtn = createModernButton(header, "×", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0.5, -15))
    closeBtn.TextSize = 20

    -- Content area
    local content = secureCreate("Frame", {
        Size = UDim2.new(1, -30, 1, -80),
        Position = UDim2.new(0, 15, 0, 65),
        BackgroundTransparency = 1,
        Parent = mainContainer
    })

    -- Input section
    local inputSection = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundTransparency = 1,
        Parent = content
    })

    local itemInput = createModernInput(inputSection, "Item name (e.g. Mango Seed)", UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0))

    local bottomRow = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        Parent = inputSection
    })

    local amountInput = createModernInput(bottomRow, "Amount (1-10)", UDim2.new(0.35, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    amountInput.Text = "5"

    local fetchBtn = createModernButton(bottomRow, "🔍 FETCH", UDim2.new(0.62, 0, 1, 0), UDim2.new(0.38, 0, 0, 0))

    -- Results section
    local resultsSection = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 1, -115),
        Position = UDim2.new(0, 0, 0, 85),
        BackgroundTransparency = 1,
        Parent = content
    })

    local resultsLabel = secureCreate("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "PREDICTION RESULTS",
        TextColor3 = COLOR_SCHEME.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = resultsSection
    })

    local resultsScroll = secureCreate("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLOR_SCHEME.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = resultsSection
    })

    local scrollCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = resultsScroll
    })

    local resultsList = secureCreate("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = resultsScroll
    })

    local padding = secureCreate("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        Parent = resultsScroll
    })

    -- Status bar
    local statusBar = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        BorderSizePixel = 0,
        Parent = content
    })

    local statusCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = statusBar
    })

    local statusLabel = secureCreate("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "Ready to fetch predictions...",
        TextColor3 = COLOR_SCHEME.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = statusBar
    })

    return {
        ScreenGui = screenGui,
        MainContainer = mainContainer,
        ItemInput = itemInput,
        AmountInput = amountInput,
        FetchButton = fetchBtn,
        CloseButton = closeBtn,
        ResultsScroll = resultsScroll,
        StatusLabel = statusLabel,
        ResultsList = resultsList
    }
end

-- ========================================
-- DISPLAY FUNCTIONS
-- ========================================

local function displayResults(gui, data, fromCache)
    -- Clear previous results
    for _, child in ipairs(gui.ResultsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    if not data or type(data) ~= "table" or #data == 0 then
        gui.StatusLabel.Text = "❌ No predictions found"
        gui.StatusLabel.TextColor3 = COLOR_SCHEME.Error
        return
    end

    local totalHeight = 0
    
    for index, item in ipairs(data) do
        local itemFrame = secureCreate("Frame", {
            Size = UDim2.new(1, 0, 0, 75),
            BackgroundColor3 = COLOR_SCHEME.Background,
            BorderSizePixel = 0,
            Parent = gui.ResultsScroll
        })
        
        local itemCorner = secureCreate("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = itemFrame
        })

        local infoContainer = secureCreate("Frame", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            Parent = itemFrame
        })

        -- Header
        local header = secureCreate("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Parent = infoContainer
        })

        local nameLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = tostring(item.Name or "Unknown"),
            TextColor3 = COLOR_SCHEME.TextPrimary,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = header
        })

        local typeLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0.6, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "📦 " .. tostring(item.Type or "Unknown"),
            TextColor3 = COLOR_SCHEME.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = header
        })

        -- Details row
        local details = secureCreate("Frame", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 22),
            BackgroundTransparency = 1,
            Parent = infoContainer
        })

        local stockLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "📊 Stock: " .. tostring(item.Stock or "0"),
            TextColor3 = COLOR_SCHEME.Success,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = details
        })

        local restockLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "⏱️ In: " .. tostring(item.RestockAway or "0") .. " min",
            TextColor3 = COLOR_SCHEME.Warning,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = details
        })

        -- Bottom row
        local bottom = secureCreate("Frame", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 42),
            BackgroundTransparency = 1,
            Parent = infoContainer
        })

        local indexLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.3, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "#" .. tostring(item.Index or "0"),
            TextColor3 = COLOR_SCHEME.TextSecondary,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = bottom
        })

        local timeLabel = secureCreate("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0.3, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "🕐 " .. formatUnixTime(item.Unix or 0),
            TextColor3 = COLOR_SCHEME.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = bottom
        })

        totalHeight = totalHeight + 81
        
        -- Entrance animation
        itemFrame.Position = UDim2.new(0, -400, 0, 0)
        itemFrame.BackgroundTransparency = 1
        
        task.delay(index * 0.05, function()
            if itemFrame and itemFrame.Parent then
                local tween = TweenService:Create(itemFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 0
                })
                tween:Play()
            end
        end)
    end

    gui.ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    local statusText = "✅ Loaded " .. #data .. " predictions"
    if fromCache then
        statusText = statusText .. " (cached)"
    end
    gui.StatusLabel.Text = statusText
    gui.StatusLabel.TextColor3 = COLOR_SCHEME.Success
end

-- ========================================
-- MAIN FUNCTION
-- ========================================

local function main()
    local success, gui = pcall(createCompactGUI)
    
    if not success or not gui then
        warn("Failed to create GUI")
        return
    end

    -- Dragging functionality (with single connection)
    local dragging = false
    local dragInput, dragStart, startPos
    
    trackConnection(gui.MainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.MainContainer.Position
        end
    end))
    
    trackConnection(gui.MainContainer.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end))
    
    trackConnection(game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging and gui.MainContainer and gui.MainContainer.Parent then
            local delta = input.Position - dragStart
            gui.MainContainer.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end))
    
    trackConnection(game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))

    -- Fetch button event (with debounce)
    trackConnection(gui.FetchButton.MouseButton1Click:Connect(function()
        if isFetching then
            gui.StatusLabel.Text = "⏳ Please wait..."
            gui.StatusLabel.TextColor3 = COLOR_SCHEME.Warning
            return
        end
        
        local itemName = gui.ItemInput.Text:gsub("^%s*(.-)%s*$", "%1") -- trim
        local amountText = gui.AmountInput.Text
        
        -- Validate inputs
        local validName, nameResult = validateItemName(itemName)
        if not validName then
            gui.StatusLabel.Text = "⚠️ " .. nameResult
            gui.StatusLabel.TextColor3 = COLOR_SCHEME.Warning
            return
        end
        itemName = nameResult
        
        local validAmount, amountResult = validateAmount(amountText)
        if not validAmount then
            gui.StatusLabel.Text = "⚠️ " .. amountResult
            gui.StatusLabel.TextColor3 = COLOR_SCHEME.Warning
            return
        end
        local amount = amountResult
        
        isFetching = true
        
        -- Show loading state
        gui.StatusLabel.Text = "🔄 Fetching predictions..."
        gui.StatusLabel.TextColor3 = COLOR_SCHEME.Accent
        gui.FetchButton.Text = "⏳ LOADING..."
        
        local loadingSpinner, spinnerConnection = createLoadingSpinner(gui.MainContainer)
        
        -- Fetch data asynchronously
        task.spawn(function()
            local data, error, fromCache = fetchStockPredictions(itemName, amount)
            
            -- Cleanup loading UI
            if loadingSpinner and loadingSpinner.Parent then
                loadingSpinner:Destroy()
            end
            
            isFetching = false
            gui.FetchButton.Text = "🔍 FETCH"
            
            if data then
                displayResults(gui, data, fromCache)
            else
                gui.StatusLabel.Text = "❌ " .. tostring(error or "Unknown error")
                gui.StatusLabel.TextColor3 = COLOR_SCHEME.Error
            end
        end)
    end))
    
    -- Close button event (with cleanup)
    trackConnection(gui.CloseButton.MouseButton1Click:Connect(function()
        cleanupConnections()
        if gui.ScreenGui and gui.ScreenGui.Parent then
            gui.ScreenGui:Destroy()
        end
    end))
    
    -- Auto-cleanup on player leaving
    trackConnection(player.CharacterRemoving:Connect(function()
        cleanupConnections()
    end))
end



local success, err = pcall(main)
if not success then
    warn("Script execution failed: " .. tostring(err))
end

print("✅ Stock Predictions Script Loaded Successfully!")
print("❌ Xeno, Solara, jjsploit is not supported!")
print("❤ Thanks!!!")
