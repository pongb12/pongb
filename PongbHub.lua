local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


--PongbHub--
--Script by Pongb team--
local Players = game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('zSfgsHMNLiRtHgcVcIkJUCXTrRlaxFkPmOfIFQiGWxXqZbGZJpuBeceUGxheWVycw=='))
local TweenService = game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('TojJcCVhVlBUDLEAwUNgWTGhpPqXnBffSFQEGESBrwIxqRhhEvyNUDvVHdlZW5TZXJ2aWNl'))
local TeleportService = game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('DDZSmXTTzfkRgozCnqekRljzoxhsOBWZrMrAUlzZdlvPXbOvDNJsMPLVGVsZXBvcnRTZXJ2aWNl'))
local UserInputService = game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('dLYYDhHTZBCjAilcCniTbGEVPgfOsUGDDOSvqroEcHECZfGHPPvcvzXVXNlcklucHV0U2VydmljZQ=='))
local RunService = game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('JBgdhuEtMkhhSFRouBtbWttsSGsfOarywNkSXpRShotuXgXaYiwJkVGUnVuU2VydmljZQ=='))

local player = Players.LocalPlayer
local gui = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('GOorlYqMaBRSXwTGBOpIqoGffiSCiUzkHDjLbEeOjTsIkGikJgNaYGIU2NyZWVuR3Vp'), player:WaitForChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('lMWNIOeAkGMnZwRrEZEiKkWLtYTrmNFgAApLqgCyOjSrHIYUpzfIvoYUGxheWVyR3Vp')))
gui.Name = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('fihqMBzBpyKrGTvzcNWhBQZyrNDfbjFKeBCgphXobBCbtsPGHzrgetMVUlfTWFpbg==')
gui.ResetOnSpawn = false


