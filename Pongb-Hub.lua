local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function rEYCWNDkuYxhqSpvcCMNib(data) m=string.sub(data, 0, 321) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


local validKeys = {
    [rEYCWNDkuYxhqSpvcCMNib('WqQGjUqxwqyiJldARwveLXnRaatwLxUYermCBiuFaMJxnaHyhlzhyWxIYqcJezvfPQcoMDMcHPxTlwUwtDHjXsjwYfBxtZjpDVdHjeujvhmPzBItEoLJNeiNBmqLjVzgKLYcstIYVXxdEZQiGyqbYhJNfhyOTJvDuRoKEyupUIosmVTsaIONryCMdMeiwQESeqUXMQxtshaiRckeMkwLVzAbXfuPJcyECkTPippZJFiBvatAwMLNrwVofyLQzeNqajdNdOBtWwAsgQXoNsAiKuETNZMLPiEMcoahrUlfLqegsFrziRfiQxOaGGosTfphuUG9uZ2JodWJzY3JpcHQ=')] = true,
    [rEYCWNDkuYxhqSpvcCMNib('LanYoqGxVtLbgCReqpsomjgtQiUyqLFaiqCwXQSShUkIGjMUACAgjIvGsYeIAeIVhHQuZBrrisOpeXIXviOqLRNJcVhQkyARXFVcjQadwpKFkQRRVUdSzsJiRAaCYOKKCABInRSVyUhxPsdNDeuxXmAVSdGvTUQNDrnkNEXLcHKJkKUJmAewAwMXsfbAkZmPmLOJQPPsAqlTJCpZfYvQCJzhUnpoCSMXSWbPZnkNwQeAJrBtKNglbefOpCiEDpnWmHiROZmcImYKMIwJqRGbBNXbUPsaRjHfmptdYNduzGBbluFprLSUbtBHLoMvXVSAobWVtYXliZWxs')] = true,
    [rEYCWNDkuYxhqSpvcCMNib('GzhZSLVbVXwmbhIhlYfgyxIRARtwAquxfQiRelzIqmeCQLVDlEuWgZtAdbEdPwnoZUwaLOpippnLlQgsFcqenEYeFFFKHotuaIbhuUiBgDKbysPZCJxncOxFuwvrrlWETWIdyvAGtyNfrigIjfYXvFYcmrRmlUrlyqpMBhOorrGyQbCtdVBKRififQRKgOyIXVASpIiFNmCDyWWJTXMRtHjMzFlnpBRvnMnxLyUsurjsLcqHnstHnUdNCRjWQxKlepdroYSdhOqzFWBsCndIslmzgssGouUsooXQptDMuOLtzyXSHWNsRJjfzrmcZMpGFam9pbm5vdw==')] = true
}

local Players = game:GetService(rEYCWNDkuYxhqSpvcCMNib('pUcwYPBWKeFCEcnaIwQtFNEXPNEmeGzgJLXPxTdAoGPVNjejojhUglwhXTqCdZPaHRUtoHPEatfhiXblXfyOMdRKcUVZntNlrfQybGybarfBCOpoBxzGeYiMliIplwyoBIviszcreixjxwihiTWrMoYuCEEvCNGBgswGUyrXIOPQIYnmRfOwFCGHjcLbKupMtidJHapCGiPjVDDkphOGewYppjqHKmHnxkPhAHiBgzHnMsmCywfJuVHBRqpkNeqElpWCwHSwxwCPtaEznYbKwVBeTqtMjmtUMZxxyNzSsXkmSNKArPnBNsfoIpLRLKsNJUGxheWVycw=='))
local player = Players.LocalPlayer

local gui = Instance.new(rEYCWNDkuYxhqSpvcCMNib('fnYKjYpiDnZnNPRohlHFoijYFQEZjoAbAPKrASkkshMQpDFdVtWsTGALylPxejgvbtLMeHNaOhlvLwDbFZZLGuvgCrAiUwEZYQfXjrkZenbypeRkDWUlipeJcnyrfPCaBlHtyzfBfEqPMkOCJHuFQqvNKRRgRVTDERejTFEtMWxdBrwelgoWriviZVgVIBtUtgvRrKwUBRrQAhHMjFrFxJsfnmUeYbADXIwcITdLwsdlwiRMXTQpBpWyVsWjQoypnRTiWeAexxBJlGajoVYTPtwUrsoouzCmyNtTdlUyKOKzIjBbTNKWDrgJTJYpKREpyU2NyZWVuR3Vp'), player:WaitForChild(rEYCWNDkuYxhqSpvcCMNib('EAAruHHYxWOIUqroIcOEZaZhLCHNIGBEKjNbQgndrBSJAbDRriWionBIwtmaKqXWoidcmxTkSskVOjLnrsXhmWSnsZuRHJtgObOfWefggQaiIjdoTpGzjJqoEfzdMqbmLHrCDwEnHbQjWTuGPAlXsnltLUnQgQtCTYNkCfchcqHKoQOKbwcbgTpZPloQPFsppGZNDjDZIEAWCuaQAVThhNIsbdZnBXRyTDHZmtKKvwaRHYrveGtpeHHgWmahFcwYlaMRgSBUAHPRbangWjGQJHvbCIBfCmKFwgrHYcXkyKqkjzGpBOnsnAgXgFsilDrGPUGxheWVyR3Vp')))
gui.Name = rEYCWNDkuYxhqSpvcCMNib('kCWZbbaiREDiVbxFJTSdHWFFqifOTwDLvkXEcZSKIVBhdLTxHBudIyrYfDzCfKwPGpmwuQCIKSMXqSHoGlUfcspdYwwmQcYPbScQkDRWRyVsdTwOxFJgBxLHgHSRVgqBUTKpPyuAKqWABdkfRhxnlwDuiMKMYGycsFklexZEMkUpcnTDtUQvfNAXZLMRaIHvKJWqyvhDVHJSzPrziVVkBPVuRKQlwngyhxPBxlktOsSuYoRMzPTfPJINtLpsKoyzxhnygdiJKQBpJDLvmBKjnVyPiVufmCgXUYrwKtJssOniJDFkcOsqnAHvVIyIgEWGDUG9uZ2JLZXlVSQ==')
gui.ResetOnSpawn = false

