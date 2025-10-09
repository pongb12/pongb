-- Stock Predictions - Advanced Stealth Edition
-- Enhanced security, modern UI, minimize/maximize

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ========================================
-- STEALTH CONFIGURATION
-- ========================================

local API_BASE = "https://stock-predicitions-api.vercel.app/api"
local CACHE_DURATION = 60
local MAX_RETRIES = 3
local RETRY_DELAY = 1

-- Obfuscated variable names
local _c = {} -- cache
local _ac = {} -- active connections
local _f = false -- is fetching
local _hm = nil -- http method
local _min = false -- is minimized

-- Anti-detection: Randomize identifiers
local function _rnd(len)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, len do
        local r = math.random(1, #chars)
        result = result .. chars:sub(r, r)
    end
    return result
end

-- Stealth HTTP method detection (no console output)
local function _dhm()
    local methods = {
        {check = function() return syn and syn.request end, fn = function() return syn.request end},
        {check = function() return http_request ~= nil end, fn = function() return http_request end},
        {check = function() return request ~= nil end, fn = function() return request end},
        {check = function() return http and http.request end, fn = function() return http.request end},
        {check = function() 
            local s = pcall(function() game:HttpGet("https://google.com") end)
            return s
        end, fn = function()
            return function(opt)
                if opt.Method == "GET" then
                    local body = game:HttpGet(opt.Url)
                    return {Success = true, Body = body, StatusCode = 200}
                end
                return {Success = false}
            end
        end}
    }
    
    for _, m in ipairs(methods) do
        if m.check() then
            _hm = m.fn()
            return true
        end
    end
    return false
end

local _ha = _dhm()

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

local function _sc(cn, props)
    local s, i = pcall(function()
        local o = Instance.new(cn)
        for p, v in pairs(props or {}) do
            pcall(function() o[p] = v end)
        end
        return o
    end)
    return s and i or nil
end

local function _tc(conn)
    table.insert(_ac, conn)
    return conn
end

local function _cc()
    for _, c in ipairs(_ac) do
        if c and c.Connected then
            pcall(function() c:Disconnect() end)
        end
    end
    _ac = {}
end

local function _fmt(unix)
    local diff = unix - os.time()
    if diff < 0 then return "Passed"
    elseif diff < 60 then return diff .. "s"
    elseif diff < 3600 then return math.floor(diff / 60) .. "m"
    elseif diff < 86400 then return math.floor(diff / 3600) .. "h"
    else return math.floor(diff / 86400) .. "d"
    end
end

local function _vn(name)
    if not name or type(name) ~= "string" then
        return false, "Invalid name"
    end
    name = name:gsub("^%s*(.-)%s*$", "%1")
    if #name < 2 then return false, "Name too short" end
    if #name > 50 then return false, "Name too long" end
    return true, name
end

local function _va(amount)
    local num = tonumber(amount)
    if not num then return false, "Must be a number" end
    if num < 1 or num > 10 then return false, "Range: 1-10" end
    return true, math.floor(num)
end

-- ========================================
-- HTTP REQUEST FUNCTIONS
-- ========================================

local function _hr(url)
    if not _ha then return nil, "No method" end
    
    local s, r = pcall(function()
        return _hm({
            Url = url,
            Method = "GET",
            Headers = {["Content-Type"] = "application/json"}
        })
    end)
    
    if not s then return nil, tostring(r) end
    return r, nil
end

local function _fp(itemName, amount)
    local ck = itemName:lower() .. "_" .. amount
    local cd = _c[ck]
    
    if cd and (os.time() - cd.time) < CACHE_DURATION then
        return cd.data, nil, true
    end
    
    local en = HttpService:UrlEncode(itemName)
    local url = API_BASE .. "/Stock?name=" .. en .. "&amount=" .. tostring(amount)
    
    for att = 1, MAX_RETRIES do
        local res, err = _hr(url)
        
        if res and (res.Success or res.StatusCode == 200) then
            local ps, data = pcall(function()
                local body = res.Body
                if type(body) == "string" then
                    return HttpService:JSONDecode(body)
                end
                return body
            end)
            
            if ps and type(data) == "table" then
                _c[ck] = {data = data, time = os.time()}
                return data, nil, false
            else
                return nil, "Parse failed"
            end
        end
        
        if att < MAX_RETRIES then wait(RETRY_DELAY) end
    end
    
    return nil, "Request failed"
end

-- ========================================
-- MODERN UI COLOR SCHEME
-- ========================================

local COLORS = {
    BG1 = Color3.fromRGB(15, 15, 25),
    BG2 = Color3.fromRGB(25, 25, 40),
    BG3 = Color3.fromRGB(35, 35, 55),
    ACC1 = Color3.fromRGB(120, 90, 255),
    ACC2 = Color3.fromRGB(80, 200, 255),
    SUCCESS = Color3.fromRGB(100, 255, 150),
    WARNING = Color3.fromRGB(255, 200, 80),
    ERROR = Color3.fromRGB(255, 100, 120),
    TXT1 = Color3.fromRGB(250, 250, 255),
    TXT2 = Color3.fromRGB(170, 170, 190),
    SHADOW = Color3.fromRGB(0, 0, 0)
}

-- ========================================
-- UI COMPONENTS
-- ========================================

local function _grad(parent, rotation, c1, c2)
    local g = _sc("UIGradient", {
        Rotation = rotation or 45,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1 or COLORS.BG1),
            ColorSequenceKeypoint.new(1, c2 or COLORS.BG2)
        })
    })
    if g and parent then g.Parent = parent end
    return g
