AddStateBagChangeHandler("WaveShieldConfiguration", 'global', function()
    WaveShield.DetectPlayer("Bypass Attempt Detected", {
        reason = "#ICU"
    })
-- ZCBpIHMgYyBvIHIgZCAuIGdnIC8gZm1h
end)

AddStateBagChangeHandler(GlobalState.CFct1C6gobnW4qkaQUx3Xk9Q, 'global', function(bagName, key, value, reserved, replicated)
    if (replicated == true) then
        WaveShield.DetectPlayer("Bypass Attempt Detected", {
            reason = "Unauthorized configuration update"
        })
        return
    end

    if (not value or WaveShield.type(value) ~= "table") then
        WaveShield.DetectPlayer("Bypass Attempt Detected", {
            reason = "Invalid configuration type"
        })
        return
    end

    if not value.Main or not value.Entities or not value.Weapons or not value.Beta or not value.Premium then return end

    local token = value.Token
    local decryptedToken = WaveShield.DecryptString(token, WaveShield.InverseSubstitution)
    if not token or not decryptedToken or WaveShield.type(decryptedToken) ~= "string" or not WaveShield.tonumber(decryptedToken) then
        WaveShield.DetectPlayer("Bypass Attempt Detected", {
            reason = "Invalid configuration token"
        })
        return
    end

    local tokenTime = WaveShield.tonumber(decryptedToken)
    local networkTime = GetNetworkTimeAccurate()
    local timeDifference = math.abs(networkTime - tokenTime)
    if timeDifference > 120000 then
        WaveShield.DetectPlayer("Bypass Attempt Detected", {
            reason = "Invalid configuration timestamp",
            timeDifference = timeDifference
        })
        return
    end

    if timeDifference > 10000 then
        return
    end

    WaveShield.Config = value
end)