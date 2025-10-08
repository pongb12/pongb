-- Stock Predictions API Script for Executor
-- Plants Vs Brainrot Stock Predictions - Premium Version

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Anti-detection measures
local function secureCreate(className, properties)
    local success, instance = pcall(function()
        local obj = Instance.new(className)
        for prop, value in pairs(properties) do
            pcall(function()
                obj[prop] = value
            end)
        end
        return obj
    end)
    return success and instance or nil
end

-- API Configuration với fallback
local API_BASE = "https://stock-predicitions-api.vercel.app/api"
local BACKUP_API = "https://stock-predicitions-api.vercel.app/api"

-- Mã hóa tên instance để tránh detection
local function getObfuscatedName(baseName)
    local prefixes = {"UI", "Frame", "Container", "Display", "View"}
    local suffixes = {"Manager", "Handler", "Controller", "Interface"}
    local randomId = math.random(1000, 9999)
    return prefixes[math.random(1, #prefixes)] .. suffixes[math.random(1, #suffixes)] .. randomId
end

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

-- Tạo gradient background đẹp
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
end

-- Tạo hiệu ứng shadow
local function createShadow(frame)
    local shadow = secureCreate("Frame", {
        Size = frame.Size + UDim2.new(0, 10, 0, 10),
        Position = frame.Position + UDim2.new(0, -5, 0, -5),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = frame.ZIndex - 1
    })
    return shadow
end

-- Tạo button với hiệu ứng hover
local function createModernButton(parent, text, size, position)
    local buttonContainer = secureCreate("Frame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local shadow = createShadow(buttonContainer)
    if shadow then shadow.Parent = parent end
    
    local button = secureCreate("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLOR_SCHEME.Accent,
        TextColor3 = COLOR_SCHEME.TextPrimary,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = buttonContainer
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = button
    })
    
    -- Hiệu ứng hover
    button.MouseEnter:Connect(function()
        if button then
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            })
            tween:Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button then
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = COLOR_SCHEME.Accent
            })
            tween:Play()
        end
    end)
    
    -- Hiệu ứng click
    button.MouseButton1Down:Connect(function()
        if button then
            local tween = TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(0, 130, 215),
                Size = UDim2.new(0.95, 0, 0.95, 0),
                Position = UDim2.new(0.025, 0, 0.025, 0)
            })
            tween:Play()
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        if button then
            local tween = TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(0, 150, 255),
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0)
            })
            tween:Play()
        end
    end)
    
    return button
end

-- Tạo input field hiện đại
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
        TextSize = 14,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        Parent = container
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = input
    })
    
    local padding = secureCreate("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = input
    })
    
    -- Hiệu ứng focus
    input.Focused:Connect(function()
        if input then
            local tween = TweenService:Create(input, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            })
            tween:Play()
        end
    end)
    
    input.FocusLost:Connect(function()
        if input then
            local tween = TweenService:Create(input, TweenInfo.new(0.2), {
                BackgroundColor3 = COLOR_SCHEME.Secondary
            })
            tween:Play()
        end
    end)
    
    return input
end

-- Tạo loading animation
local function createLoadingSpinner(parent)
    local spinner = secureCreate("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0.5, -20, 0.5, -20),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local circle = secureCreate("Frame", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -15, 0.5, -15),
        BackgroundColor3 = COLOR_SCHEME.Accent,
        BorderSizePixel = 0,
        Parent = spinner
    })
    
    local corner = secureCreate("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = circle
    })
    
    local rotation = 0
    local connection
    connection = RunService.Heartbeat:Connect(function(delta)
        if spinner and circle then
            rotation = (rotation + 360 * delta) % 360
            circle.Rotation = rotation
        else
            connection:Disconnect()
        end
    end)
    
    return spinner, connection
end