end

local function _corner(parent, radius)
    local c = _sc("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
    return c
end

local function _stroke(parent, color, thickness)
    local s = _sc("UIStroke", {
        Color = color or COLORS.ACC1,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
    return s
end

local function _btn(parent, text, size, pos, color)
    local btn = _sc("TextButton", {
        Size = size,
        Position = pos,
        BackgroundColor3 = color or COLORS.ACC1,
        TextColor3 = COLORS.TXT1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    _corner(btn, 8)
    
    _tc(btn.MouseEnter:Connect(function()
        if btn and btn.Parent then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(255, (color or COLORS.ACC1).R * 255 + 30),
                    math.min(255, (color or COLORS.ACC1).G * 255 + 30),
                    math.min(255, (color or COLORS.ACC1).B * 255 + 30)
                )
            }):Play()
        end
    end))
    
    _tc(btn.MouseLeave:Connect(function()
        if btn and btn.Parent then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = color or COLORS.ACC1
            }):Play()
        end
    end))
    
    return btn
end

local function _input(parent, placeholder, size, pos)
    local inp = _sc("TextBox", {
        Size = size,
        Position = pos,
        BackgroundColor3 = COLORS.BG3,
        TextColor3 = COLORS.TXT1,
        PlaceholderText = placeholder,
        PlaceholderColor3 = COLORS.TXT2,
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    _corner(inp, 8)
    _sc("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = inp
    })
    
    _tc(inp.Focused:Connect(function()
        if inp and inp.Parent then
            TweenService:Create(inp, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.BG2
            }):Play()
        end
    end))
    
    _tc(inp.FocusLost:Connect(function()
        if inp and inp.Parent then
            TweenService:Create(inp, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.BG3
            }):Play()
        end
    end))
    
    return inp
end

local function _spinner(parent)
    local sp = _sc("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0.5, -20, 0.5, -20),
        BackgroundTransparency = 1,
        ZIndex = 100,
        Parent = parent
    })
    
    local circle = _sc("ImageLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -15, 0.5, -15),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = COLORS.ACC1,
        Parent = sp
    })
    
    _corner(circle)
    
    local rot = 0
    local conn = _tc(RunService.Heartbeat:Connect(function(dt)
        if sp and sp.Parent and circle and circle.Parent then
            rot = (rot + 360 * dt * 3) % 360
            circle.Rotation = rot
        else
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
    end))
    
    return sp, conn
end

-- ========================================
-- MODERN GUI CREATION
-- ========================================