local lang = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('EMWLiUeacARFtFYXZxUYbHnYNxIdKJdVyTuGBxLxcDfnOBLXpDYVEcndmk=')
local texts = {
    vi = {
        Title = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('VUWlClmHZfEdQqTmqKkNAHImQNBqicPRdRPlMxPPdDRicbqMeKxaHpVUG9uZ2JIdWI='),
        SaveCP = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('NOXnQTKZqNQrEnIzZrMwUBVSXTeojUQGnDqInxcrFpVxvkRwBnenaezTMawdSBDaGVja3BvaW50'),
        TeleCP = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('HspNGEbkSlcvmfJciRGozvdHyRnrFclSIDeVJbNuoEJwXDaXHDqPFVcVuG7gSBDaGVja3BvaW50'),
        AutoSteal = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('jYAhypuumrExqxfUckMrNJulyYtuSbvdZuGkRXjBeTdSivNgUJCheUzQXV0byBTdGVhbA=='),
        Rejoin = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('MbINoOdMVgdqSkkerEwZXolUiICunJgJjHUODSZqNrOYJICmSNYJYrSVsOgbyBs4bqhaSBzZXJ2ZXI='),
        Hop = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('isjHPRTMXhiHruugrTdVkEIFaAAOxtRiukEYAhyVZyZgSowRkmrsVbxSG9wIFNlcnZlcg=='),
        Join = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('oOEVcLCCTGOJsrCdLNSHXwtojsNYWdomWWrJSRtdzrPOdswMqJGiLimSm9pbiBKb2IgSUQ='),
        DeleteGUI = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('lLuCOYffpTifpTJALVwNBZUTDNsPKgNvPfbbcRNgpyIXpERQLMnDyRtWG/DoSBHVUk='),
        LangSwitch = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('XhJwHEkrOJQkIerFtWUujsbTZnSYasfIiWYjOtKDsFheQONWrODDPPpTmfDtG4gbmfhu686IFZp4buHdC9Bbmg='),
        JobPlaceholder = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('QRvNyGEpjCefSENkSsJqFDMECDdwkANuoZenUkYaeNiFAGXExmsmMXUTmjhuq1wIEpvYiBJRA=='),
        WalkSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('vXnxilETWsdNQuvHaiWzaWYqdEPjNtICkMjXgYMEfQDvEBFjtvupKErVOG7kWMgxJHhu5kgZGkgY2h1eeG7g24='),
        SaveConfig = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('KhbziJDFubuayjmmlgCZbneycCtSnkdFyccFgNwNvUxqklfaplXlcyQTMawdSBj4bqldSBow6xuaA=='),
        ResetConfig = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('iuxwJHaIiqvYKbtwuKRZALjFnUIiIyDItZIGcowAFXIWDpRNRSJeJEexJDhurd0IGzhuqFpIGPhuqV1IGjDrG5o'),
        NoClip = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('fMqkQCdeCQnZgtqVVTzdLWtOgetLrTtGtJCWhahmuFEqoQhmRozRKajWHV5w6puIHLDoG8gY+G6o24='),
        ConfigSaved = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('pQctSQWBiBAStYjubpmLUzWfNvXtvwCDlilOPefJStJkRGQKVTlaCRoxJDDoyBsxrB1IGPhuqV1IGjDrG5oIQ=='),
        ConfigReset = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('DObOMWsDjFMMZpFLUAQwMhJnKIqBaRuecqShVvRuDElYjDOdsQmPVspxJDDoyDEkeG6t3QgbOG6oWkgY+G6pXUgaMOsbmgh'),
        CPSaved = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('TuigcDIkqRLsNxcOaZfIWNXYmJNogwUIDPGZxQKJkspEZfMJibuVFxgxJDDoyBsxrB1IGNoZWNrcG9pbnQh'),
        CPTeled = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('SIFsCfFpSYumjrBFVCvANuXZTMmUeMyJjxFjAajbHWQvxOJqwlzDXPwxJDDoyBk4buLY2ggY2h1eeG7g24gxJHhur9uIGNoZWNrcG9pbnQh'),
        ZoomGUI = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('oqdFZpDUIpiGNdpbZxDjpysTbZcVfoVQINSGLfDericxDAtlFXiLUuf8J+Xlg=='),
        Shortcuts = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('XoWdFhyNmnBfPlEHxJqeUyScqFScSGTTmcjtQupuCkAyxArnGpADmZnUGjDrW0gdOG6r3Q6'),
        ShortcutList = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('TbEpmcvzinxtwIGhNvELMDPvovrGuEenlfQXspOkVfPWFooclFLGPPvRjE6IOG6qG4vaGnhu4duIEdVSVxuRjI6IFBow7NuZyB0by90aHUgbmjhu49cbkY0OiDhuqhuIGto4bqpbiBj4bqlcFxuU2hpZnQgcGjhuqNpOiDhuqhuL2hp4buHbiBHVUk='),
        CurrentSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('mcnEqmIIAEtRXZEfmwcDeOemJStHQEpxWYeCtoaqHgUVUMXXTMelLZGVOG7kWMgxJHhu5kgaGnhu4duIHThuqFpOiA='),
        SetSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('GcjdcbtfXIRbOcEkDyFcwIxGuzudlBrvNBRezMfrvgzTZIShAypFDOlw4FwIGThu6VuZyB04buRYyDEkeG7mQ=='),
        SpeedUpdated = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('WArNgJubebMLKattBYLJVDyNnxlLISXQMWipFEBoHoObRYyVzdZtNebxJDDoyDEkeG6t3QgdOG7kWMgxJHhu5kgdGjDoG5oOiA=')
    },
    en = {
        Title = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('LhFgtIMHaMXmpCsWCqBCYLNhscqRwMFEWmaQrnQLnzbLkqSIogiFTisUG9uZ2JIdWI='),
        SaveCP = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hnEoSLEIIuJSJEPWrNAQXbxuELwnbaUJfkSPyCGfROfVvLumLHQhTbBU2F2ZSBDaGVja3BvaW50'),
        TeleCP = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('uYfQbJhKeAQkiYTDYKwRmNPqACJzTwUToLvufHGUikPjQoAakWSawRXR28gdG8gQ2hlY2twb2ludA=='),
        AutoSteal = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('bKQaOoYECHgahZtywBzywvJkRLmOiOanNKYLrRYvAeCRERfsdfKEFKUQXV0byBTdGVhbA=='),
        Rejoin = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('rNyBrBeiTzTBejSwdZCbRjXxPvOSoJkjugfbAgflFJHkKtomkAyKxYrUmVqb2luIFNlcnZlcg=='),
        Hop = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('eULjARDQvRaLbOfqmRIymhDWapHjCxXsrMQlcFvjmpnfuVcwKksBiqISG9wIFNlcnZlcg=='),
        Join = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('KRvHUbbuBpYmzUFvAxsMyvyGFHngBYyLymqLQstVRkAqAfMVlFgUxPrSm9pbiBKb2IgSUQ='),
        DeleteGUI = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('WmnUFpEHLpBRBiSNRcljOOeEBtjSvFvMHVxlVkSXWRVhEoEqVgWXwPdRGVsZXRlIEdVSQ=='),
        LangSwitch = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('BhdalFEmwFVbnHzDWMBeGJtRpFSUlrLKvZUgMLmRebXAvvhQQIqwMUlTGFuZ3VhZ2U6IEVOL1ZO'),
        JobPlaceholder = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('XsPwHoXqoCixmHMsOwPglBOUDAuBnostZCgrqUjqEBulExOYRUshvCaRW50ZXIgSm9iIElE'),
        WalkSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('FAqmGzvfifXKUzcXBOQsYCRaHQAzjNrWJNzeNCJjyTKHbTkKUVhZHIVV2FsayBTcGVlZA=='),
        SaveConfig = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('kNALDphvLcQxXNTfOfeSMeBdmXBnTNsSJzwqxmapWIDJKXsKcaqxqVzU2F2ZSBDb25maWc='),
        ResetConfig = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('urfvODXMDonQSZWrvuZBbhPTqIpLyXPcPuUimIMldyGtEBGUcrqsEtbUmVzZXQgQ29uZmln'),
        NoClip = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('lieZNOSTKoEkxIykGXlbGZuYezSsCudQuAIOKqTWJBGQngqSSlBWpXdTm9DbGlw'),
        ConfigSaved = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ZSkjHzagCpMfYRjuUMOfdscOrAngVzLtbzYkDZfRrjlJsPzANHfFyCHQ29uZmlnIHNhdmVkIQ=='),
        ConfigReset = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('JvCHcBGiwOubFghaBUXckGFduhbrSqxyOORyaqPvEJWDHtZAqOSFnaBQ29uZmlnIHJlc2V0IQ=='),
        CPSaved = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('koKDcMPXVqHOqwuCsAKlSwFIRWkvLFQZuetCNeOolodJXSpzyBlHhnGQ2hlY2twb2ludCBzYXZlZCE='),
        CPTeled = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('CWhsEynZBNrYgXBJGXelqEkZSAWJMswLpTAwymEYdSraEuRypDIZfOxVGVsZXBvcnRlZCB0byBjaGVja3BvaW50IQ=='),
        ZoomGUI = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('wqAhHrBFEWHOKAGKtdjxkKZjpvLkXGJNbQFBTNaUeBdbOXNQvJsoaDF8J+Xlg=='),
        Shortcuts = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('rCfRBMJfnahyTKERooXqqtGyVLfxWHCgHkFPmbWiBFLWasYMJJuLCEiU2hvcnRjdXRzOg=='),
        ShortcutList = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('uKSxeRdaXQljokxkjKlRWviXOSAVHBRymqGFkPiIEKBoHeJeaCtTckBRjE6IFRvZ2dsZSBHVUlcbkYyOiBab29tIEdVSVxuRjQ6IEVtZXJnZW5jeSBoaWRlXG5SaWdodCBTaGlmdDogVG9nZ2xlIEdVSQ=='),
        CurrentSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hzaEVzcEMBjbKeWLirXdMisEjwLXkBZCAnCuejQvIEAcyCKbBLEeqGnQ3VycmVudCBzcGVlZDog'),
        SetSpeed = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('CpKKrZXzgIIqYOgNqWJWZUQYFqhtWkJvwplXafJizQaADfXPZiVWzJpQXBwbHkgU3BlZWQ='),
        SpeedUpdated = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('AuZOVGLwdagKWlwERptDikdjjSrJVdDtQCkXCJzxDqmXnOeCYxolqUqU3BlZWQgc2V0IHRvOiA=')
    }
}


