local protectedEvents = {}

exports("IsEventProtected", LPH_NO_VIRTUALIZE(function(eventName)
  local resourceName = GetInvokingResource()
  if not resourceName then return end
  
-- WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFggZm1h
  local isExport = eventName:find("__cfx_export_")
  if isExport then
    return protectedEvents[eventName] ~= nil
  end

-- UFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUCBpdHMgZm1h
  return protectedEvents[eventName..":"..resourceName] ~= nil
end))
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=

AddEventHandler("__WaveShield_internal:protectEvent", LPH_NO_VIRTUALIZE(function(eventName)
  local resourceName = GetInvokingResource()
  if not resourceName then return end

  local isExport = eventName:find("__cfx_export_")
  if isExport then
    protectedEvents[eventName] = true
    return
  end
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm
  
  protectedEvents[eventName..":"..resourceName] = true
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
end))