-- Custom GUI Creation với anti-detection
local function createPremiumGUI()
    -- Tạo ScreenGui ẩn danh
    local screenGui = secureCreate("ScreenGui", {
        Name = getObfuscatedName("MainGUI"),
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    if not screenGui then return nil end

    -- Main Container
    local mainContainer = secureCreate("Frame", {
        Size = UDim2.new(0, 450, 0, 600),
        Position = UDim2.new(0.5, -225, 0.5, -300),
        BackgroundColor3 = COLOR_SCHEME.Background,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    
    createGradient(mainContainer)
    
    local mainCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainContainer
    })

    -- Header với gradient
    local header = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
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
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = "🌱 STOCK PREDICTIONS",
        TextColor3 = COLOR_SCHEME.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    -- Close button
    local closeBtn = createModernButton(header, "×", UDim2.new(0, 40, 0, 40), UDim2.new(1, -50, 0.5, -20))

    -- Content area
    local content = secureCreate("Frame", {
        Size = UDim2.new(1, -40, 1, -120),
        Position = UDim2.new(0, 20, 0, 90),
        BackgroundTransparency = 1,
        Parent = mainContainer
    })

    -- Input section
    local inputSection = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundTransparency = 1,
        Parent = content
    })

    -- Item input
    local itemInput = createModernInput(inputSection, "Enter item name (e.g., Mango Seed)", UDim2.new(1, 0, 0, 45), UDim2.new(0, 0, 0, 0))

    -- Amount input và fetch button container
    local bottomRow = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = inputSection
    })

    local amountInput = createModernInput(bottomRow, "Amount (1-10)", UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    amountInput.Text = "5"

    local fetchBtn = createModernButton(bottomRow, "🔍 FETCH PREDICTIONS", UDim2.new(0.55, 0, 1, 0), UDim2.new(0.45, 0, 0, 0))

    -- Results section
    local resultsSection = secureCreate("Frame", {
        Size = UDim2.new(1, 0, 1, -140),
        Position = UDim2.new(0, 0, 0, 130),
        BackgroundTransparency = 1,
        Parent = content
    })

    local resultsLabel = secureCreate("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "PREDICTION RESULTS",
        TextColor3 = COLOR_SCHEME.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = resultsSection
    })

    local resultsScroll = secureCreate("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = resultsSection
    })

    local scrollCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = resultsScroll
    })

    local resultsList = secureCreate("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = resultsScroll
    })

    local padding = secureCreate("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = resultsScroll
    })

    -- Status bar
    local statusBar = secureCreate("Frame", {
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 1, -40),
        BackgroundColor3 = COLOR_SCHEME.Secondary,
        BorderSizePixel = 0,
        Parent = mainContainer
    })

    local statusCorner = secureCreate("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = statusBar
    })

    local statusLabel = secureCreate("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Ready to fetch stock predictions...",
        TextColor3 = COLOR_SCHEME.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
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

-- API Call function với retry mechanism
local function fetchStockPredictions(itemName, amount)
    local encodedName = HttpService:UrlEncode(itemName)
    local url = API_BASE .. "/Stock?name=" .. encodedName .. "&amount=" .. tostring(math.clamp(amount, 1, 10))
    
    local success, result = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    
    if not success then
        -- Thử backup API
        url = BACKUP_API .. "/Stock?name=" .. encodedName .. "&amount=" .. tostring(math.clamp(amount, 1, 10))
        success, result = pcall(function()
            return HttpService:GetAsync(url, true)
        end)
    end
    
    if success then
        local data = HttpService:JSONDecode(result)
        return data
    else
        return nil, "Network error: " .. tostring(result)
    end
end

-- Hiển thị kết quả với animation
local function displayResults(gui, data)
    -- Clear previous results
    for _, child in ipairs(gui.ResultsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    if not data or type(data) ~= "table" or #data == 0 then
        gui.StatusLabel.Text = "❌ No predictions found for this item"
        gui.StatusLabel.TextColor3 = COLOR_SCHEME.Error
        return
    end

    local totalHeight = 0
    
    for index, item in ipairs(data) do
        local itemFrame = secureCreate("Frame", {
            Size = UDim2.new(1, -20, 0, 80),
            BackgroundColor3 = COLOR_SCHEME.Background,
            BorderSizePixel = 0,
            Parent = gui.ResultsScroll
        })
        
        local itemCorner = secureCreate("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = itemFrame
        })

        local itemPadding = secureCreate("UIPadding", {
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = itemFrame
        })

        -- Item icon và name
        local header = secureCreate("Frame", {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Parent = itemFrame
        })

        local icon = secureCreate("TextLabel", {
            Size = UDim2.new(0, 25, 0, 25),
            BackgroundTransparency = 1,
            Text = "📈",
            TextColor3 = COLOR_SCHEME.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Parent = header
        })

        local nameLabel = secureCreate("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(item.name or "Unknown Item"),
            TextColor3 = COLOR_SCHEME.TextPrimary,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = header
        })

        -- Prediction info
        local predictionText = secureCreate("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = "Prediction: " .. tostring(item.prediction or "Analyzing..."),
            TextColor3 = COLOR_SCHEME.Success,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemFrame
        })

        -- Additional info
        local infoText = secureCreate("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundTransparency = 1,
            TextColor3 = COLOR_SCHEME.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemFrame
        })

        if item.confidence then
            infoText.Text = "Confidence: " .. tostring(item.confidence) .. "%"
        elseif item.price then
            infoText.Text = "Estimated Price: " .. tostring(item.price)
        else
            infoText.Text = "Market Analysis: Active"
        end

        totalHeight = totalHeight + 90
        
        -- Animation entrance
        itemFrame.Position = UDim2.new(0, 0, 0, (index-1)*90)
        itemFrame.BackgroundTransparency = 1
        
        delay((index-1)*0.1, function()
            if itemFrame then
                local tween = TweenService:Create(itemFrame, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0
                })
                tween:Play()
            end
        end)
    end

    gui.ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    gui.StatusLabel.Text = "✅ Successfully loaded " .. #data .. " predictions"
    gui.StatusLabel.TextColor3 = COLOR_SCHEME.Success