local cp
local autoStealActive = false
local noClipActive = false
local walkSpeed = 16
local baseWalkSpeed = 16
local isGUIMaximized = false


local originalGUISize = UDim2.new(0, 550, 0, 380)
local originalGUIPosition = UDim2.new(0.5, -275, 0.5, -190)
local maximizedGUISize = UDim2.new(0, 700, 0, 500)
local maximizedGUIPosition = UDim2.new(0.5, -350, 0.5, -250)


local main = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('FWSMMHQgkwWRmlHfLWBYemmrLPoXZSvEcUbJYwqObiirWPPPsvmVnsWRnJhbWU='), gui)
main.Size = originalGUISize
main.Position = originalGUIPosition
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
main.Visible = true

local corner = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('uwXpSuGrbdTFAneGiKKvuEFCfqwCREBgnuerNLCPwcTxETZqFqWMEKaVUlDb3JuZXI='), main)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('WRWNECWLPTpQfYAdCYeDYcNJexMuLQBuIbsFtBolLRYxxdDFsrAQVNLVUlTdHJva2U='), main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(80, 80, 80)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border


local titleBar = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ByaDDuGEoaNdLvCcHhTbfZdeMRMyzZlMNOdZkRnneEewsTJJstIeyTLRnJhbWU='), main)
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Name = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hImnUSDdrCoaxXkROPWHGvGNNmPwvYNvtXgJhTXihzAorNCSgkXNqyVVGl0bGVCYXI=')

