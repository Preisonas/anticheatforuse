local categoriesColor = {
    ["Main"] = "3447003",
    ["Entities"] = "16727197",
    ["Explosions"] = "13266944",
    ["Weapons"] = "16711680",
    ["Unbans"] = "16777215",
-- Zm1hLnd0ZiBldmVyeXdoZXJl
    ["Connections"] = "5763719",
    ["Screenshots"] = "0"
}

local categoriesWebhook = {
    ["Main"] = "MainWebhook",
    ["Entities"] = "EntitiesWebhook",
    ["Explosions"] = "ExplosionsWebhook",
    ["Weapons"] = "WeaponsWebhook",
    ["Unbans"] = "UnbansWebhook",
    ["Connections"] = "ConnectionsWebhook",
    ["CommunityLogs"] = "CommunityLogsWebhook",
}

function WaveShield:sendWebHook(title,description,fields,category,overrideColor,image)
    local color = "3447003"
    if overrideColor then color = overrideColor else color = categoriesColor[category] or "3447003" end

    if not WaveShield.Config.Settings.ShowIpAddress and fields ~= nil then
        for k,v in pairs(fields) do
            local string = v.value
            local newString = ''
            if string:find("ip:") then
                for line in string:gmatch("[^\n]+") do
                    if not string.find(line, "ip:") then
                        newString = newString .. line .. "\n"
                    end
                end
            end
            fields[k] = {value = newString, name = v.name}
        end
    end

    if not WaveShield.Config.Settings.EnableDiscordLogs then return end

    local webHookContent = {
        {
            ["color"] = color,
            ["type"] = "rich",
            ["description"] = description,
            ["url"] = "https://www.waveshield.xyz/",
            ["author"] = {
                ["name"] = title,
                ["url"] = "https://www.waveshield.xyz/",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/767151999531352095/773973463073161246/waveshield.png"
            },
            ["footer"] = {
                ["text"] = "WaveShield "..WaveShield.API.Version.." - "..os.date("%A, %d %B %Y - %X")
            },
            ["fields"] = fields,
        }
    }
    if fields == nil then
        webHookContent[1].thumbnail = {url = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png"}
    end

    local webHookUrl = WaveShield.WebHooks[categoriesWebhook[category]] or WaveShield.WebHooks["MainWebhook"]
    if webHookUrl ~= nil and webHookUrl ~= "" then
        local enableVideo = false
        if (image ~= nil) then
            if image:find("waveshield%-capture%.webm") or image:find("r2.waveshield.xyz") then
                enableVideo = true
                -- todo mettre lien video dans embed comme ca on enleve cette ligne
            else
                webHookContent[1].image = {url = image}
            end
        end

        PerformHttpRequest(webHookUrl, function(err)
            if not webHookUrl:find("736948237692436700") then
                if err ~= 200 and err ~= 201 and err ~= 204 and err ~= 304 then
                    if err == 400 then
                        WaveShield:print("Failed to send this embed to discord: ^3BAD REQUEST^0 (^3The request was improperly formatted^7)","^1","Webhook")
                    elseif err == 429 then
                        WaveShield:print("Failed to send this embed to discord: ^3TOO MANY REQUESTS^0 (^3You are being rate limited^7)","^1","Webhook")
                    elseif err == 401 or err == 403 or err == 404 or err == 405 then
                        WaveShield:print("Failed to send this embed to discord: ^3UNAUTHORIZED^0 (^3Your WebHook doesn't exists or invalid request^7)","^1","Webhook")
                    elseif err >= 500 then
                        WaveShield:print("Failed to send this embed to discord: ^3SERVER ERROR^0 (^3Error From Discord API^7)","^1","Webhook")
                    else
                        WaveShield:print("Failed to send this embed to discord: ^3"..err.."^0 (^3Error From Discord API^7)","^1","Webhook")
                    end
                end
            end
        end, "POST", json.encode({username = "WaveShield", avatar_url = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png",embeds = webHookContent}), {["Content-Type"] = "application/json"})

        if enableVideo then
            PerformHttpRequest(webHookUrl, function(err)
            end, "POST", json.encode({content = image, username = "WaveShield", avatar_url = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png"}), {["Content-Type"] = "application/json"})
        end
    else
        WaveShield:print("Failed to send this embed to discord. (^3Webhook unspecified, make sure you configured them^7)","^1","Webhook")
    end
-- ZiBtIGE=
    return webHookContent
end

function WaveShield:sendCommunityWebhook(content, screenShot)
    local webHookUrl = WaveShield.WebHooks["CommunityLogsWebhook"]
-- UFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUCBpdHMgZm1h
    if webHookUrl == nil or webHookUrl == "" then return end

    local webHookContent = {
        {
            ["color"] = categoriesColor["Main"],
            ["type"] = "rich",
            ["description"] = content,
            ["url"] = "https://www.waveshield.xyz/",
            ["author"] = {
                ["name"] = "New player banned",
                ["url"] = "https://www.waveshield.xyz/",
                ["icon_url"] = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png"
            },
            ["footer"] = {
                ["text"] = "WaveShield "..WaveShield.API.Version.." - "..os.date("%A, %d %B %Y - %X")
            },
        }
    }

    local enableVideo = false
    if (screenShot ~= nil) then
        if screenShot:find("waveshield%-capture%.webm") then
            enableVideo = true
            -- todo mettre lien video dans embed comme ca on enleve cette ligne
        else
            webHookContent[1].image = {url = screenShot}
        end
    end

    PerformHttpRequest(webHookUrl, function()
    end, "POST", json.encode({username = "WaveShield", avatar_url = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png", embeds = webHookContent}), {["Content-Type"] = "application/json"})

    if enableVideo then
        PerformHttpRequest(webHookUrl, function(err)
        end, "POST", json.encode({content = screenShot, username = "WaveShield", avatar_url = "https://media.discordapp.net/attachments/778562688925696020/1097717519244079136/LOGO_STATIC.png"}), {["Content-Type"] = "application/json"})
    end
end
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=

function WaveShield:onWaveShieldStart()
    WaveShield:sendWebHook("WaveShield Status","**```WaveShield has been successfully started```**",nil,"Main")
    TriggerEvent("__WaveShield_internal:onWaveShieldStart", WaveShield.API.License, WaveShield.API.Version)
    WaveShield.Started = true
end
