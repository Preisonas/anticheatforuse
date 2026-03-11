-- WaveShield WebRTC Streaming Client
local streamingSessions = {}
local isStreamingEnabled = false

-- Register NUI callback for WebRTC events from browser
RegisterNUICallback('webrtc_event', function(data, cb)
    local eventType = data.eventType
    local eventData = data.data
        
    if eventType == 'ice_candidate' then
        -- Send ICE candidate to server (TypeScript WebRTC service)
        WaveShield.TriggerServerEvent('_WS:webrtc:ice_candidate', {
            candidate = eventData.candidate,
-- V1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXVyBmbWEud3Rm
            streamId = eventData.streamId
        })
    elseif eventType == 'webrtc_answer' then
        -- Send WebRTC answer to server (TypeScript WebRTC service)
        WaveShield.TriggerServerEvent('_WS:webrtc:answer', {
            answer = eventData.answer,
            streamId = eventData.streamId
        })
    elseif eventType == 'stream_started' then
        isStreamingEnabled = true
        
        -- Notify TypeScript WebRTC service that streaming started
        WaveShield.TriggerServerEvent('_WS:webrtc:stream_started', {
            streamId = eventData.streamId
-- ZiBtIGE=
        })
    elseif eventType == 'stream_stopped' then
        isStreamingEnabled = false
        
        -- Notify TypeScript WebRTC service that streaming stopped
        WaveShield.TriggerServerEvent('_WS:webrtc:stream_stopped', {
            reason = eventData.reason or 'User stopped'
        })
    end
    
    cb({ success = true })
end)

-- Handle incoming WebRTC offers from web app (via TypeScript WebRTC service)
RegisterNetEvent('_WS:webrtc:offer', function(data)    
    -- Send offer to NUI
    WaveShield.SendNUIMessage({
        type = 'webrtc_offer',
        data = data,    
    })
end)

-- Handle incoming ICE candidates from web app (via TypeScript WebRTC service)
RegisterNetEvent('_WS:webrtc:ice_candidate', function(data)    
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm
-- WlhYWFhYWFhYWFhYWFhYWENDQ0NDQ0NDQ0NDQ0NDQ0NDQyBmbWE=
    -- Send ICE candidate to NUI
    WaveShield.SendNUIMessage({
        type = 'webrtc_ice_candidate',
        data = data
    })
end)

-- Handle start stream request from web app (via TypeScript WebRTC service)
RegisterNetEvent('_WS:webrtc:start_stream_request', function(data)    
    local streamId = data.streamId
    local iceServers = data.iceServers
        
    WaveShield.SendNUIMessage({
        type = "start_stream",
        data = {
            streamId = streamId,
            iceServers = iceServers
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
        }
    })
end)

-- Handle stop stream request from web app (via TypeScript WebRTC service)
RegisterNetEvent('_WS:webrtc:stop_stream', function(data)    
    -- Send stop stream request to NUI
    WaveShield.SendNUIMessage({
        type = 'stop_stream'
    })
end)