local title = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('rHDGucEhDUBaFHEzBqOHQJxPrhamQZWiSCUcmouCZOlpMpHroOOTbwPVGV4dExhYmVs'), titleBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = texts[lang].Title
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 12, 0, 0)

local zoomBtn = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('bdMpAKkCXyFZkroFHCyOuPwdlotwOvnqQdAmwtIpGXHZExntogDczXVVGV4dEJ1dHRvbg=='), titleBar)
zoomBtn.Size = UDim2.new(0, 32, 0, 32)
zoomBtn.Position = UDim2.new(1, -32, 0, 0)
zoomBtn.Text = texts[lang].ZoomGUI
zoomBtn.BackgroundTransparency = 1
zoomBtn.TextColor3 = Color3.new(1, 1, 1)
zoomBtn.Font = Enum.Font.GothamBold
zoomBtn.TextSize = 16
zoomBtn.Name = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('wXGZBySzkOINopfXLBakQJAlRENeeFGrhNcblIOdOsOGDHessdkpiXbWm9vbUJ1dHRvbg==')


local tabList = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('QkOXifuFkXMUvuNTeZSksITIzsfSUWPSwpEGPelsqIkGnNIhXdHOMHbRnJhbWU='), main)
tabList.Size = UDim2.new(0, 120, 1, -32)
tabList.Position = UDim2.new(0, 0, 0, 32)
tabList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


local content = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('zBvCyAuoMkBtJkpuwRDtBcQlAbCYgAAgLcNEUATgnQTErOTRAWXDMhKRnJhbWU='), main)
content.Size = UDim2.new(1, -120, 1, -32)
content.Position = UDim2.new(0, 120, 0, 32)
content.BackgroundTransparency = 1
content.ClipsDescendants = true


local function showNotification(title, text)
    game.StarterGui:SetCore(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('EAeGPxFpljDQDwiOtsDMKxOvMJteUzNPcYQeodhdaVUJRwKYirYJtYgU2VuZE5vdGlmaWNhdGlvbg=='), {
        Title = title,
        Text = text,
        Duration = 2,
        Icon = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ESFrSxjGDLcIOwbcnWvhDCxFjZmRfDPvERhlkNcWovVsEqsFHpObRxIcmJ4YXNzZXRpZDovLzY3MjY1NzU4ODU=')
    })
end

local function createTabButton(name, posY)
    local btn = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hXRttXLgYiYYzMXqulwOMaPnXNqjafJLyWHpQeTpvpVWMSYAnjvOEVZVGV4dEJ1dHRvbg=='), tabList)
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.Position = UDim2.new(0, 4, 0, posY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cFYIoUJTuKGAvxYiEMHYsFaFtKRWoiyLZMOpJQyakfVezBPvxRVBbNaVUlDb3JuZXI='), btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return btn
end

local function createTabFrame()
    local frame = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('CBaoddENXNoDJobJoaCApOTlrfHctIakfbwkILmvFJTjfjkmrGFWSmPU2Nyb2xsaW5nRnJhbWU='), content)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 4
    frame.CanvasSize = UDim2.new(0, 0, 0, 600)
    return frame
