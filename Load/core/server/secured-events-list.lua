local protectedEvents = {}

exports("IsEventProtected", function(eventName)
  local resourceName = GetInvokingResource()
  if not resourceName then return end
  
  return protectedEvents[eventName..":"..resourceName] ~= nil
end)

AddEventHandler("__WaveShield_internal:protectEvent", function(eventName)
  local resourceName = GetInvokingResource()
  if not resourceName then return end

  protectedEvents[eventName..":"..resourceName] = true
-- ZGlzY29yZC5nZy9mbWE=
end)