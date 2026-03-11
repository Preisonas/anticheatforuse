local NumberToBoolean <const> = LPH_NO_VIRTUALIZE(function(number)
    if number == true then
        return true
    elseif number == false then
        return false
    elseif number == 1 then
        return true
    elseif number == 0 then
        return false
    elseif WaveShield.type(number) ~= "number" then
        return false
    else
        return true
    end
end)

local signedToUnsigned <const> = LPH_NO_VIRTUALIZE(function(num)
    if not num or WaveShield.type(num) ~= "number" then return end

    if num >= 0 then
        return num
    end
    local complement = 4294967296 + num
    return complement
end)

WaveShield.TypeCheck = {
    isNumber = function(value) return WaveShield.type(value) == "number" end,
    isString = function(value) return WaveShield.type(value) == "string" end,
    isTable = function(value) return WaveShield.type(value) == "table" end,
    isOptional = function(typeCheck)
        return function(value)
            return value == nil or typeCheck(value)
        end
    end
}

WaveShield.Actions = {
    BAN = { id = 0, message = "You have been banned by WaveShield for cheating." },
    KICK = { id = 1, message = "You have been kicked by WaveShield for possible cheating." },
    LOG = { id = 2 },
}

WaveShield.Categories = {
    MAIN = "Main",
    VEHICLES = "Vehicles",
    ENTITIES = "Entities",
    WEAPONS = "Weapons",
    EXPLOSIONS = "Explosions",
    UNBANS = "Unbans",
    CONNECTIONS = "Connections",
    SCREENSHOTS = "Screenshots",
    COMMUNITY = "Community",
}

