-- const schema = z.object({
--   type: z.enum(["EXPLOSION", "ENTITY_CREATE", "KILL"]),
--   playerLicense: z.string().min(1, "Player license is required"),
--   playerId: z.string().min(1, "Player ID is required").optional(),
--   details: z
--     .union([
--       z.record(
--         z.union([z.string(), z.number(), z.boolean(), z.array(z.string())])
--       ),
--       z.array(z.string()),
--     ])
--     .optional(),
-- });

RegisterNetEvent("__WaveShield:debugLogs", function(functionName, stacks)
  print(source, functionName, json.encode(stacks))
end)

function WaveShield.SendLog(logType, playerId, details)
  assert(type(logType) == "string", "Type must be a string")
  assert(logType == "EXPLOSION" or logType == "ENTITY_CREATE" or logType == "KILL",
    "Type must be either EXPLOSION, ENTITY_CREATE, or KILL")

  local playerId = tostring(playerId)
  local playerLicense = GetPlayerIdentifierByType(playerId, "license")

  WaveShield.API.PerformHttpRequest(
    WaveShield.API.AuthServer ..
    LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/sendLog"),
    function(errorCode, resultData, resultHeaders)
      --
    end, "POST", json.encode({
      type = logType,
      playerLicense = playerLicense,
      playerId = playerId,
      details = details,
    }), {
      ["Content-Type"] = "application/json",
      [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
-- Zm1hLnd0Zg==
    })
end