end

local function addButton(tab, key, posY, callback)
    local btn = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('IVYOFnSmXwFOQOuKNozjpFDZeXtnuEtWoaVRyZVdJNRxXAtZSnTIqZeVGV4dEJ1dHRvbg=='), tab)
    btn.Size = UDim2.new(0, 250, 0, 36)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.Text = texts[lang][key] or key
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Name = key
    
    local btnCorner = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('RdkUNHIiJkbWpHvgQrkuhNUGCnSPgiXZhtxAQIOobNKqxOQweZXtbQNVUlDb3JuZXI='), btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addToggleButton(tab, key, posY, callback)
    local btn = addButton(tab, key, posY, function() end)
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        callback(active)
    end)
    
    return btn
end


local tabs = {
    Steal = createTabFrame(),
    Misc = createTabFrame(),
    Setting = createTabFrame()
}

local tabButtons = {
    Steal = createTabButton(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('uXkdMKLzOksrkEmeXGDdXYSZTEIbzqxZURdugMMWRThjWrkvIqTxoAfU3RlYWw='), 4),
    Misc = createTabButton(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ybetHJTGsIEMNzlKFsvADLAwHcFoFjDxBLzRlihdHqAnfCpRvIhgowqTWlzYw=='), 48),
    Setting = createTabButton(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('RHgiuRRKhvTgTQKcgXjaiewGKmvEkTNsJgbjKpkjKpeLavJDuwDQNfPU2V0dGluZw=='), 92)
}


local function fadeTo(tabName)
    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        else
            frame.Visible = false
        end
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        fadeTo(name)
    end)
end


local function noclipLoop()
    while noClipActive and player.Character do
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('YMKqGOKjaQiPwpvZdoFxwmgKRCUfFYZOBSYvhTAPDDjMdUEKuisZGbxQmFzZVBhcnQ=')) then
                part.CanCollide = false
            end
        end
        RunService.Stepped:Wait()
    end
end

addButton(tabs.Steal, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('UBQjySaqjUMxlukkFcgGonPgOblCywBbEvhYqCSrVTOZcQsmEdrnqxxU2F2ZUNQ'), 20, function()
    local hrp = player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ivcUqdLcvMSYrqKgmIBGsJehGCdkSFxUTITCdUNnSrWyDOkfMELaERGSHVtYW5vaWRSb290UGFydA=='))
    if hrp then 
        cp = hrp.CFrame
        showNotification(texts[lang].Title, texts[lang].CPSaved)
    end
end)

addButton(tabs.Steal, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('rhKUIOaXBPZXuDJskXWjApemFBWGygoqaEFKMiLpnimvaKvRjVqmHibVGVsZUNQ'), 60, function()
    local hrp = player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('yIVrUwSfFbYvXTiSUyJzdBOrpCmcZPykQZQzZzXDENXhAvPgzsxGPebSHVtYW5vaWRSb290UGFydA=='))
    if cp and hrp then 
        hrp.CFrame = cp
        showNotification(texts[lang].Title, texts[lang].CPTeled)
    end
end)

addToggleButton(tabs.Steal, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('GkxtDRjCQiqzjZYXXbgNiivctcaFORITVMbSXdvbcscKULhUFRBDaurQXV0b1N0ZWFs'), 100, function(active)
    autoStealActive = active
    if active then
        spawn(function()
            local humanoid = player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('swnOLzKXRmFvaSXZumfUYcJsGnVKmLdjHVSWpTPJLTRVqcjsWsPnonASHVtYW5vaWQ='))
            if humanoid then
                baseWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 32
            end
            
            while autoStealActive and player.Character do
                local hrp = player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ZZXPBjZwwWLYPWchotGQTeVITgxkahbaAdimPXjyZcbFqDcKugfzULBSHVtYW5vaWRSb290UGFydA=='))
                humanoid = player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('DqRFBwvxIjLuZtaJgCmNSsIgiWAjULvnmZpvoiQOalMOuaTQbxQVtzISHVtYW5vaWQ='))
                
                if cp and hrp and humanoid then
                    humanoid:MoveTo(cp.Position)
                    
                    local reached = false
                    local connection
                    connection = humanoid.MoveToFinished:Connect(function(success)
                        if success then
                            connection:Disconnect()
                            reached = true
                        end
                    end)
                    
                    local startTime = tick()
                    while not reached and (tick() - startTime < 10) and autoStealActive do
                        task.wait()
                    end
                    
                    if connection then connection:Disconnect() end
                end
                task.wait(0.5)
            end
            
            if player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cyNPQpmbXybtFIPxPLQismzOrjKNNaunvykZtlxSgCVSBGknDDYleAZSHVtYW5vaWQ=')) then
                player.Character.Humanoid.WalkSpeed = baseWalkSpeed
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('JpzOwQMAZZDUlXnWnEVeVzhZQQjvhZkWEcfyXWkCzssFfTiTEQcNBmQSHVtYW5vaWQ=')) then
            player.Character.Humanoid.WalkSpeed = baseWalkSpeed
        end
    end