local frame = Instance.new(rEYCWNDkuYxhqSpvcCMNib('MxIJpwJOZQBXlURCwptmLVOLuAwYAGRKrhodgtzwxapMFHeOCPcTInQexTpebYRDfmmYttMKqYVzcjoJhSSzdRTjmvFaOoOUvfJIUFfZLrkELFCJdswiLCPHXtHJqSMFcgQGEetxouEagkcOBGgwkOqcCbQJwukCUySryxwJOGvLRScFZXUVvnORDfWmPsaAvugjpYPUnBzTQOjlNgfxkhCKlKEcHVZoKTcFieTtnewieyiORuJXNbaEZuXtEqyfyVaHnFCzgrImXjtbvgbmQPrpcsMgPnNBpoGYJfXsMpeQghbmZewFlwEhTfPOSvkReRnJhbWU='))
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui

Instance.new(rEYCWNDkuYxhqSpvcCMNib('FBcDAGOfLNpCJmvTsYkDpdiqRnwvnciVaKcvJhEagdajfFBQXZmGVrQYpNbtwcRDBpDcWLeQUztLtffvoUHSalcOeWqCasuyBaBBTjkiEOJsmwONeBxOBuyiRNlkfPkYlEFTTOmHbVCwiMGrPEhHIfFLjsLUHwijFrOGMjtyjIqMDXYFfZVEgpTpLqfowytpmNAMZBztdsQZHbLyqgiqIxtreYsdEUJJPgIxNrNHLLIHQhyzwECCRGCqOGEtZSuCTfZEhxVkeGnUUZjDmUSGHvVxWCxAqxOtjbCdZVCwOfSWrWAMajAbEwyBqomwBAQyPVUlDb3JuZXI='), frame)    

local function newTextLabel(text, posY, sizeY, color)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, sizeY)
    lbl.Position = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    return lbl
end

newTextLabel("🔐 Nhập Key", 0, 30)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 30)
box.Position = UDim2.new(0.1, 0, 0.2, 0)
box.PlaceholderText = "Nhập key tại đây..."
box.Text = ""
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", box)

local function newButton(text, posY, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = UDim2.new(0.1, 0, posY, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color
    Instance.new("UICorner", btn)
    return btn
end

local confirmBtn = newButton("✅ Xác nhận", 0.4, Color3.fromRGB(70, 130, 180))
local getKeyBtn = newButton("🔑 Nhận key tại đây", 0.55, Color3.fromRGB(0, 200, 120))
local discordBtn = newButton("💬 Discord", 0.7, Color3.fromRGB(114, 137, 218))

local status = newTextLabel("", 0.88, 20, Color3.fromRGB(0, 0, 0))
status.BackgroundTransparency = 1
status.TextScaled = true
status.TextColor3 = Color3.fromRGB(255, 80, 80)

-- Xử lý sự kiện
function LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP(code)res=''for i in ipairs(code)do res=res..string.char(code[i]/432)end return res end 


confirmBtn.MouseButton1Click:Connect(function()
    local key = box.Text
    if key == LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP({}) then
        status.Text = LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP({97632,66528,69120,103248,79488,61776,13824,37152,50544,45360,13824,46656,84240,76896,47520,44496,13824,47520,44928,97200,80352,74736,48384,13824,46224,43632,52272})
        return
    end
    if validKeys[key] then
        status.Text = LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP({97632,67392,63936,103248,79488,61776,13824,84672,62208,84240,80352,47520,44496,13824,46224,43632,52272,19008,13824,84672,62640,41904,47520,44496,13824,50112,97200,80352,70416,45360,13824,49680,42768,49248,45360,48384,50112,19872,19872,19872})
        gui:Destroy()
        loadstring(game:HttpGet(LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP({44928,50112,50112,48384,49680,25056,20304,20304,49248,41904,51408,19872,44496,45360,50112,44928,50544,42336,50544,49680,43632,49248,42768,47952,47520,50112,43632,47520,50112,19872,42768,47952,47088,20304,48384,47952,47520,44496,42336,21168,21600,20304,48384,47952,47520,44496,42336,20304,49248,43632,44064,49680,20304,44928,43632,41904,43200,49680,20304,47088,41904,45360,47520,20304,34560,47952,47520,44496,42336,31104,50544,42336,19872,46656,50544,41904})))()
    else
        status.Text = LFzgeWVNumQYJTKZzhRfaMYKbVeaZDXAqHjfaCwwP({97632,67824,60480,13824,35856,41904,45360,13824,46224,43632,52272,19008,13824,50112,44928,97200,80784,74736,13824,46656,97200,80352,69552,45360,14256})
    end
end)    

getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://workink.net/20Ip/cdi7ddxs")
    status.Text = "📋 Link nhận key đã sao chép!"
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/VEPjWb59")
    status.Text = "📋 Link Discord đã sao chép!"
end)

gui.Parent = player:WaitForChild("PlayerGui")