end

-- Main execution với error handling
local function main()
    local success, gui = pcall(createPremiumGUI)
    
    if not success or not gui then
        warn("Failed to create GUI - Anti-detection may be active")
        return
    end

    -- Make GUI draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    gui.MainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.MainContainer.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging and gui.MainContainer then
            local delta = input.Position - dragStart
            gui.MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Fetch button event
    gui.FetchButton.MouseButton1Click:Connect(function()
        local itemName = gui.ItemInput.Text
        local amount = tonumber(gui.AmountInput.Text) or 5
        
        if itemName == "" then
            gui.StatusLabel.Text = "⚠️ Please enter an item name"
            gui.StatusLabel.TextColor3 = COLOR_SCHEME.Warning
            return
        end
        
        if amount < 1 or amount > 10 then
            gui.StatusLabel.Text = "⚠️ Amount must be between 1-10"
            gui.StatusLabel.TextColor3 = COLOR_SCHEME.Warning
            return
        end
        
        -- Show loading state
        gui.StatusLabel.Text = "🔄 Fetching predictions..."
        gui.StatusLabel.TextColor3 = COLOR_SCHEME.Accent
        gui.FetchButton.Text = "LOADING..."
        
        local loadingSpinner, connection = createLoadingSpinner(gui.MainContainer)
        
        -- Fetch data asynchronously
        spawn(function()
            local data, error = fetchStockPredictions(itemName, amount)
            
            if loadingSpinner then
                loadingSpinner:Destroy()
            end
            if connection then
                connection:Disconnect()
            end
            
            gui.FetchButton.Text = "🔍 FETCH PREDICTIONS"
            
            if data then
                displayResults(gui, data)
            else
                gui.StatusLabel.Text = "❌ " .. tostring(error)
                gui.StatusLabel.TextColor3 = COLOR_SCHEME.Error
            end
        end)
    end)
    
    -- Close button event
    gui.CloseButton.MouseButton1Click:Connect(function()
        if gui.ScreenGui then
            gui.ScreenGui:Destroy()
        end
    end)
end

-- Khởi chạy an toàn
local success, err = pcall(main)
if not success then
    warn("Script execution failed: " .. tostring(err))
end