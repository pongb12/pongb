local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function WhKCJWcYTnY(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


--PongbHub--
local validKeys = {
    [WhKCJWcYTnY('MRUYNAOyvRGnCtQvwSwDatjeRXgcPFgdOApzudmTrZhfYGSNvpTAXpQUG9uZ2JodWJzY3JpcHQ=')] = true,
    [WhKCJWcYTnY('GtYUUepcItozFduFwhBJXkVvlvyTzDHAnSEHjNEnnSEdRrjsMZZkYDubWVtYXliZWxs')] = true,
    [WhKCJWcYTnY('TEMmktOHsYsfrpSCVqkJXfubqhvPrkTFkxkigdCcNslPuhBojiSJNXFam9pbm5vdw==')] = true
}

local Players = game:GetService(WhKCJWcYTnY('LIWOFMnJJuwwzPtvHuSlWwmPypttgJNPkeNBffAvKpBPaGKbfPXIQBGUGxheWVycw=='))
local player = Players.LocalPlayer


local gui = Instance.new(WhKCJWcYTnY('vmRmZlBTIuGKbqAszvyHDOLUGSBWaWSZlpuhjykEgxUvKCpyaluOUBPU2NyZWVuR3Vp'), player:WaitForChild(WhKCJWcYTnY('aatNNrCwywBJUIYMkuiOODjoBiPMAeYHMzzRzAFFHcfnFsLJOGQbogGUGxheWVyR3Vp')))
gui.Name = WhKCJWcYTnY('aXnLsZLbLnuhWUzpDVTtdcjedTrUwcOBxqfFKjGAIYcEoczDQqfiWgUS2V5U3lzdGVt')

local frame = Instance.new(WhKCJWcYTnY('bNobEbAbemSzvBSaykaEslqjLekLJkEPnxOmDFasGAsaiAZjMBDEviyRnJhbWU='), gui)
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new(WhKCJWcYTnY('dJHFlcRSuDQlztlTFSonDDXQmOpzsxYTotGEvvGbyhtHmzAwthIhNUAVUlDb3JuZXI='), frame)

local title = Instance.new(WhKCJWcYTnY('gcDuCiOkhOHZufuAZmDlrmPNICdoeHwlOcToXKQOiXWuLVmVOECSqzGVGV4dExhYmVs'), frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = WhKCJWcYTnY('fLsUMTNCJOqdTWASHgMMUFmpNgkbhafcfytmcHGOSeaXZviWsTQILwr8J+UkCBOaOG6rXAgS2V5')
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local box = Instance.new(WhKCJWcYTnY('tPJwmMowTyzrJPCmrMqwUoaSkGnXqokynIhRLoYTHzjRlFJVRZwcZOpVGV4dEJveA=='), frame)
box.Size = UDim2.new(0.8, 0, 0, 30)
box.Position = UDim2.new(0.1, 0, 0.2, 0)
box.PlaceholderText = WhKCJWcYTnY('KLiNFPqbNpeBMKnmUEFXiOmVJAnYwwxCevPUnbKDiPzwIEahgNxiFlVTmjhuq1wIGtleSB04bqhaSDEkcOieS4uLg==')
box.Text = WhKCJWcYTnY('GsgmGldmNgIzEFQPEeXPEbtOpMqldgQGqPShMvvmLoCMvPddbovGJac')
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new(WhKCJWcYTnY('erOCNcggqSAVmQYbyEJlHcpZodtaRXgZNnCJSQXtHeLOrKyDxQspybuVUlDb3JuZXI='), box)

local confirmBtn = Instance.new(WhKCJWcYTnY('bTUAKXHvBAVDRecUQtcltMBWoleNjDFbvDHLeVGPQWMQrcawOaCAaGVVGV4dEJ1dHRvbg=='), frame)
confirmBtn.Size = UDim2.new(0.8, 0, 0, 30)
confirmBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
confirmBtn.Text = WhKCJWcYTnY('qSTpjtGCaqTEkzyKNMxfuWxLHxpYVUiTsRDVgoRXOVfRoYVLruUNaMi4pyFIFjDoWMgbmjhuq1u')
confirmBtn.TextColor3 = Color3.new(1, 1, 1)
confirmBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Instance.new(WhKCJWcYTnY('UQHCzpuELmJeRfvsKwJCHeeQcbkSJJTOxOpQdmAjlmLjAHXDwevoczTVUlDb3JuZXI='), confirmBtn)

local getKeyBtn = Instance.new(WhKCJWcYTnY('aYNgqMuRMxlBmxkUDNvMIDWebDcLFXpJjpFzPkKPuKqCEtJqtVRWpilVGV4dEJ1dHRvbg=='), frame)
getKeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
getKeyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
getKeyBtn.Text = WhKCJWcYTnY('NgIXLxqHDvYZBMYrTgcHRJLvhQOCAteRaqMrcWHEBeGQCpGyKCvXysw8J+UkSBOaOG6rW4ga2V5IHThuqFpIMSRw6J5')
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
Instance.new(WhKCJWcYTnY('fJAlRSRXxsdLoFvNKfotkSFqfoZtVhXWCdsWZhnnfndmbbvDmWHmYfqVUlDb3JuZXI='), getKeyBtn)

local discordBtn = Instance.new(WhKCJWcYTnY('pbKptVkdMuaNOhILldsibnabfQHXOmeAzbQwBzdvDwQYHlHoFexvWrxVGV4dEJ1dHRvbg=='), frame)
discordBtn.Size = UDim2.new(0.8, 0, 0, 30)
discordBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
discordBtn.Text = WhKCJWcYTnY('JQYaFQkFmzYftiAjaVnJfxucsOGUchYAPZCzWWrplqxySrWLhTMfLWp8J+SrCBEaXNjb3Jk')
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
Instance.new(WhKCJWcYTnY('cqPjLNXAvGdjOkIirBqexnfenmeHEYZHTLOtvEdOdoeZIlsotyhgfuWVUlDb3JuZXI='), discordBtn)

local status = Instance.new(WhKCJWcYTnY('rxdOYlraGyjvpuBlvwYjRnHUoqGGEDFtczYVgpCDywvIprHaZOmQwxcVGV4dExhYmVs'), frame)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.88, 0)
status.Text = WhKCJWcYTnY('AcQVaiPMxySagLjFikZQPwWyaLMBzjlEVNVIyjEalZsaxQyrJVcpiZf')
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.BackgroundTransparency = 1
status.TextScaled = true


confirmBtn.MouseButton1Click:Connect(function()
    local key = box.Text
    if key == WhKCJWcYTnY('lAyDXiIQLdEGjdSRhXEYNWlHAVUTPIzXewOtZVnJcmmiKHqZNnIVoHh') then
        status.Text = WhKCJWcYTnY('GXLTMZdChRlBYlOHHdpexJwVQdDgepcLGlyhUDhsUzkXENoMUjxzAcj4pqg77iPIFZ1aSBsw7JuZyBuaOG6rXAga2V5')
        return
    end
    if validKeys[key] then
        status.Text = WhKCJWcYTnY('xfJfaDCugaDFgDhzExnccWjVllHLHslyXHYCvXXgopahgxHcnWNBwwL4pyU77iPIMSQw7puZyBrZXksIMSRYW5nIHThuqNpIHNjcmlwdC4uLg==')
        gui:Destroy()
        loadstring(game:HttpGet(WhKCJWcYTnY('VIPaCxzRAPeInOdTIKZILIeDbqpDNFWQMcLMrajausBjKFPkTKNWfaxaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3BvbmdiMTIvcG9uZ2IvcmVmcy9oZWFkcy9tYWluL1BvbmdiSHViLmx1YQ==')))()
    else
        status.Text = WhKCJWcYTnY('bTCXckZoEGtgxBNNwOtVPvxlpfHOgNXifMFgsqrwdcfjgPjNqghNOQq4p2MIFNhaSBrZXksIHRo4butIGzhuqFpIQ==')
    end
end)


getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(WhKCJWcYTnY('DlkcquNjDDmpXtCGREfmOfbLpYgsPHganxwfOrbQPzXeNSQAQcNSfkjaHR0cHM6Ly93b3JraW5rLm5ldC8yMElwL2NkaTdkZHhz'))
    status.Text = WhKCJWcYTnY('XsIYmaShFZOPxvGvwKnKhjvBqxjcxdrnxpiESDLesfCOhhrIOmoCjLS8J+TiyBMaW5rIG5o4bqtbiBrZXkgxJHDoyBzYW8gY2jDqXAh')
end)


discordBtn.MouseButton1Click:Connect(function()
    setclipboard(WhKCJWcYTnY('UduexzHPjZiGlbcrklFcvTajfrgHBPFXcRusOsYJajqwdIheyXMRmoMaHR0cHM6Ly9kaXNjb3JkLmdnL1ZFUGpXYjU5'))
    status.Text = WhKCJWcYTnY('nqwAxnLCtomNoHTQjBRyKjigsoWmziTQDtlkObBKoayWhpBPTQgXLxD8J+TiyBMaW5rIERpc2NvcmQgxJHDoyBzYW8gY2jDqXAh')
end)    