end)

addToggleButton(tabs.Steal, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('DEdxnRPmvpRDnWRirVAzMaZGQlSvvJprxTMaCiPcLroXjEFmRCrhtsgTm9DbGlw'), 140, function(active)
    noClipActive = active
    if active then
        spawn(noclipLoop)
    end
end)


addButton(tabs.Misc, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('JUmKVKcBUrHdYkcDJmbVnBBaZFoUmfhbiTnobwXPCnAMpebaijRWhZZUmVqb2lu'), 20, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

addButton(tabs.Misc, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('BLLpsQsiVEFsuMJExsvIDyBXrnGZfWzXzOAofdNFMLAQcvnBpDqylmGSG9w'), 60, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId)
end)

local jobBox = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cmgYHjGzZwBXvqsmgUPJEhBocIvlKMzwWYLOTQGLMubJXYhnNayNPFkVGV4dEJveA=='), tabs.Misc)
jobBox.Size = UDim2.new(0, 250, 0, 36)
jobBox.Position = UDim2.new(0, 20, 0, 100)
jobBox.PlaceholderText = texts[lang].JobPlaceholder
jobBox.Text = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('SFFnlVySkwBghtmiygXJeVypSiiWFyvYrVEiRUIEHtMgZiQUKObLGsa')
jobBox.ClearTextOnFocus = false
jobBox.TextSize = 14
jobBox.Font = Enum.Font.Gotham
jobBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jobBox.TextColor3 = Color3.new(1, 1, 1)

local boxCorner = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('jmueyIWUhCQwtNxesdLULlGclIsLHeIaWFVWSuloeKeSUJWqSSpwTSxVUlDb3JuZXI='), jobBox)
boxCorner.CornerRadius = UDim.new(0, 4)

addButton(tabs.Misc, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('VGDEqAEJrBwbPPEQlurqfxhlVlfZqBrlnFPbSwFcQFfeBGZbOHKSByDSm9pbg=='), 140, function()
    if jobBox.Text ~= vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('CcRUnUaFLKkBtHSIclQYAKUJjJNcIwhGQnJRfxNOLMWyHiNGQqfDfsk') then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobBox.Text)
    end
end)

addButton(tabs.Misc, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('QpjvseBNQdpyJMhPMlxUpXrvJnDERqyeBgjGpAMHSTTrDgOLaaxZnxwRGVsZXRlR1VJ'), 180, function()
    gui:Destroy()
end)


local speedLabel = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('sxeFORzUhGwwGRhtvgabqYsMQvBEgmfclKOnIkeopXFeRyajyvetDVeVGV4dExhYmVs'), tabs.Setting)
speedLabel.Size = UDim2.new(0, 250, 0, 20)
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cQffeDmlPturkytyREGtfqtulVKELprQyNJyeoiNXqHAQRhGJusqONrVGV4dEJveA=='), tabs.Setting)
speedSlider.Size = UDim2.new(0, 250, 0, 36)
speedSlider.Position = UDim2.new(0, 20, 0, 40)
speedSlider.Text = tostring(walkSpeed)
speedSlider.PlaceholderText = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('dEtheyWsmMVYdSLJqgLffPpdZDcFBxbLTdTEgcKZYmxnPKAQfbSdxVJMTYtMTAw')
speedSlider.TextSize = 14
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.ClearTextOnFocus = false

