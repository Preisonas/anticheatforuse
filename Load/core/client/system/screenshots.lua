exports("screenshot",function(webhookUrl)
    WaveShield.assert(WaveShield.TypeCheck.isString(webhookUrl), "webhookUrl: string")

    local screenShotTimedOut = false
    local oldScreenShot = SafeGetLocalPlayerState("ScreenShotURL")

    WaveShield.SendNUIMessage({
        command = "TAKE_SCREENSHOT",
        uploadWebhook = webhookUrl
    })

    Citizen.SetTimeout(5000, function()
        screenShotTimedOut = true
    end)

    while oldScreenShot == SafeGetLocalPlayerState("ScreenShotURL") and not screenShotTimedOut do
        WaveShield.Wait(100)
    end

    if oldScreenShot ~= SafeGetLocalPlayerState("ScreenShotURL") then
        return SafeGetLocalPlayerState("ScreenShotURL")
    else
        WaveShield.print('Unable to create screenshot, timed out.')
        return
    end
end)

-- ZCBpIHMgYyBvIHIgZCAuIGdnIC8gZm1h
exports("captureLastSeconds",function(webhookUrl)
    WaveShield.assert(WaveShield.TypeCheck.isString(webhookUrl), "webhookUrl: string")
    
    local videoTimedOut = false
    local oldVideo = SafeGetLocalPlayerState("GameplayCaptureURL")

    WaveShield.SendNUIMessage({
        command = "SEND_LAST_RECORDING",
        uploadWebhook = webhookUrl
    })

    Citizen.SetTimeout(5000, function()
        videoTimedOut = true
    end)

    while oldVideo == SafeGetLocalPlayerState("GameplayCaptureURL") and not videoTimedOut do
        WaveShield.Wait(100)
    end

    if oldVideo ~= SafeGetLocalPlayerState("GameplayCaptureURL") then
        return SafeGetLocalPlayerState("GameplayCaptureURL")
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm
    else
        WaveShield.print('Unable to capture gameplay, timed out.')
        return
    end
end)

RegisterNetEvent("__WaveShield:takeScreenShot")
AddEventHandler("__WaveShield:takeScreenShot",function(webhookUrl)
    WaveShield.assert(WaveShield.TypeCheck.isString(webhookUrl), "webhookUrl: string")
    WaveShield.SendNUIMessage({
        command = "TAKE_SCREENSHOT",
        uploadWebhook = webhookUrl
    })
end)

RegisterNetEvent("__WaveShield:uploadCapturedGameplay")
AddEventHandler("__WaveShield:uploadCapturedGameplay",function(webhookUrl)
    WaveShield.assert(WaveShield.TypeCheck.isString(webhookUrl), "webhookUrl: string")
-- WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFggZm1h
    WaveShield.SendNUIMessage({
        command = "SEND_LAST_RECORDING",
        uploadWebhook = webhookUrl
    })
end)

RegisterNUICallback("screenshotSaved", function(data, cb)
    if data and data.screenshotUrl then
-- Zm1hLnd0Zg==
        SafeSetLocalPlayerState('ScreenShotURL', data.screenshotUrl, true)
    end

    cb({})
end)

RegisterNUICallback("saveVideoData", function(data, cb)
    if data and data.videoUrl then
        SafeSetLocalPlayerState('GameplayCaptureURL', data.videoUrl, true)
    end

    cb({})
end)

WaveShield.CreateThread(function()
    WaveShield.Wait(5000)

    WaveShield.SendNUIMessage({
        command = "GET_TOKENS"
    })

    if WaveShield.Config.Settings.EnableGameplayRecord then
        WaveShield.SendNUIMessage({
            command = "START_RECORDING"
-- UFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUCBpdHMgZm1h
        })
    end
end)