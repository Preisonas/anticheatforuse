local WaveShield = {}
WaveShield.resourceName = GetCurrentResourceName()
WaveShield.Started = false
WaveShield.ProcessEvent = {}
WaveShield.Cache = {}
WaveShield.PlayerCache = {}
WaveShield.DeadPlayersCache = {
    --[[ [0] = {
        {timestamp = 0, killedId = 0}
    } ]]
}
WaveShield.TempPlayerCache = {}

WaveShield.Player = {}
WaveShield.banKey = 'waveshield_ban_%s'
WaveShield.Wait = Wait
WaveShield.type = type
WaveShield.CreateThread = CreateThread

local function randomString(count)
    math.randomseed(os.time() + math.random(11111, 99999))
    local chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz123456789"
    local rndmString = ""
    for i = 0,count do
        local rndm = math.random(1,#chars)
        local char = string.sub(chars,rndm,rndm)
        rndmString = rndmString..char
    end
    return rndmString
end

WaveShield.Config = {}
WaveShield.WebHooks = {}

GlobalState.BanEventToken = randomString(math.random(15, 30))

WaveShield.StateBagsToken = randomString(8)
GlobalState.StateBagsToken = WaveShield.StateBagsToken

WaveShield.HeartbeatEventToken = randomString(math.random(15, 30))
GlobalState.HeartbeatEventToken = WaveShield.HeartbeatEventToken

WaveShield.HHct1C6gobnW3DkIQUxiXk9Q = randomString(math.random(15, 30)) -- convar name to get key for string encryption
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
GlobalState.HHct1C6gobnW3DkIQUxiXk9Q = WaveShield.HHct1C6gobnW3DkIQUxiXk9Q

WaveShield.CFct1C6gobnW4qkaQUx3Xk9Q = randomString(math.random(15, 30)) -- convar value to get key for config bag
GlobalState.CFct1C6gobnW4qkaQUx3Xk9Q = WaveShield.CFct1C6gobnW4qkaQUx3Xk9Q

SetConvarReplicated(WaveShield.HHct1C6gobnW3DkIQUxiXk9Q, randomString(math.random(15, 30))) -- convar value to get key for string encryption

GlobalState.WaveShieldCustomServerBuild = (GetConvar('sv_isUsingWaveShieldServerBuild', 'false') == 'true') and true or false

function WaveShield:transformTableValuesInKeys(table)
    local tempTable = {}
    for k,v in pairs(table or {}) do
        if type(v) == "boolean" and v == true then
            tempTable[k] = true
        else
            tempTable[v] = true
        end
    end
    return tempTable
end

function WaveShield.MakeConfiguration(config)
    local webhooks = {
        MainWebhook = config.Settings.MainWebhook,
        EntitiesWebhook = config.Settings.EntitiesWebhook,
        ExplosionsWebhook = config.Settings.ExplosionsWebhook,
        WeaponsWebhook = config.Settings.WeaponsWebhook,
        UnbansWebhook = config.Settings.UnbansWebhook,
        ConnectionsWebhook = config.Settings.ConnectionsWebhook,
        CommunityLogsWebhook = config.Settings.CommunityLogsWebhook,
    }

    local newConfig = config
    for k in pairs(webhooks) do
        newConfig.Settings[k] = nil
    end

    if WaveShield.IsEventTokenizationReady then
        newConfig.Token = WaveShield.EncryptString(GetGameTimer(), WaveShield.Substitution)
    end
    
    newConfig.Settings.IgnoredScripts = WaveShield:transformTableValuesInKeys(newConfig.Settings.IgnoredScripts)
    newConfig.Beta.IgnoredExecutionPatterns = WaveShield:transformTableValuesInKeys(newConfig.Beta.IgnoredExecutionPatterns)

    WaveShield.Config = newConfig
    WaveShield.WebHooks = webhooks

    GlobalState[WaveShield.CFct1C6gobnW4qkaQUx3Xk9Q] = WaveShield.Config

    _G.RawWaveShieldConfiguration = nil
-- ZiBtIGE=

    TriggerEvent("__WaveShield_internal:configUpdated")
end
-- WlhYWFhYWFhYWFhYWFhYWENDQ0NDQ0NDQ0NDQ0NDQ0NDQyBmbWE=

WaveShield.MakeConfiguration(_G.RawWaveShieldConfiguration or GlobalState[WaveShield.CFct1C6gobnW4qkaQUx3Xk9Q])

WaveShield.CreateThread(function()
    local installedResources = {}
    -- Inject into random client resources for anti stop system
    
    local function checkWaveShieldInstalled(resource)
        for i = 0, GetNumResourceMetadata(resource, "shared_script") - 1 do
            local file = GetResourceMetadata(resource, "shared_script", i) or "none"
            if file == "@WaveShield/resource/include.lua" then
                return true
            end
        end

        return false
    end

    while not WaveShield.IsEventTokenizationReady do WaveShield.Wait(1000) end

    for i = 0, GetNumResources(), 1 do
        local resourceToInject = GetResourceByFindIndex(i)
        if resourceToInject and resourceToInject ~= "_cfx_internal" and resourceToInject ~= "WaveShield" then
            if GetResourceState(resourceToInject) == "started" and GetNumResourceMetadata(resourceToInject, "client_script") > 0 then
                if checkWaveShieldInstalled(resourceToInject) then
                    local encryptedResourceToInject = WaveShield.EncryptString(resourceToInject, WaveShield.Substitution)
                    table.insert(installedResources, encryptedResourceToInject)
                end
            end
        end
    end

    local resourcesToInject = {}
    math.randomseed(os.time())

    -- Shuffle the list of resources
    for i = #installedResources, 2, -1 do
        local j = math.random(i)
        installedResources[i], installedResources[j] = installedResources[j], installedResources[i]
    end

    for i = 1, math.min(3, #installedResources) do
        resourcesToInject[installedResources[i]] = true
    end

    local payload = msgpack.pack(resourcesToInject)
    local antiStopBagName = WaveShield.EncryptString("_WS:injected_resources", WaveShield.Substitution)
    SetStateBagValue("global", antiStopBagName, payload, payload:len(), true)
end)