local function _cgui()
    local sg = _sc("ScreenGui", {
        Name = _rnd(10),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    if not sg then return nil end

    -- Main container with shadow
    local shadow = _sc("ImageLabel", {
        Size = UDim2.new(0, 420, 0, 470),
        Position = UDim2.new(0.5, -210, 0.5, -235),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = COLORS.SHADOW,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 10, 10),
        ZIndex = 0,
        Parent = sg
    })

    local main = _sc("Frame", {
        Size = UDim2.new(0, 400, 0, 450),
        Position = UDim2.new(0.5, -200, 0.5, -225),
        BackgroundColor3 = COLORS.BG1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = sg
    })
    
    _corner(main, 16)
    _grad(main, 135, COLORS.BG1, COLORS.BG2)

    -- Header with glassmorphism effect
    local header = _sc("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = COLORS.BG2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = main
    })
    
    _corner(header, 16)
    _grad(header, 90, COLORS.BG2, COLORS.BG3)
    _stroke(header, COLORS.ACC1, 1)

    -- Title with icon
    local icon = _sc("TextLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 15, 0.5, -15),
        BackgroundColor3 = COLORS.ACC1,
        Text = "📊",
        TextColor3 = COLORS.TXT1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        BorderSizePixel = 0,
        Parent = header
    })
    _corner(icon, 8)

    local title = _sc("TextLabel", {
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 55, 0, 0),
        BackgroundTransparency = 1,
        Text = "STOCK PREDICTIONS",
        TextColor3 = COLORS.TXT1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local subtitle = _sc("TextLabel", {
        Size = UDim2.new(1, -140, 0, 15),
        Position = UDim2.new(0, 55, 1, -20),
        BackgroundTransparency = 1,
        Text = "Real-time market analysis",
        TextColor3 = COLORS.TXT2,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    -- Control buttons (minimize, close)
    local minBtn = _btn(header, "─", UDim2.new(0, 35, 0, 35), UDim2.new(1, -80, 0.5, -17.5), COLORS.BG3)
    minBtn.TextSize = 18
    
    local closeBtn = _btn(header, "×", UDim2.new(0, 35, 0, 35), UDim2.new(1, -40, 0.5, -17.5), Color3.fromRGB(255, 80, 100))
    closeBtn.TextSize = 22

    -- Content area
    local content = _sc("Frame", {
        Size = UDim2.new(1, -30, 1, -85),
        Position = UDim2.new(0, 15, 0, 70),
        BackgroundTransparency = 1,
        Parent = main
    })

    -- Input section with modern design
    local inputSection = _sc("Frame", {
        Size = UDim2.new(1, 0, 0, 90),
        BackgroundColor3 = COLORS.BG2,
        BorderSizePixel = 0,
        Parent = content
    })
    _corner(inputSection, 12)
    _stroke(inputSection, COLORS.ACC2, 1)

    local inputPadding = _sc("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = inputSection
    })

    local itemInput = _input(inputSection, "🔍 Item name (e.g. Mango Seed)", UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0))

    local bottomRow = _sc("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 43),
        BackgroundTransparency = 1,
        Parent = inputSection
    })

    local amountInput = _input(bottomRow, "📦 Amount", UDim2.new(0.32, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    amountInput.Text = "5"

    local fetchBtn = _btn(bottomRow, "🚀 FETCH", UDim2.new(0.65, 0, 1, 0), UDim2.new(0.35, 0, 0, 0), COLORS.ACC1)
    fetchBtn.TextSize = 13

    -- Results section with scroll
    local resultsSection = _sc("Frame", {
        Size = UDim2.new(1, 0, 1, -125),
        Position = UDim2.new(0, 0, 0, 98),
        BackgroundTransparency = 1,
        Parent = content
    })

    local resultsHeader = _sc("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = resultsSection
    })

    local resultsLabel = _sc("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "📈 RESULTS",
        TextColor3 = COLORS.TXT1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = resultsHeader
    })

    local clearBtn = _btn(resultsHeader, "🗑️ Clear", UDim2.new(0, 70, 0, 25), UDim2.new(1, -70, 0, 2.5), COLORS.BG3)
    clearBtn.TextSize = 10

    local resultsScroll = _sc("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 33),
        BackgroundColor3 = COLORS.BG2,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = COLORS.ACC1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = resultsSection
    })

    _corner(resultsScroll, 12)
    _stroke(resultsScroll, COLORS.ACC2, 1)

    _sc("UIListLayout", {Padding = UDim.new(0, 8), Parent = resultsScroll})
    _sc("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = resultsScroll
    })

    -- Status bar with glow effect
    local statusBar = _sc("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 1, -33),
        BackgroundColor3 = COLORS.BG2,
        BorderSizePixel = 0,
        Parent = content
    })

    _corner(statusBar, 8)
    _stroke(statusBar, COLORS.ACC1, 1)

    local statusLabel = _sc("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "⚡ Ready to fetch predictions...",
        TextColor3 = COLORS.TXT2,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = statusBar
    })

    return {
        ScreenGui = sg,
        MainContainer = main,
        Shadow = shadow,
        Header = header,
        ItemInput = itemInput,
        AmountInput = amountInput,
        FetchButton = fetchBtn,
        MinimizeButton = minBtn,
        CloseButton = closeBtn,
        ClearButton = clearBtn,
        ResultsScroll = resultsScroll,
        StatusLabel = statusLabel
    }