WaveShield.Detections = {
    -- Main category detections
    ANTI_OVERLAY = { name = "E1", message = "Overlay Detected", category = WaveShield.Categories.MAIN },
    ANTI_TELEPORT = { name = "AntiTeleport", message = "Teleportation Detected", category = WaveShield.Categories.MAIN },
    ANTI_LUA_MENU = { name = "AntiLuaMenu", message = "Lua Menu Detected", category = WaveShield.Categories.MAIN },
    ANTI_NO_CLIP = { name = "AntiNoClip", message = "NoClip Detected", category = WaveShield.Categories.MAIN },
    ANTI_FREE_CAM = { name = "AntiFreeCam", message = "FreeCam Detected", category = WaveShield.Categories.MAIN },
    ANTI_SPEED_HACK = { name = "AntiSpeedHack", message = "SpeedHack Detected", category = WaveShield.Categories.MAIN },
    ANTI_NO_RAGDOLL = { name = "AntiNoRagdoll", message = "NoRagdoll Detected", category = WaveShield.Categories.MAIN },
    ANTI_SPECTATE = { name = "AntiSpectate", message = "Spectate Detected", category = WaveShield.Categories.MAIN },
    ANTI_INVISIBLE = { name = "AntiInvisible", message = "Invisible Player Detected", category = WaveShield.Categories.MAIN },
    ANTI_SUPER_JUMP = { name = "AntiSuperJump", message = "SuperJump Detected", category = WaveShield.Categories.MAIN },
    ANTI_INFINITE_STAMINA = { name = "AntiInfiniteStamina", message = "Infinite Stamina Detected", category = WaveShield.Categories.MAIN },
    ANTI_PED_MODEL_CHANGE = { name = "AntiPedModelChange", message = "Ped Model Change Detected", category = WaveShield.Categories.MAIN },
    ANTI_NIGHT_VISIONS = { name = "AntiNightVisions", message = "Night Vision Detected", category = WaveShield.Categories.MAIN },
    ANTI_AFK_BYPASS = { name = "AntiAFKBypass", message = "AFK Bypass Detected", category = WaveShield.Categories.MAIN },
    ANTI_INPUT_BOX = { name = "AntiInputBox", message = "Input Box Detected", category = WaveShield.Categories.MAIN },
    ANTI_INFINITE_REFILL = { name = "AntiInfiniteRefill", message = "Infinite Health Refill Detected", category = WaveShield.Categories.MAIN },
    ANTI_OVERRIDE_HEALTH_STATS = { name = "AntiOverrideHealthStats", message = "Health Stats Override Detected", category = WaveShield.Categories.MAIN },
    ANTI_INVINCIBLE = { name = "AntiInvincible", message = "Invincibility Detected", category = WaveShield.Categories.MAIN },
    ANTI_NO_COMBAT_DAMAGES = { name = "AntiNoCombatDamages", message = "No Combat Damages Detected", category = WaveShield.Categories.MAIN },
    ANTI_TRIGGER_CLIENT_EVENT = { name = "AntiTriggerClientEvent", message = "Illegal Client Event Triggerd", category = WaveShield.Categories.MAIN },
    ANTI_TRIGGER_SERVER_EVENT = { name = "AntiTriggerServerEvent", message = "Illegal Server Event Triggerd", category = WaveShield.Categories.MAIN },
    ANTI_RESOURCE_STOP = { name = "AntiResourceStop", message = "Resource Stop Detected", category = WaveShield.Categories.MAIN },
    ANTI_WAVESHIELD_STOP = { name = "AntiResourceStop", message = "WaveShield Stop Detected", category = WaveShield.Categories.MAIN },
    ANTI_RESOURCE_INJECTION = { name = "AntiResourceInjection", message = "Resource Injection Detected", category = WaveShield.Categories.MAIN },
    ANTI_CLEAR_TASKS = { name = "AntiClearTasks", message = "Clear Tasks Detected", category = WaveShield.Categories.MAIN },
    ANTI_DEV_TOOLS = { name = "AntiDevTools", message = "Dev Tools Detected", category = WaveShield.Categories.MAIN },
    ANTI_VOICE_EXPLOITS = { name = "AntiVoiceExploits", message = "Voice Exploits Detected", category = WaveShield.Categories.MAIN },

    -- Weapons category detections
    ANTI_AIM_BOT = { name = "AntiAimBot", message = "AimBot Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_WEAPON_SPAWNER = { name = "AntiWeaponSpawner", message = "Illegal Weapon Spawn Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_WEAPON_SPOOF = { name = "AntiWeaponSpawner", message = "Spoofed Weapon Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_GIVE_WEAPONS = { name = "AntiGiveWeapons", message = "Illegal Weapon Give Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_REMOVE_WEAPONS = { name = "AntiRemoveWeapons", message = "Illegal Weapon Remove Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_SPOOFED_BULLETS = { name = "AntiSpoofedBullets", message = "Spoofed Bullets Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_KILL = { name = "AntiKill", message = "Illegal Kill Detected", category = WaveShield.Categories.WEAPONS },
    WEAPON_BLACKLIST = { name = "EnableWeaponsBlackList", message = "Blacklisted Weapon Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_WEAPON_COMPONENT_MODIFIER = { name = "AntiWeaponComponentModifier", message = "Weapon Component Modification Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_WEAPON_DAMAGES_MODIFIER = { name = "AntiWeaponDamagesModifier", message = "Weapon Damage Modification Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_AMMO_CHEATING = { name = "AntiAmmoCheating", message = "Ammo Cheats Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_INFINITE_AMMO = { name = "AntiInfiniteAmmo", message = "Infinite Ammo Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_NO_RELOAD = { name = "AntiNoReload", message = "No Reload Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_EXPLOSIVE_BULLETS = { name = "AntiExplosiveBullets", message = "Explosive Bullets Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_SUPER_PUNCH = { name = "AntiSuperPunch", message = "Super Punch Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_HITBOX_MODIFIER = { name = "AntiHitboxModifier", message = "Hitbox Modification Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_NO_RECOIL = { name = "AntiNoRecoil", message = "No Recoil Detected", category = WaveShield.Categories.WEAPONS },
    PROJECTILE_WHITELIST = { name = "EnableProjectilesWhiteList", message = "Blacklisted Projectile Detected", category = WaveShield.Categories.WEAPONS },
    PROJECTILE_LIMIT = { name = "EnableProjectilesLimiter", message = "Exceeded Projectile Spawn Rate", category = WaveShield.Categories.WEAPONS },

    -- Vehicles category detections
    ANTI_SPAWN_VEHICLES = { name = "EnableVehiclesAI", message = "Illegal Vehicle Spawn Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_AI_SPAWN_VEHICLES = { name = "EnableVehiclesAIv2", message = "Illegal NPC Vehicle Spawn Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_SPAWN_ISOLATED_VEHICLES = { name = "AntiSpawnIsolatedVehicles", message = "Isolated Vehicle Spawn Detected", category = WaveShield.Categories.ENTITIES },
    VEHICLE_BLACKLIST = { name = "EnableVehiclesBlackList", message = "Blacklisted Vehicle Detected", category = WaveShield.Categories.ENTITIES },
    VEHICLE_WHITELIST = { name = "EnableVehiclesWhiteList", message = "Blacklisted Vehicle Detected", category = WaveShield.Categories.ENTITIES },
    VEHICLE_LIMIT = { name = "EnableVehiclesLimiter", message = "Exceeded Vehicle Spawn Rate", category = WaveShield.Categories.ENTITIES },
    ANTI_DELETE_VEHICLES = { name = "AntiDeleteVehicles", message = "Vehicle Deletion Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_THROW_VEHICLES = { name = "AntiThrowVehicles", message = "Vehicle Throwing Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_TELEPORT_IN_VEHICLE = { name = "AntiTeleportInVehicle", message = "Vehicle Warp Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_SPEED_MODIFIER = { name = "AntiSpeedModifier", message = "Vehicle Speed Modification Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_HANDLING_MODIFIER = { name = "AntiHandlingModifier", message = "Vehicle Handling Modification Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_VEHICLE_PLATE_CHANGER = { name = "AntiVehiclePlateChanger", message = "Vehicle Plate Change Detected", category = WaveShield.Categories.ENTITIES },

    -- Peds category detections
    ANTI_SPAWN_PEDS = { name = "EnablePedsAI", message = "Illegal Ped Spawn Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_AI_SPAWN_PEDS = { name = "EnablePedsAIv2", message = "Illegal NPC Ped Spawn Detected", category = WaveShield.Categories.ENTITIES },
    PED_BLACKLIST = { name = "EnablePedsBlackList", message = "Blacklisted Ped Detected", category = WaveShield.Categories.ENTITIES },
    PED_WHITELIST = { name = "EnablePedsWhiteList", message = "Blacklisted Ped Detected", category = WaveShield.Categories.ENTITIES },
    PED_LIMIT = { name = "EnablePedsLimiter", message = "Exceeded Ped Spawn Rate", category = WaveShield.Categories.ENTITIES },

    -- Objects category detections
    ANTI_SPAWN_OBJECTS = { name = "EnableObjectsAI", message = "Illegal Object Spawn Detected", category = WaveShield.Categories.ENTITIES },
    OBJECT_BLACKLIST = { name = "EnableObjectsBlackList", message = "Blacklisted Object Detected", category = WaveShield.Categories.ENTITIES },
    OBJECT_WHITELIST = { name = "EnableObjectsWhiteList", message = "Blacklisted Object Detected", category = WaveShield.Categories.ENTITIES },
    OBJECT_LIMIT = { name = "EnableObjectsLimiter", message = "Exceeded Object Spawn Rate", category = WaveShield.Categories.ENTITIES },
    ANTI_PICKUP_SPAWN = { name = "AntiPickupSpawn", message = "Pickup Spawn Detected", category = WaveShield.Categories.ENTITIES },

    -- Explosions category detections
    ANTI_SPAWN_EXPLOSION = { name = "EnableExplosionsAI", message = "Illegal Explosion Spawn Detected", category = WaveShield.Categories.EXPLOSIONS },
    EXPLOSION_BLACKLIST = { name = "EnableExplosionsBlackList", message = "Blacklisted Explosion Detected", category = WaveShield.Categories.EXPLOSIONS },
    EXPLOSION_LIMIT = { name = "EnableExplosionsLimiter", message = "Exceeded Explosion Spawn Rate", category = WaveShield.Categories.EXPLOSIONS },
    DETECT_INVISIBLE_EXPLOSIONS = { name = "DetectInvisibleExplosions", message = "Invisible Explosion Detected", category = WaveShield.Categories.EXPLOSIONS },
    DETECT_INAUDIBLE_EXPLOSIONS = { name = "DetectInaudibleExplosions", message = "Inaudible Explosion Detected", category = WaveShield.Categories.EXPLOSIONS },

    -- Particles category detections
    ANTI_SPAWN_PARTICLE = { name = "EnableParticlesAI", message = "Illegal Particle Spawn Detected", category = WaveShield.Categories.EXPLOSIONS },
    PARTICLE_WHITELIST = { name = "EnableParticlesWhiteList", message = "Blacklisted Particle Detected", category = WaveShield.Categories.EXPLOSIONS },
    PARTICLE_SCALE = { name = "MaxParticleScale", message = "Exceeded Particle Scale Limit", category = WaveShield.Categories.EXPLOSIONS },
    ANTI_PARTICLE_ATTACHED_TO_ENTITY = { name = "DetectParticlesAttachedToEntity", message = "Entity-Attached Particles Detected", category = WaveShield.Categories.EXPLOSIONS },

    ANTI_REQUEST_CONTROL = { name = "AntiRequestControl", message = "Entity Control Attempt Detected", category = WaveShield.Categories.ENTITIES },

    -- Beta category detections
    ANTI_UNISOLATED_INJECTION = { name = "AntiUnisolatedInjection", message = "Illegal Function Execution", category = WaveShield.Categories.MAIN },
    ANTI_MAGNETO = { name = "AntiMagneto", message = "Magneto Detected", category = WaveShield.Categories.MAIN },
    ANTI_ATTACH_VEHICLES = { name = "AntiAttachVehicles", message = "Vehicle Attachment Detected", category = WaveShield.Categories.ENTITIES },
    ANTI_SILENT_AIM = { name = "AntiSilentAim", message = "Silent Aim Detected", category = WaveShield.Categories.WEAPONS },
    ANTI_MAGIC_BULLETS = { name = "AntiSilentAim", message = "Magic Bullets Detected", category = WaveShield.Categories.WEAPONS },
}

WaveShield.StrikesSystem = {}

-- Internal storage for strikes and first strike times
local playerStrikes = {}
local firstStrikeTimes = {}

--[[
    Creates a strike system for a specific detection
    @param detectionName string - Unique name for the detection
    @param strikesNeeded number - Number of strikes needed to trigger the flag
    @param onFlag function - Function to call when strikes threshold is reached (receives playerId, strikes, detectionName)
    @param timeWindowMs number - Optional time window in ms to get strikes within (nil = no time limit)
    @return function - Strike function that takes playerId as parameter
]]
function WaveShield.StrikesSystem.createStrikeSystem(detectionName, strikesNeeded, onFlag, timeWindowMs)
    -- Validate parameters
    if not WaveShield.TypeCheck.isString(detectionName) then
        error("detectionName must be a string")
    end
    if not WaveShield.TypeCheck.isNumber(strikesNeeded) or strikesNeeded <= 0 then
        error("strikesNeeded must be a positive number")
    end
    if WaveShield.type(onFlag) ~= "function" then
        error("onFlag must be a function")
    end

    -- Validate time window parameters if provided
    if timeWindowMs ~= nil then
        if not WaveShield.TypeCheck.isNumber(timeWindowMs) or timeWindowMs <= 0 then
            error("timeWindowMs must be a positive number or nil")
        end
    end

    -- Initialize storage for this detection if not exists
    if not playerStrikes[detectionName] then
        playerStrikes[detectionName] = {}
    end
    if not firstStrikeTimes[detectionName] then
        firstStrikeTimes[detectionName] = {}
    end

    -- Return the strike function
    return function(playerId, ...)
        -- Auto-detect player ID if not provided and on client side
        if playerId == nil then
            if not IsDuplicityVersion() then
                -- Client side - use local player's server ID
                playerId = WaveShield.serverId
            else
                -- Server side - player ID is required
                error("playerId is required on server side")
            end
        end

        local currentTime = GetGameTimer()
        playerId = tonumber(playerId)

        if not WaveShield.TypeCheck.isNumber(playerId) then
            error("playerId must be a number")
        end

        -- Initialize player data if not exists
        if not playerStrikes[detectionName][playerId] then
            playerStrikes[detectionName][playerId] = 0
        end

        -- Check if we need to reset strikes based on time window
        if timeWindowMs and playerStrikes[detectionName][playerId] > 0 then
            local timeSinceFirstStrike = currentTime - firstStrikeTimes[detectionName][playerId]
            if timeSinceFirstStrike >= timeWindowMs then
                -- Time window expired, reset strikes and start new window
                playerStrikes[detectionName][playerId] = 0
                firstStrikeTimes[detectionName][playerId] = nil
            end
        end

        -- Set first strike time if this is the first strike
        if playerStrikes[detectionName][playerId] == 0 then
            firstStrikeTimes[detectionName][playerId] = currentTime
        end

        -- Add the new strike
        playerStrikes[detectionName][playerId] = playerStrikes[detectionName][playerId] + 1
        local currentStrikes = playerStrikes[detectionName][playerId]

        -- Check if strikes threshold reached
        if currentStrikes >= strikesNeeded then
            -- Reset strikes after flagging
            playerStrikes[detectionName][playerId] = 0
            firstStrikeTimes[detectionName][playerId] = nil
            -- Call the flag function
            onFlag(playerId, ...)
        end

        return currentStrikes
    end
end

--[[
    Gets current strikes for a player and detection
    @param detectionName string - Name of the detection
    @param playerId number - Player ID (optional on client side)
    @return number - Current strike count
]]
function WaveShield.StrikesSystem.getStrikes(detectionName, playerId)
    -- Auto-detect player ID if not provided and on client side
    if playerId == nil then
        if not IsDuplicityVersion() then
            playerId = WaveShield.serverId
        else
            error("playerId is required on server side")
        end
    end

    if not playerStrikes[detectionName] or not playerStrikes[detectionName][playerId] then
        return 0
    end
    return playerStrikes[detectionName][playerId]
end

--[[
    Resets strikes for a player and detection
    @param detectionName string - Name of the detection
    @param playerId number - Player ID (optional on client side)
]]
function WaveShield.StrikesSystem.resetStrikes(detectionName, playerId)
    -- Auto-detect player ID if not provided and on client side
    if playerId == nil then
        if not IsDuplicityVersion() then
            playerId = WaveShield.serverId
        else
            error("playerId is required on server side")
        end
    end

    if playerStrikes[detectionName] and playerStrikes[detectionName][playerId] then
        playerStrikes[detectionName][playerId] = 0
    end
    if firstStrikeTimes[detectionName] and firstStrikeTimes[detectionName][playerId] then
        firstStrikeTimes[detectionName][playerId] = nil
    end
end

--[[
    Clears all strikes and timeouts for a player (useful when player disconnects)
    @param playerId number - Player ID
]]
function WaveShield.StrikesSystem.clearPlayerStrikes(playerId)
    for detectionName, _ in pairs(playerStrikes) do
        if playerStrikes[detectionName][playerId] then
            playerStrikes[detectionName][playerId] = nil
        end
        if firstStrikeTimes[detectionName] and firstStrikeTimes[detectionName][playerId] then
            firstStrikeTimes[detectionName][playerId] = nil
        end
    end
end

if IsDuplicityVersion() then
    AddEventHandler("playerDropped", function(reason)
        local source = source
        WaveShield.StrikesSystem.clearPlayerStrikes(source)
    end)
end

WaveShield.WEAPON_DATA = LPH_NO_VIRTUALIZE(function()
    local weaponList = {
        { "WEAPON_UNARMED",               0.0 },
        { "WEAPON_KNIFE",                 0.0 },
        { "WEAPON_NIGHTSTICK",            0.0 },
        { "WEAPON_HAMMER",                0.0 },
        { "WEAPON_BAT",                   0.0 },
        { "WEAPON_GOLFCLUB",              0.0 },
        { "WEAPON_CROWBAR",               0.0 },
        { "WEAPON_PISTOL",                26.0 },
        { "WEAPON_COMBATPISTOL",          27.0 },
        { "WEAPON_APPISTOL",              25.0 },
        { "WEAPON_PISTOL50",              51.0 },
        { "WEAPON_MICROSMG",              21.0 },
        { "WEAPON_SMG",                   22.0 },
        { "WEAPON_ASSAULTSMG",            23.0 },
        { "WEAPON_ASSAULTRIFLE",          30.0 },
        { "WEAPON_CARBINERIFLE",          32.0 },
        { "WEAPON_ADVANCEDRIFLE",         34.0 },
        { "WEAPON_MG",                    40.0 },
        { "WEAPON_COMBATMG",              45.0 },
        { "WEAPON_PUMPSHOTGUN",           29.0 },
        { "WEAPON_SAWNOFFSHOTGUN",        40.0 },
        { "WEAPON_ASSAULTSHOTGUN",        32.0 },
        { "WEAPON_BULLPUPSHOTGUN",        14.0 },
        { "WEAPON_STUNGUN",               1.0 },
        { "WEAPON_SNIPERRIFLE",           101.0 },
        { "WEAPON_HEAVYSNIPER",           216.0 },
        { "WEAPON_REMOTESNIPER",          101.0 },
        { "WEAPON_GRENADELAUNCHER",       0.0 },
        { "WEAPON_GRENADELAUNCHER_SMOKE", 0.0 },
        { "WEAPON_RPG",                   0.0 },
        { "WEAPON_MINIGUN",               30.0 },
        { "WEAPON_GRENADE",               0.0 },
        { "WEAPON_STICKYBOMB",            0.0 },
        { "WEAPON_SMOKEGRENADE",          0.0 },
        { "WEAPON_BZGAS",                 0.0 },
        { "WEAPON_MOLOTOV",               0.0 },
        { "WEAPON_FIREEXTINGUISHER",      0.0 },
        { "WEAPON_PETROLCAN",             0.0 },
        { "WEAPON_BALL",                  0.0 },
        { "WEAPON_FLARE",                 0.0 },
        { "WEAPON_BOTTLE",                0.0 },
        { "WEAPON_SNSPISTOL",             28.0 },
        { "WEAPON_HEAVYPISTOL",           40.0 },
        { "WEAPON_BULLPUPRIFLE",          32.0 },
        { "WEAPON_SPECIALCARBINE",        32.0 },
        { "WEAPON_SNSPISTOL_MK2",         30.0 },
        { "WEAPON_SPECIALCARBINE_MK2",    32.5 },
        { "WEAPON_PUMPSHOTGUN_MK2",       32.0 },
        { "WEAPON_BULLPUPRIFLE_MK2",      33.0 },
        { "WEAPON_MARKSMANRIFLE_MK2",     75.0 },
        { "WEAPON_CANDYCANE",             0.0 },
        { "WEAPON_PISTOLXM3",             35.0 },
        { "WEAPON_RAILGUNXM3",            25.0 },
        { "WEAPON_ACIDPACKAGE",           0.0 },
        { "WEAPON_HOMINGLAUNCHER",        0.0 },
        { "WEAPON_PROXMINE",              0.0 },
        { "WEAPON_SNOWBALL",              0.0 },
        { "WEAPON_DOUBLEACTION",          81.0 },
        { "WEAPON_REVOLVER_MK2",          200.0 },
        { "WEAPON_RAYPISTOL",             10.0 },
        { "WEAPON_RAYCARBINE",            45.0 },
        { "WEAPON_RAYMINIGUN",            30.0 },
        { "WEAPON_GUSENBERG",             34.0 },
        { "WEAPON_DAGGER",                0.0 },
        { "WEAPON_VINTAGEPISTOL",         34.0 },
        { "WEAPON_FIREWORK",              0.0 },
        { "WEAPON_MUSKET",                165.0 },
        { "WEAPON_HATCHET",               0.0 },
        { "WEAPON_RAILGUN",               30.0 },
        { "WEAPON_MARKSMANRIFLE",         65.0 },
        { "WEAPON_HEAVYSHOTGUN",          117.0 },
        { "WEAPON_CERAMICPISTOL",         32.0 },
        { "WEAPON_MILITARYRIFLE",         37.5 },
        { "WEAPON_GADGETPISTOL",          195.0 },
        { "WEAPON_HAZARDCAN",             0.0 },
        { "WEAPON_COMBATSHOTGUN",         31.0 },
        { "WEAPON_NAVYREVOLVER",          160.0 },
        { "WEAPON_FLAREGUN",              10.0 },
        { "WEAPON_KNUCKLE",               0.0 },
        { "WEAPON_COMBATPDW",             28.0 },
        { "WEAPON_MARKSMANPISTOL",        220.0 },
        { "WEAPON_DBSHOTGUN",             30.0 },
        { "WEAPON_COMPACTRIFLE",          34.0 },
        { "WEAPON_MACHINEPISTOL",         27.0 },
        { "WEAPON_MACHETE",               0.0 },
        { "WEAPON_FLASHLIGHT",            0.0 },
        { "WEAPON_SWITCHBLADE",           0.0 },
        { "WEAPON_REVOLVER",              160.0 },
        { "WEAPON_WRENCH",                0.0 },
        { "WEAPON_POOLCUE",               0.0 },
        { "WEAPON_MINISMG",               22.0 },
        { "WEAPON_BATTLEAXE",             0.0 },
        { "WEAPON_AUTOSHOTGUN",           27.0 },
        { "WEAPON_COMPACTLAUNCHER",       0.0 },
        { "WEAPON_PIPEBOMB",              0.0 },
        { "WEAPON_SMG_MK2",               25.0 },
        { "WEAPON_COMBATMG_MK2",          47.0 },
        { "WEAPON_CARBINERIFLE_MK2",      33.0 },
        { "WEAPON_ASSAULTRIFLE_MK2",      40.0 },
        { "WEAPON_HEAVYSNIPER_MK2",       230.0 },
        { "WEAPON_PISTOL_MK2",            32.0 },
        { "WEAPON_STONE_HATCHET",         0.0 },
        { "WEAPON_TACTICALRIFLE",         34.75 },
        { "WEAPON_PRECISIONRIFLE",        101.0 },
        { "WEAPON_HEAVYRIFLE",            34.0 },
        { "WEAPON_FERTILIZERCAN",         0.0 },
        { "WEAPON_EMPLAUNCHER",           0.0 },
        { "WEAPON_STUNGUN_MP",            20.0 },
        { "WEAPON_TECPISTOL",             25.0 },
        { "WEAPON_SNOWLAUNCHER",          0.0 },
        { "WEAPON_HACKINGDEVICE",         0.0 },
        { "WEAPON_BATTLERIFLE",           38.0 },
        { "WEAPON_STUNROD",               0.0 },
        { "WEAPON_STRICKLER",             0.0 },
        { "WEAPON_BRIEFCASE_03",          0.0 },
    }

    local weaponData = {}

    for i = 1, #weaponList do
        local name = weaponList[i][1]
        local damage = weaponList[i][2]
        local hash = GetHashKey(name)
        local unsignedHash = signedToUnsigned(hash)

        weaponData[i] = {
            weaponName = name,
            weaponHash = hash,
            weaponUnsignedHash = unsignedHash,
            weaponDamages = damage
        }

        weaponData[hash] = weaponData[i]
        weaponData[unsignedHash] = weaponData[i]
        weaponData[name] = weaponData[i]
    end

    return weaponData
end)()

WaveShield.VEHICLE_DATA = LPH_NO_VIRTUALIZE(function()
    local vehicleList = {
        "adder",
        "airbus",
        "airtug",
        "akula",
        "akuma",
        "aleutian",
        "alkonost",
        "alpha",
        "alphaz1",
        "ambulance",
        "annihilator",
        "annihilator2",
        "apc",
        "arbitergt",
        "ardent",
        "armytanker",
        "armytrailer",
        "armytrailer2",
        "asbo",
        "asea",
        "asea2",
        "asterope",
        "asterope2",
        "astron",
        "astron2",
        "autarch",
        "avarus",
        "avenger",
        "avenger2",
        "avenger3",
        "avenger4",
        "avisa",
        "bagger",
        "baletrailer",
        "baller",
        "baller2",
        "baller3",
        "baller4",
        "baller5",
        "baller6",
        "baller7",
        "baller8",
        "banshee",
        "banshee2",
        "banshee3",
        "barracks",
        "barracks2",
        "barracks3",
        "barrage",
        "bati",
        "bati2",
        "benson",
        "benson2",
        "besra",
        "bestiagts",
        "bf400",
        "bfinjection",
        "biff",
        "bifta",
        "bison",
        "bison2",
        "bison3",
        "bjxl",
        "blade",
        "blazer",
        "blazer2",
        "blazer3",
        "blazer4",
        "blazer5",
        "blimp",
        "blimp2",
        "blimp3",
        "blista",
        "blista2",
        "blista3",
        "bmx",
        "boattrailer",
        "bobcatxl",
        "bodhi2",
        "bombushka",
        "boor",
        "boxville",
        "boxville2",
        "boxville3",
        "boxville4",
        "boxville5",
        "boxville6",
        "brawler",
        "brickade",
        "brickade2",
        "brigham",
        "brioso",
        "brioso2",
        "brioso3",
        "broadway",
        "bruiser",
        "bruiser2",
        "bruiser3",
        "brutus",
        "brutus2",
        "brutus3",
        "btype",
        "btype2",
        "btype3",
        "buccaneer",
        "buccaneer2",
        "buffalo",
        "buffalo2",
        "buffalo3",
        "buffalo4",
        "buffalo5",
        "bulldozer",
        "bullet",
        "burrito",
        "burrito2",
        "burrito3",
        "burrito4",
        "burrito5",
        "bus",
        "buzzard",
        "buzzard2",
        "cablecar",
        "caddy",
        "caddy2",
        "caddy3",
        "calico",
        "camper",
        "caracara",
        "caracara2",
        "carbonizzare",
        "carbonrs",
        "cargobob",
        "cargobob2",
        "cargobob3",
        "cargobob4",
        "cargobob5",
        "cargoplane",
        "cargoplane2",
        "casco",
        "castigator",
        "cavalcade",
        "cavalcade2",
        "cavalcade3",
        "cerberus",
        "cerberus2",
        "cerberus3",
        "champion",
        "chavosv6",
        "cheburek",
        "cheetah",
        "cheetah2",
        "cheetah3",
        "chernobog",
        "chimera",
        "chino",
        "chino2",
        "cinquemila",
        "cliffhanger",
        "clique",
        "clique2",
        "club",
        "coach",
        "cog55",
        "cog552",
        "cogcabrio",
        "cognoscenti",
        "cognoscenti2",
        "comet2",
        "comet3",
        "comet4",
        "comet5",
        "comet6",
        "comet7",
        "conada",
        "conada2",
        "contender",
        "coquette",
        "coquette2",
        "coquette3",
        "coquette4",
        "coquette5",
        "coquette6",
        "corsita",
        "coureur",
        "cruiser",
        "crusader",
        "cuban800",
        "cutter",
        "cyclone",
        "cyclone2",
        "cypher",
        "daemon",
        "daemon2",
        "deathbike",
        "deathbike2",
        "deathbike3",
        "defiler",
        "deity",
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
        "deluxo",
        "deveste",
        "deviant",
        "diablous",
        "diablous2",
        "dilettante",
        "dilettante2",
        "dinghy",
        "dinghy2",
        "dinghy3",
        "dinghy4",
        "dinghy5",
        "dloader",
        "docktrailer",
        "docktug",
        "dodo",
        "dominator",
        "dominator10",
        "dominator2",
        "dominator3",
        "dominator4",
        "dominator5",
        "dominator6",
        "dominator7",
        "dominator8",
        "dominator9",
        "dorado",
        "double",
        "drafter",
        "draugur",
        "driftchavosv6",
        "driftcheburek",
        "driftcypher",
        "driftdominator10",
        "drifteuros",
        "driftfr36",
        "driftfuto",
        "driftfuto2",
        "driftgauntlet4",
        "drifthardy",
        "driftjester",
        "driftjester3",
        "driftl352",
        "driftnebula",
        "driftremus",
        "driftsentinel",
        "drifttampa",
        "driftvorschlag",
        "driftyosemite",
        "driftzr350",
        "dubsta",
        "dubsta2",
        "dubsta3",
        "dukes",
        "dukes2",
        "dukes3",
        "dump",
        "dune",
        "dune2",
        "dune3",
        "dune4",
        "dune5",
        "duster",
        "duster2",
        "dynasty",
        "elegy",
        "elegy2",
        "ellie",
        "emerus",
        "emperor",
        "emperor2",
        "emperor3",
        "enduro",
        "entity2",
        "entity3",
        "entityxf",
        "envisage",
        "esskey",
        "eudora",
        "euros",
        "eurosx32",
        "everon",
        "everon2",
        "everon3",
        "exemplar",
        "f620",
        "faction",
        "faction2",
        "faction3",
        "fagaloa",
        "faggio",
        "faggio2",
        "faggio3",
        "fbi",
        "fbi2",
        "fcr",
        "fcr2",
        "felon",
        "felon2",
        "feltzer2",
        "feltzer3",
        "firebolt",
        "firetruk",
        "fixter",
        "flashgt",
        "flatbed",
        "flatbed2",
        "fmj",
        "forklift",
        "formula",
        "formula2",
        "fq2",
        "fr36",
        "freecrawler",
        "freight",
        "freight2",
        "freightcar",
        "freightcar2",
        "freightcar3",
        "freightcont1",
        "freightcont2",
        "freightgrain",
        "freighttrailer",
        "frogger",
        "frogger2",
        "fugitive",
        "furia",
        "furoregt",
        "fusilade",
        "futo",
        "futo2",
        "gargoyle",
        "gauntlet",
        "gauntlet2",
        "gauntlet3",
        "gauntlet4",
        "gauntlet5",
        "gauntlet6",
        "gb200",
        "gburrito",
        "gburrito2",
        "glendale",
        "glendale2",
        "gp1",
        "graintrailer",
        "granger",
        "granger2",
        "greenwood",
        "gresley",
        "growler",
        "gt500",
        "guardian",
        "habanero",
        "hakuchou",
        "hakuchou2",
        "halftrack",
        "handler",
        "hardy",
        "hauler",
        "hauler2",
        "havok",
        "hellion",
        "hermes",
        "hexer",
        "hotknife",
        "hotring",
        "howard",
        "hunter",
        "huntley",
        "hustler",
        "hydra",
        "ignus",
        "ignus2",
        "imorgon",
        "impaler",
        "impaler2",
        "impaler3",
        "impaler4",
        "impaler5",
        "impaler6",
        "imperator",
        "imperator2",
        "imperator3",
        "inductor",
        "inductor2",
        "infernus",
        "infernus2",
        "ingot",
        "innovation",
        "insurgent",
        "insurgent2",
        "insurgent3",
        "intruder",
        "issi2",
        "issi3",
        "issi4",
        "issi5",
        "issi6",
        "issi7",
        "issi8",
        "italigtb",
        "italigtb2",
        "italigto",
        "italirsx",
        "iwagen",
        "jackal",
        "jb700",
        "jb7002",
        "jester",
        "jester2",
        "jester3",
        "jester4",
        "jester5",
        "jet",
        "jetmax",
        "journey",
        "journey2",
        "jubilee",
        "jugular",
        "kalahari",
        "kamacho",
        "kanjo",
        "kanjosj",
        "khamelion",
        "khanjali",
        "komoda",
        "kosatka",
        "krieger",
        "kuruma",
        "kuruma2",
        "l35",
        "l352",
        "landstalker",
        "landstalker2",
        "lazer",
        "le7b",
        "lectro",
        "lguard",
        "limo2",
        "lm87",
        "locust",
        "longfin",
        "lurcher",
        "luxor",
        "luxor2",
        "lynx",
        "mamba",
        "mammatus",
        "manana",
        "manana2",
        "manchez",
        "manchez2",
        "manchez3",
        "marquis",
        "marshall",
        "massacro",
        "massacro2",
        "maverick",
        "maverick2",
        "menacer",
        "mesa",
        "mesa2",
        "mesa3",
        "metrotrain",
        "michelli",
        "microlight",
        "miljet",
        "minimus",
        "minitank",
        "minivan",
        "minivan2",
        "mixer",
        "mixer2",
        "mogul",
        "molotok",
        "monroe",
        "monster",
        "monster3",
        "monster4",
        "monster5",
        "monstrociti",
        "moonbeam",
        "moonbeam2",
        "mower",
        "mule",
        "mule2",
        "mule3",
        "mule4",
        "mule5",
        "nebula",
        "nemesis",
        "neo",
        "neon",
        "nero",
        "nero2",
        "nightblade",
        "nightshade",
        "nightshark",
        "nimbus",
        "ninef",
        "ninef2",
        "niobe",
        "nokota",
        "novak",
        "omnis",
        "omnisegt",
        "openwheel1",
        "openwheel2",
        "oppressor",
        "oppressor2",
        "oracle",
        "oracle2",
        "osiris",
        "outlaw",
        "packer",
        "panthere",
        "panto",
        "paradise",
        "paragon",
        "paragon2",
        "paragon3",
        "pariah",
        "patriot",
        "patriot2",
        "patriot3",
        "patrolboat",
        "pbus",
        "pbus2",
        "pcj",
        "penetrator",
        "penumbra",
        "penumbra2",
        "peyote",
        "peyote2",
        "peyote3",
        "pfister811",
        "phantom",
        "phantom2",
        "phantom3",
        "phantom4",
        "phoenix",
        "picador",
        "pigalle",
        "pipistrello",
        "pizzaboy",
        "polcaracara",
        "polcoquette4",
        "poldominator10",
        "poldorado",
        "polfaction2",
        "polgauntlet",
        "polgreenwood",
        "police",
        "police2",
        "police3",
        "police4",
        "police5",
        "policeb",
        "policeb2",
        "policeold1",
        "policeold2",
        "policet",
        "policet3",
        "polimpaler5",
        "polimpaler6",
        "polmav",
        "polterminus",
        "pony",
        "pony2",
        "postlude",
        "pounder",
        "pounder2",
        "powersurge",
        "prairie",
        "pranger",
        "predator",
        "premier",
        "previon",
        "primo",
        "primo2",
        "proptrailer",
        "prototipo",
        "pyro",
        "r300",
        "radi",
        "raiden",
        "raiju",
        "raketrailer",
        "rallytruck",
        "rancherxl",
        "rancherxl2",
        "rapidgt",
        "rapidgt2",
        "rapidgt3",
        "rapidgt4",
        "raptor",
        "ratbike",
        "ratel",
        "ratloader",
        "ratloader2",
        "rcbandito",
        "reaper",
        "rebel",
        "rebel2",
        "rebla",
        "reever",
        "regina",
        "remus",
        "rentalbus",
        "retinue",
        "retinue2",
        "revolter",
        "rhapsody",
        "rhinehart",
        "rhino",
        "riata",
        "riot",
        "riot2",
        "ripley",
        "rocoto",
        "rogue",
        "romero",
        "rrocket",
        "rt3000",
        "rubble",
        "ruffian",
        "ruiner",
        "ruiner2",
        "ruiner3",
        "ruiner4",
        "rumpo",
        "rumpo2",
        "rumpo3",
        "ruston",
        "s80",
        "s95",
        "sabregt",
        "sabregt2",
        "sadler",
        "sadler2",
        "sanchez",
        "sanchez2",
        "sanctus",
        "sandking",
        "sandking2",
        "savage",
        "savestra",
        "sc1",
        "scarab",
        "scarab2",
        "scarab3",
        "schafter2",
        "schafter3",
        "schafter4",
        "schafter5",
        "schafter6",
        "schlagen",
        "schwarzer",
        "scorcher",
        "scramjet",
        "scrap",
        "seabreeze",
        "seashark",
        "seashark2",
        "seashark3",
        "seasparrow",
        "seasparrow2",
        "seasparrow3",
        "seminole",
        "seminole2",
        "sentinel",
        "sentinel2",
        "sentinel3",
        "sentinel4",
        "sentinel5",
        "serrano",
        "seven70",
        "shamal",
        "sheava",
        "sheriff",
        "sheriff2",
        "shinobi",
        "shotaro",
        "skylift",
        "slamtruck",
        "slamvan",
        "slamvan2",
        "slamvan3",
        "slamvan4",
        "slamvan5",
        "slamvan6",
        "sm722",
        "sovereign",
        "specter",
        "specter2",
        "speeder",
        "speeder2",
        "speedo",
        "speedo2",
        "speedo4",
        "speedo5",
        "squaddie",
        "squalo",
        "stafford",
        "stalion",
        "stalion2",
        "stanier",
        "starling",
        "stinger",
        "stingergt",
        "stingertt",
        "stockade",
        "stockade3",
        "stockade4",
        "stratum",
        "streamer216",
        "streiter",
        "stretch",
        "strikeforce",
        "stromberg",
        "stryder",
        "stunt",
        "submersible",
        "submersible2",
        "sugoi",
        "sultan",
        "sultan2",
        "sultan3",
        "sultanrs",
        "suntrap",
        "superd",
        "supervolito",
        "supervolito2",
        "surano",
        "surfer",
        "surfer2",
        "surfer3",
        "surge",
        "suzume",
        "swift",
        "swift2",
        "swinger",
        "t20",
        "taco",
        "tahoma",
        "tailgater",
        "tailgater2",
-- ZGlzY29yZC5nZy9mbWE=
        "taipan",
        "tampa",
        "tampa2",
        "tampa3",
        "tampa4",
        "tanker",
        "tanker2",
        "tankercar",
        "taxi",
        "technical",
        "technical2",
        "technical3",
        "tempesta",
        "tenf",
        "tenf2",
        "terbyte",
        "terminus",
        "tezeract",
        "thrax",
        "thrust",
        "thruster",
        "tigon",
        "tiptruck",
        "tiptruck2",
        "titan",
        "titan2",
        "toreador",
        "torero",
        "torero2",
        "tornado",
        "tornado2",
        "tornado3",
        "tornado4",
        "tornado5",
        "tornado6",
        "toro",
        "toro2",
        "toros",
        "tourbus",
        "towtruck",
        "towtruck2",
        "towtruck3",
        "towtruck4",
        "tr2",
        "tr3",
        "tr4",
        "tractor",
        "tractor2",
        "tractor3",
        "trailerlarge",
        "trailerlogs",
        "trailers",
        "trailers2",
        "trailers3",
        "trailers4",
        "trailersmall",
        "trailersmall2",
        "trash",
        "trash2",
        "trflat",
        "tribike",
        "tribike2",
        "tribike3",
        "trophytruck",
        "trophytruck2",
        "tropic",
        "tropic2",
        "tropos",
        "tug",
        "tula",
        "tulip",
        "tulip2",
        "turismo2",
        "turismo3",
        "turismor",
        "tvtrailer",
        "tyrant",
        "tyrus",
        "uranus",
        "utillitruck",
        "utillitruck2",
        "utillitruck3",
        "vacca",
        "vader",
        "vagner",
        "vagrant",
        "valkyrie",
        "valkyrie2",
        "vamos",
        "vectre",
        "velum",
        "velum2",
        "verlierer2",
        "verus",
        "vestra",
        "vetir",
        "veto",
        "veto2",
        "vigero",
        "vigero2",
        "vigero3",
        "vigilante",
        "vindicator",
        "virgo",
        "virgo2",
        "virgo3",
        "virtue",
        "viseris",
        "visione",
        "vivanite",
        "volatol",
        "volatus",
        "voltic",
        "voltic2",
        "voodoo",
        "voodoo2",
        "vorschlaghammer",
        "vortex",
        "vstr",
        "warrener",
        "warrener2",
        "washington",
        "wastelander",
        "weevil",
        "weevil2",
        "windsor",
        "windsor2",
        "winky",
        "wolfsbane",
        "woodlander",
        "xa21",
        "xls",
        "xls2",
        "yosemite",
        "yosemite1500",
        "yosemite2",
        "yosemite3",
        "youga",
        "youga2",
        "youga3",
        "youga4",
        "youga5",
        "z190",
        "zeno",
        "zentorno",
        "zhaba",
        "zion",
        "zion2",
        "zion3",
        "zombiea",
        "zombieb",
        "zorrusso",
        "zr350",
        "zr380",
        "zr3802",
        "zr3803",
        "ztype",
    }

    local vehicleData = {}

    for i = 1, #vehicleList do
        local name = vehicleList[i]
        local hash = GetHashKey(name)

        vehicleData[i] = {
            vehicleName = name,
            vehicleHash = hash,
        }

        vehicleData[hash] = vehicleData[i]
        vehicleData[name] = vehicleData[i]
    end

    return vehicleData
end)()

WaveShield.EXPLOSION_DATA = LPH_NO_VIRTUALIZE(function()
    local explosionList = {
        "Grenade",
        "Grenade Launcher",
        "Sticky Bomb",
        "Molotov",
        "Rocket",
        "TankShell",
        "Hi_Octane",
        "Car",
        "Plane",
        "PetrolPump",
        "Bike",
        "Dir_Steam",
        "Dir_Flame",
        "Dir_Water_Hydrant",
        "Dir_Gas_Canister",
        "Boat",
        "Ship_Destroy",
        "Truck",
        "Bullet",
        "SmokeGrenadeLauncher",
        "SmokeGrenade",
        "BZGAS",
        "Flare",
        "Gas_Canister",
        "Extinguisher",
        "Programmablear",
        "Train",
        "Barrel",
        "PROPANE",
        "Blimp",
        "Dir_Flame_Explode",
        "Tanker",
        "PlaneRocket",
        "VehicleBullet",
        "Gas_Tank",
        "EXP_TAG_BIRD_CRAP",
        "EXP_TAG_RAILGUN",
        "EXP_TAG_BLIMP2",
        "EXP_TAG_FIREWORK",
        "EXP_TAG_SNOWBALL",
        "EXP_TAG_PROXMINE",
        "EXP_TAG_VALKYRIE_CANNON",
        "EXP_TAG_AIR_DEFENCE",
        "EXP_TAG_PIPEBOMB",
        "EXP_TAG_VEHICLEMINE",
        "EXP_TAG_EXPLOSIVEAMMO",
        "EXP_TAG_APCSHELL",
        "EXP_TAG_BOMB_CLUSTER",
        "EXP_TAG_BOMB_GAS",
        "EXP_TAG_BOMB_INCENDIARY",
        "EXP_TAG_BOMB_STANDARD",
        "EXP_TAG_TORPEDO",
        "EXP_TAG_TORPEDO_UNDERWATER",
        "EXP_TAG_BOMBUSHKA_CANNON",
        "EXP_TAG_BOMB_CLUSTER_SECONDARY",
        "EXP_TAG_HUNTER_BARRAGE",
        "EXP_TAG_HUNTER_CANNON",
        "EXP_TAG_ROGUE_CANNON",
        "EXP_TAG_MINE_UNDERWATER",
        "EXP_TAG_ORBITAL_CANNON",
        "EXP_TAG_BOMB_STANDARD_WIDE",
        "EXP_TAG_EXPLOSIVEAMMO_SHOTGUN",
        "EXP_TAG_OPPRESSOR2_CANNON",
        "EXP_TAG_MORTAR_KINETIC",
        "EXP_TAG_VEHICLEMINE_KINETIC",
        "EXP_TAG_VEHICLEMINE_EMP",
        "EXP_TAG_VEHICLEMINE_SPIKE",
        "EXP_TAG_VEHICLEMINE_SLICK",
        "EXP_TAG_VEHICLEMINE_TAR",
        "EXP_TAG_SCRIPT_DRONE",
        "EXP_TAG_RAYGUN",
        "EXP_TAG_BURIEDMINE",
        "EXP_TAG_SCRIPT_MISSILE",
        "EXP_TAG_RCTANK_ROCKET",
        "EXP_TAG_BOMB_WATER",
        "EXP_TAG_BOMB_WATER_SECONDARY",
        "_0xF728C4A9",
        "_0xBAEC056F",
        "EXP_TAG_FLASHGRENADE",
        "EXP_TAG_STUNGRENADE",
        "_0x763D3B3B",
        "EXP_TAG_SCRIPT_MISSILE_LARGE",
        "EXP_TAG_SUBMARINE_BIG",
        "EMPLAUNCHER_EMP",
    }

    local explosionData = {}

    for i = 1, #explosionList do
        local name = explosionList[i]
        local index = i - 1

        explosionData[index] = {
            explosionName = name,
            explosionType = index,
        }

        explosionData[name] = explosionData[index]
    end

    return explosionData
end)()

WaveShield.GetExplosionName = LPH_NO_VIRTUALIZE(function(explosionType)
    local explosionData = WaveShield.EXPLOSION_DATA[explosionType]
    return explosionData and explosionData.explosionName or explosionType
end)

WaveShield.GetVehicleName = LPH_NO_VIRTUALIZE(function(vehicleIndex)
    local vehicleData = WaveShield.VEHICLE_DATA[vehicleIndex]
    return vehicleData and vehicleData.vehicleName or vehicleIndex
end)

WaveShield.GetWeaponName = LPH_NO_VIRTUALIZE(function(weaponIndex)
    local weaponData = WaveShield.WEAPON_DATA[weaponIndex]
    return weaponData and weaponData.weaponName or weaponIndex
end)