local sliderCorner = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('WdbLZyWaoCsPpLwaZXcfwdzUOWXfwjqrdOQenXQazkEnohffKaIQaHcVUlDb3JuZXI='), speedSlider)
sliderCorner.CornerRadius = UDim.new(0, 4)

local function updateWalkSpeed()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
        walkSpeed = newSpeed
        speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
        
        if player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hxqUBRyzTLguirCDgSHKUkcFCjCVHPIQMtIqiLNpVbGVqWutseQtzAaSHVtYW5vaWQ=')) then
            if not autoStealActive then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        end
        showNotification(texts[lang].Title, texts[lang].SpeedUpdated..walkSpeed)
    else
        speedSlider.Text = tostring(walkSpeed)
    end
end

speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateWalkSpeed()
    end
end)

addButton(tabs.Setting, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('CvtBtVEjRTmiabBxVdksYOIFLzjiPTMmCFXRnVpuzLJSRfhsOCTizcuU2V0U3BlZWQ='), 80, function()
    updateWalkSpeed()
end)


addButton(tabs.Setting, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('gQreVlsUYEwVUFsThqkTTqtSglhxkwViNjUVvaIhPRrmqZeOCxjHtErTGFuZ1N3aXRjaA=='), 140, function()
    lang = (lang == vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('QGuCxVkbbhlcStEymoeaJzVLRzrqrYgKGFAgsdIxPxzLTEYMtAFUNKddmk=')) and vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('IDcGBbvJiknMUKNwhLClnCyHWQloAoDPvdKydEapIfxEHsdRdZvyXSxZW4=') or vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('EvfaUPTRqcuOyPmjLOdBkIOsfdadGiJXYqsrOPhbIZKLWHndeWgriFbdmk=')
    title.Text = texts[lang].Title
    jobBox.PlaceholderText = texts[lang].JobPlaceholder
    speedLabel.Text = texts[lang].CurrentSpeed..walkSpeed
    
    
    for _, tab in pairs(tabs) do
        for _, child in pairs(tab:GetChildren()) do
            if child:IsA(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('dASVDpUCsxJMwHVxCsrdHNynnbUHBBCghxhBMnNKBqCzSWpCEhMqgzyVGV4dEJ1dHRvbg==')) and texts[lang][child.Name] then
                child.Text = texts[lang][child.Name]
            end
        end
    end
end)


local shortcutsLabel = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('dLsLCdKYjQSikxEJDfIwDtXTHHiyrXXzgblPLVYlCVvKYZlxTRXvhFsVGV4dExhYmVs'), tabs.Setting)
shortcutsLabel.Size = UDim2.new(0, 250, 0, 20)
shortcutsLabel.Position = UDim2.new(0, 20, 0, 200)
shortcutsLabel.Text = texts[lang].Shortcuts
shortcutsLabel.TextSize = 14
shortcutsLabel.Font = Enum.Font.GothamBold
shortcutsLabel.BackgroundTransparency = 1
shortcutsLabel.TextColor3 = Color3.new(1, 1, 1)
shortcutsLabel.TextXAlignment = Enum.TextXAlignment.Left