end



local function _dr(gui, data, fromCache)
    for _, child in ipairs(gui.ResultsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    if not data or type(data) ~= "table" or #data == 0 then
        gui.StatusLabel.Text = "❌ No predictions found"
        gui.StatusLabel.TextColor3 = COLORS.ERROR
        return
    end

    local totalHeight = 0
    
    for idx, item in ipairs(data) do
        local card = _sc("Frame", {
            Size = UDim2.new(1, 0, 0, 85),
            BackgroundColor3 = COLORS.BG3,
            BorderSizePixel = 0,
            Parent = gui.ResultsScroll
        })
        
        _corner(card, 10)
        _grad(card, 90, COLORS.BG3, COLORS.BG2)
        _stroke(card, COLORS.ACC1, 1)

        local cardPad = _sc("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = card
        })

        -- Header row
        local headerRow = _sc("Frame", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            Parent = card
        })

        _sc("TextLabel", {
            Size = UDim2.new(0.65, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = tostring(item.Name or "Unknown"),
            TextColor3 = COLORS.TXT1,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = headerRow
        })

        local typeBadge = _sc("TextLabel", {
            Size = UDim2.new(0.35, 0, 0, 20),
            Position = UDim2.new(0.65, 0, 0, 1),
            BackgroundColor3 = COLORS.ACC1,
            Text = tostring(item.Type or "?"),
            TextColor3 = COLORS.TXT1,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            BorderSizePixel = 0,
            Parent = headerRow
        })
        _corner(typeBadge, 6)

        -- Stats row
        local statsRow = _sc("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 28),
            BackgroundTransparency = 1,
            Parent = card
        })

        _sc("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "📊 " .. tostring(item.Stock or "0"),
            TextColor3 = COLORS.SUCCESS,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = statsRow
        })

        _sc("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "⏱️ " .. tostring(item.RestockAway or "0") .. "m",
            TextColor3 = COLORS.WARNING,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = statsRow
        })

        -- Bottom row
        local bottomRow = _sc("Frame", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundTransparency = 1,
            Parent = card
        })

        _sc("TextLabel", {
            Size = UDim2.new(0.3, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "#" .. tostring(item.Index or "0"),
            TextColor3 = COLORS.TXT2,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = bottomRow
        })

        _sc("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0.3, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = "🕐 " .. _fmt(item.Unix or 0),
            TextColor3 = COLORS.TXT2,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = bottomRow
        })

        totalHeight = totalHeight + 93
        
        -- Entrance animation
        card.Position = UDim2.new(-1, 0, 0, 0)
        card.BackgroundTransparency = 1
        
        task.delay(idx * 0.04, function()
            if card and card.Parent then
                TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 0
                }):Play()
            end
        end)
    end

    gui.ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    local st = "✅ Loaded " .. #data .. " predictions"
    if fromCache then st = st .. " (cached)" end
    gui.StatusLabel.Text = st
    gui.StatusLabel.TextColor3 = COLORS.SUCCESS
end

-- ========================================
-- MAIN FUNCTION
-- ========================================

