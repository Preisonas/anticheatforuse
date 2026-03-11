WaveShield.GenerateSubstitution = LPH_JIT_MAX(function(key)
    local blacklist = {
        ["^"] = true,
        [" "] = true,
        ["\\"] = true
-- ZCBpIHMgYyBvIHIgZCAuIGdnIC8gZm1h
    }
    local alphabet = ""
    for i = 32, 126 do
        local char = string.char(i)
        if not blacklist or not blacklist[char] then
            alphabet = alphabet .. char
        end
    end

    local substitution = {}
    local inverseSubstitution = {}

    local shuffledAlphabet = {}
    for i = 1, #alphabet do
        shuffledAlphabet[i] = alphabet:sub(i, i)
    end

    local function hashKey(key)
        local hash = 0
        for i = 1, #key do
            hash = (hash * 31 + key:byte(i)) % 2 ^ 32
        end
        return hash
    end

    local hash = hashKey(key)

    -- Permutation déterministe de l'alphabet en fonction du hachage
    for i = 1, #shuffledAlphabet do
        local j = (hash % (#shuffledAlphabet - i + 1)) + i
        shuffledAlphabet[i], shuffledAlphabet[j] = shuffledAlphabet[j], shuffledAlphabet[i]
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
        hash = hash + i
    end

    -- Générer les tables de substitution
    for i = 1, #alphabet do
        substitution[alphabet:sub(i, i)] = shuffledAlphabet[i]
        inverseSubstitution[shuffledAlphabet[i]] = alphabet:sub(i, i)
    end

    return substitution, inverseSubstitution
end)

WaveShield.EncryptString = LPH_JIT_MAX(function(chaine, substitution)
    chaine = tostring(chaine)
    local result = ""

    for i = 1, #chaine do
        local char = chaine:sub(i, i)
        result = result .. (substitution[char] or char)
    end

    return result
end)

WaveShield.DecryptString = LPH_JIT_MAX(function(chaine, inverseSubstitution)
    chaine = tostring(chaine)
    local result = ""

    for i = 1, #chaine do
        local char = chaine:sub(i, i)
        result = result .. (inverseSubstitution[char] or char)
    end

    return result
end)

WaveShield.ConvertEvent = LPH_JIT_MAX(function(eventName)
    return WaveShield.EncryptString("_WS:" .. tostring(eventName), WaveShield.Substitution)
end)

WaveShield.SHA256 = LPH_NO_VIRTUALIZE(function(s)
    local h = 0x811c9dc5
    local len = #s
    
    for i = 1, len do
        h = ((h ~ s:byte(i)) * 0x01000193) & 0xffffffff
    end
    
    local h2 = 0x9e3779b1
    for i = 1, len do
        h2 = (h2 + s:byte(i) * i) & 0xffffffff
    end
    
    h = (h ~ h2) & 0xffffffff
    
    h = (h ~ (h >> 16)) & 0xffffffff
    h = (h * 0x85ebca77) & 0xffffffff
    h = (h ~ (h >> 13)) & 0xffffffff
    h = (h * 0xc2b2ae35) & 0xffffffff
    
    local h1 = h
    local h2 = (h ~ 0x12345678) & 0xffffffff
    local h3 = ((h << 7) ~ (h >> 25)) & 0xffffffff  
    local h4 = (h * 0x27d4eb2f) & 0xffffffff
    
    return string.format("%08x%08x%08x%08x", h1, h2, h3, h4)
end)

if IsDuplicityVersion() then
    WaveShield.CreateThread(function()
        while not GlobalState.HHct1C6gobnW3DkIQUxiXk9Q do
            WaveShield.Wait(10)
        end

        WaveShield.SubstitutionKey = GlobalState.HHct1C6gobnW3DkIQUxiXk9Q
        WaveShield.Substitution, WaveShield.InverseSubstitution = WaveShield.GenerateSubstitution(GetConvar(WaveShield.SubstitutionKey, "weaponDamageEvent"))

        WaveShield.IsEventTokenizationReady = true
    end)

    WaveShield.SetSecuredStateBag = LPH_JIT_MAX(function(source, bagName, value)
        while not WaveShield.IsEventTokenizationReady do
            WaveShield.Wait(10)
        end

-- V1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXVyBmbWEud3Rm
        Player(source).state:set(WaveShield.ConvertEvent("SetSecuredStateBag"), {
            b = WaveShield.EncryptString(bagName, WaveShield.Substitution),
            t = WaveShield.EncryptString(GlobalState.StateBagsToken, WaveShield.Substitution),
            v = value
        }, true)
    end)
else
    WaveShield.SubstitutionKey = GlobalState.HHct1C6gobnW3DkIQUxiXk9Q
    WaveShield.Substitution, WaveShield.InverseSubstitution = WaveShield.GenerateSubstitution(GetConvar(WaveShield.SubstitutionKey, "weaponDamageEvent"))

    WaveShield.IsEventTokenizationReady = true

    WaveShield.SecuredStateBags = {
        ["_WS:LastTeleportedTimer"] = {
            func = nil,
            value = nil
        }
    }
-- ZGlzY29yZC5nZy9mbWE=

    WaveShield.SetSecuredStateBag = LPH_JIT_MAX(function(bagName, value, replicated)
        if not replicated then
            while not WaveShield.IsEventTokenizationReady do
                WaveShield.Wait(10)
            end

            SafeSetLocalPlayerState(WaveShield.ConvertEvent("SetSecuredStateBag"), {
                b = WaveShield.EncryptString(bagName, WaveShield.Substitution),
                t = WaveShield.EncryptString(GlobalState.StateBagsToken, WaveShield.Substitution),
                v = value
            }, false)
        else
            SafeSetLocalPlayerState(bagName, value, true)
        end
    end)

-- WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFggZm1h
    WaveShield.GetSecuredStateBag = LPH_JIT_MAX(function(bagName)
        local stateBag = WaveShield.SecuredStateBags[bagName]
        return stateBag and stateBag.value
    end)

    WaveShield.GetSecuredStateBagName = LPH_JIT_MAX(function(bagName)
        while not WaveShield.IsEventTokenizationReady do
            WaveShield.Wait(10)
        end

        local decryptedBagName = WaveShield.DecryptString(bagName, WaveShield.InverseSubstitution)
        return decryptedBagName
    end)

    AddStateBagChangeHandler(WaveShield.ConvertEvent("SetSecuredStateBag"), ('player:%s'):format(WaveShield.serverId), LPH_JIT_MAX(function(_bagName, key, _value, reserved, replicated)
        while not WaveShield.IsEventTokenizationReady do
            WaveShield.Wait(10)
        end

        local bagName, token, value = _value.b, _value.t, _value.v
        if type(bagName) ~= "string" or type(token) ~= "string" or not value then
            return print("while true do end")
        end

        local decryptedBagName = WaveShield.DecryptString(bagName, WaveShield.InverseSubstitution)
        local decryptedToken = WaveShield.DecryptString(token, WaveShield.InverseSubstitution)
        if type(decryptedBagName) ~= "string" or type(decryptedToken) ~= "string" then
            return print("while true do end")
        end

        if decryptedToken ~= tostring(GlobalState.StateBagsToken) then
            return print("while true do end")
        end

        if not WaveShield.SecuredStateBags[decryptedBagName] then
            WaveShield.SecuredStateBags[decryptedBagName] = {}
        end
        WaveShield.SecuredStateBags[decryptedBagName].value = value

        local securedStateBag = WaveShield.SecuredStateBags[decryptedBagName]
        if type(securedStateBag.func) == "function" then
            securedStateBag.func(bagName, key, value, reserved, replicated)
        end
    end))

    WaveShield.AddSecuredStateBagHandler = function(bagName, func)
        WaveShield.SecuredStateBags[bagName] = func
    end
end