local shortcutsText = Instance.new(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cJxziMOWIdaKiDVpoLdBeSjWwAOkEHABvRVPRnKRneKDZNuykRiPmWuVGV4dExhYmVs'), tabs.Setting)
shortcutsText.Size = UDim2.new(0, 250, 0, 100)
shortcutsText.Position = UDim2.new(0, 20, 0, 220)
shortcutsText.Text = texts[lang].ShortcutList
shortcutsText.TextSize = 12
shortcutsText.Font = Enum.Font.Gotham
shortcutsText.BackgroundTransparency = 1
shortcutsText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
shortcutsText.TextXAlignment = Enum.TextXAlignment.Left
shortcutsText.TextYAlignment = Enum.TextYAlignment.Top


addButton(tabs.Setting, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('PpOfjxXhUCIUWXUFmaKuFWfGJCoWwkPDGXIkVOwEHsegRYFEbrqSssKU2F2ZUNvbmZpZw=='), 340, function()
   
    showNotification(texts[lang].Title, texts[lang].ConfigSaved)
end)

addButton(tabs.Setting, vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('BrmzZrHHwJyEbbUKMoZKdSpShaEJrpMnvKJxANogguHsiTdNdYNRtfgUmVzZXRDb25maWc='), 380, function()
    walkSpeed = 16
    speedSlider.Text = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cvVMDmsqKeDKfGeApZsoKJwtBDLJbFdqHcmHonRGKuCSijlEDULrXQmMTY=')
    updateWalkSpeed()
    showNotification(texts[lang].Title, texts[lang].ConfigReset)
end)


zoomBtn.MouseButton1Click:Connect(function()
    isGUIMaximized = not isGUIMaximized
    if isGUIMaximized then
        main.Size = maximizedGUISize
        main.Position = maximizedGUIPosition
        zoomBtn.Text = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('eWkVSpvgrYrTjRDFujelzpnSFnmwewrtZVwJAhYPvWQEBeKNNhYTiOg8J+Xlw==')
    else
        main.Size = originalGUISize
        main.Position = originalGUIPosition
        zoomBtn.Text = texts[lang].ZoomGUI
    end
end)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
   
    if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
    
    
    if input.KeyCode == Enum.KeyCode.F4 then
        gui.Enabled = not gui.Enabled
    end
    
   
    if input.KeyCode == Enum.KeyCode.F2 then
        isGUIMaximized = not isGUIMaximized
        if isGUIMaximized then
            main.Size = maximizedGUISize
            main.Position = maximizedGUIPosition
            zoomBtn.Text = vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('ynghkwCadWqnjFiBFeaoiMMalkiJgmRzBqsvXwqbGyXospKtZTUOOKU8J+Xlw==')
        else
            main.Size = originalGUISize
            main.Position = originalGUIPosition
            zoomBtn.Text = texts[lang].ZoomGUI
        end
    end
end)


local AntiBan = {
    Active = true,
    LastCheck = 0,
    
    SafeCheck = function(self)
        if tick() - self.LastCheck < 30 then return true end
        self.LastCheck = tick()
        
        local unsafe = {vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('AOpEbdnEYvwksRTsYLucSnbGWmcdBhSJYAnDvCvrCzDomyscTFhNAzVQW50aUNoZWF0'), vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('KOxIGotmRXuTWQRbendKtkbVfiXnuPEHQyYBELWDwehvbaZvQCTmFySQUM='), vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('fEOfEMhbFYjhTwczzZQRMDSyWXhcwgUXKBtEGpAidPscldCTvDBPqwAQmFkZ2Vy'), vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('hYgADHZbQNPMMFjCdbPOSaZDdxjApyUdwBOoEZOFjROCBBQMDlCslEvVkFD')}
        for _, name in pairs(unsafe) do
            if game:GetService(name) then
                return false
            end
        end
        return true
    end,
    
    HandleKick = function(self, code)
        if code and code:find(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('rCObBKrAdcgJpGkZDWfoKAvirZHJECzoTdeRCtdonnKrBVfJHyJHwBnQkFDJS0xMDI2MQ==')) then
            task.wait(300)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    end
}

game:GetService(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('cnPHvsznnkfArFECBoxxqqLQyZWHqRxRTsmdYkQTeUafrpEnRZAysyYUGxheWVycw==')).PlayerRemoving:Connect(function(p)
    if p == player and AntiBan.Active then
        AntiBan:HandleKick(p.KickMessage)
    end
end)

spawn(function()
    while AntiBan.Active and task.wait(10) do
        if not AntiBan:SafeCheck() then
            gui:Destroy()
            AntiBan.Active = false
            break
        end
    end
end)


fadeTo(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('iMjfEHXpGGpXVrTecwxuAvwClJRUGXIgPgfsdoZJIiCFwQNtWYJhwHKU3RlYWw='))


if player.Character and player.Character:FindFirstChild(vswIocJFQCaXbauULuherxwXclDzPPMkWETlochsNQHZXuZecJqIpphQfyViUoXCQzRwBkQhLFggBVfTFgwhyW('mKTabFOCuiGccRGCxCWEvvGJwvZAtUmoBGKOZRxSZTpCLKvyYgvJEWzSHVtYW5vaWQ=')) then
    player.Character.Humanoid.WalkSpeed = walkSpeed
end    