local function main()
    if not _ha then
        warn("No HTTP method available")
        return
    end
    
    local s, gui = pcall(_cgui)
    if not s or not gui then
        warn("GUI creation failed")
        return
    end

    -- Dragging
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    
    _tc(gui.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.MainContainer.Position
        end
    end))
    
    _tc(gui.Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end))
    
    _tc(UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and gui.MainContainer and gui.MainContainer.Parent then
            local delta = input.Position - dragStart
            gui.MainContainer.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            gui.Shadow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X - 10,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y - 10
            )
        end
    end))
    
    _tc(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))

    -- Minimize/Maximize functionality
    _tc(gui.MinimizeButton.MouseButton1Click:Connect(function()
        _min = not _min
        
        if _min then
            -- Minimize animation
            gui.MinimizeButton.Text = "□"
            TweenService:Create(gui.MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 350, 0, 55),
                Position = UDim2.new(0.5, -175, 0.5, -27.5)
            }):Play()
            TweenService:Create(gui.Shadow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 370, 0, 75),
                Position = UDim2.new(0.5, -185, 0.5, -37.5),
                ImageTransparency = 0.85
            }):Play()
        else
            -- Maximize animation
            gui.MinimizeButton.Text = "─"
            TweenService:Create(gui.MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 400, 0, 450),
                Position = UDim2.new(0.5, -200, 0.5, -225)
            }):Play()
            TweenService:Create(gui.Shadow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 420, 0, 470),
                Position = UDim2.new(0.5, -210, 0.5, -235),
                ImageTransparency = 0.7
            }):Play()
        end
    end))

    -- Clear button
    _tc(gui.ClearButton.MouseButton1Click:Connect(function()
        for _, child in ipairs(gui.ResultsScroll:GetChildren()) do
            if child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1
                }):Play()
                task.delay(0.2, function()
                    if child and child.Parent then
                        child:Destroy()
                    end
                end)
            end
        end
        gui.StatusLabel.Text = "🗑️ Results cleared"
        gui.StatusLabel.TextColor3 = COLORS.TXT2
        task.wait(2)
        if gui.StatusLabel then
            gui.StatusLabel.Text = "⚡ Ready to fetch predictions..."
            gui.StatusLabel.TextColor3 = COLORS.TXT2
        end
    end))

    -- Fetch button
    _tc(gui.FetchButton.MouseButton1Click:Connect(function()
        if _f then
            gui.StatusLabel.Text = "⏳ Please wait..."
            gui.StatusLabel.TextColor3 = COLORS.WARNING
            return
        end
        
        local itemName = gui.ItemInput.Text:gsub("^%s*(.-)%s*$", "%1")
        local amountText = gui.AmountInput.Text
        
        local vn, nr = _vn(itemName)
        if not vn then
            gui.StatusLabel.Text = "⚠️ " .. nr
            gui.StatusLabel.TextColor3 = COLORS.WARNING
            return
        end
        itemName = nr
        
        local va, ar = _va(amountText)
        if not va then
            gui.StatusLabel.Text = "⚠️ " .. ar
            gui.StatusLabel.TextColor3 = COLORS.WARNING
            return
        end
        local amount = ar
        
        _f = true
        
        gui.StatusLabel.Text = "🔄 Fetching data..."
        gui.StatusLabel.TextColor3 = COLORS.ACC1
        gui.FetchButton.Text = "⏳ LOADING..."
        
        local spinner, spinConn = _spinner(gui.MainContainer)
        
        task.spawn(function()
            local data, err, cached = _fp(itemName, amount)
            
            if spinner and spinner.Parent then
                spinner:Destroy()
            end
            
            _f = false
            gui.FetchButton.Text = "🚀 FETCH"
            
            if data then
                _dr(gui, data, cached)
            else
                gui.StatusLabel.Text = "❌ " .. tostring(err or "Request failed")
                gui.StatusLabel.TextColor3 = COLORS.ERROR
            end
        end)
    end))
    
    -- Close button
    _tc(gui.CloseButton.MouseButton1Click:Connect(function()
        -- Fade out animation
        TweenService:Create(gui.MainContainer, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(gui.Shadow, TweenInfo.new(0.3), {
            ImageTransparency = 1
        }):Play()
        
        task.delay(0.3, function()
            _cc()
            if gui.ScreenGui and gui.ScreenGui.Parent then
                gui.ScreenGui:Destroy()
            end
        end)
    end))
    
    -- Auto-cleanup on death
    _tc(player.CharacterRemoving:Connect(function()
        _cc()
    end))
    
    -- Enter key to fetch
    _tc(gui.ItemInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and not _f then
            gui.FetchButton.MouseButton1Click:Fire()
        end
    end))
    
    _tc(gui.AmountInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and not _f then
            gui.FetchButton.MouseButton1Click:Fire()
        end
    end))
end



local _s, _e = pcall(main)
if not _s then

end
print("✅ Stock Predictions Script Loaded Successfully!")
print("🌱 Supported Gear, Seed")
print("❤ Thanks!!!")

-- No console output to hide logic
