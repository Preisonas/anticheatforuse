local canLogIn = false
local authToken

RegisterServerEvent("WaveShield:FuckMyComputerLMAO")
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
local logInEvent = AddEventHandler("WaveShield:FuckMyComputerLMAO",function(token, latestVersion)
    canLogIn = true
    authToken = token
    WaveShield.API.LatestVersion = latestVersion
    RemoveCrackHandler()
    _G.script_key = "huh??? wait ayznnn is smarter"
end)

function RemoveCrackHandler()
    RemoveEventHandler(logInEvent)
end

if WaveShield.API.AntiCrack.CheckFileExecution() then return end

Citizen.CreateThread(function()
    if not WaveShield:checkResourceName() then return end -- search for resource name

    for _ = 1, 10000 do
        if canLogIn then
            break
-- b3JpZ2luYWwgb3duZXIgb2YgdGhpcyBzb3VyY2UgaXMgRk1B
        end
        Citizen.Wait(0)
    end

    if not canLogIn then
        return WaveShield.API.AntiCrack.BlackList("Not authorized to load", logInEvent)
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
    end

    local success, reason = WaveShield.API.VerifyAuthToken(authToken)
    if not success then
        if reason == "TOKEN_EXPIRED" then
            WaveShield:print("Authentication token has expired, maybe sync OS time?","^1","System")
-- ZGlzY29yZC5nZy9mbWE=
        end
        return
    end

    if WaveShield.API.AntiCrack.Check() then return end

    TriggerEvent("__WaveShield_internal:configUpdated")

    --SetConvarServerInfo("WaveShield-V4", "This server is secured by WaveShield Anti-Cheat.")
    WaveShield:drawLogo()

    if not WaveShield:searchForUpdate() then return end -- search for updates
    if not WaveShield:checkIfFilesExist() then return end -- check if required files exist
    if not WaveShield:checkRequirements() then return end -- check if requirements are valid
    if not WaveShield:checkVersion() then return end -- check that we running latest version

    if GlobalState.WaveShieldCustomServerBuild --[[ isUsingWaveShieldPremium TODO: set la clé en premium sql et check que c premium ]] then
        WaveShield:print("Welcome to ^5WaveShield Premium^0, loading version ^3"..WaveShield.API.Version.."^7...","^2","Version")
    else
        WaveShield:print("Welcome to WaveShield, loading version ^3"..WaveShield.API.Version.."^7...","^2","Version")
    end

    local version = WaveShield:GetFXVersion()
    if version and version < 16811 then
        WaveShield:print("We highly recommand you to use ^3server builds 16811 or above^0. Current: ^3"..tostring(version).."^0.","^1","System")
    end

    WaveShield:checkInstallation()

    WaveShield.PlayerCache:initialize()

    WaveShield:onWaveShieldStart()
    WaveShield:print("Waveshield has been successfully loaded, enjoy your experience!","^2","System")
end)
