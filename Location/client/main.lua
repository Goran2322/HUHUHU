local playTime = 0
local currentVoiceMode = "Normal"
local playerIdentifier = nil

-- Get player identifier on spawn
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('playerHUD:requestPlayTime')
end)

-- Also request on resource start
CreateThread(function()
    Wait(1000)
    TriggerServerEvent('playerHUD:requestPlayTime')
end)

-- Receive saved playtime from server
RegisterNetEvent('playerHUD:receivePlayTime')
AddEventHandler('playerHUD:receivePlayTime', function(savedTime)
    playTime = savedTime or 0
end)

-- Start counting playtime and save periodically
CreateThread(function()
    while true do
        Wait(1000)
        playTime = playTime + 1
        
        -- Update HUD every second
        UpdateHUD()
        
        -- Save to server every 30 seconds
        if playTime % 30 == 0 then
            TriggerServerEvent('playerHUD:savePlayTime', playTime)
        end
    end
end)

-- PMA-Voice integration
AddEventHandler('pma-voice:setTalkingMode', function(mode)
    -- PMA-Voice modes: 1 = Whisper (2.5m), 2 = Normal (8m), 3 = Shout (20m)
    local voiceModes = {
        [1] = "Whisper",
        [2] = "Normal",
        [3] = "Shout"
    }
    currentVoiceMode = voiceModes[mode] or "Normal"
end)

-- Get initial voice mode from PMA-Voice
CreateThread(function()
    Wait(2000) -- Wait for PMA-Voice to initialize
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.proximity then
        local proximity = LocalPlayer.state.proximity
        if proximity then
            local mode = proximity.index
            local voiceModes = {
                [1] = "Whisper",
                [2] = "Normal",
                [3] = "Shout"
            }
            currentVoiceMode = voiceModes[mode] or "Normal"
        end
    end
end)

function GetCardinalDirection(heading)
    if heading >= 315 or heading < 45 then
        return "North"
    elseif heading >= 45 and heading < 135 then
        return "East"
    elseif heading >= 135 and heading < 225 then
        return "South"
    elseif heading >= 225 and heading < 315 then
        return "West"
    end
end

function UpdateHUD()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Get street name
    local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local crossingName = GetStreetNameFromHashKey(crossingHash)
    
    if crossingName ~= "" then
        streetName = streetName .. " & " .. crossingName
    end
    
    -- Get zone name (area)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    local zoneName = GetLabelText(zone)
    
    -- Get cardinal direction
    local direction = GetCardinalDirection(heading)
    
    -- Get player ID
    local playerId = GetPlayerServerId(PlayerId())
    
    -- Send data to UI (playTime is just the number now)
    SendNUIMessage({
        action = "updateHUD",
        playerId = playerId,
        playTime = playTime,
        voiceMode = currentVoiceMode,
        streetName = streetName,
        zoneName = zoneName,
        direction = direction
    })
end

-- Initialize HUD
CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        action = "showHUD"
    })
end)

-- Hide HUD when in pause menu
CreateThread(function()
    while true do
        Wait(300)
        if IsPauseMenuActive() then
            SendNUIMessage({
                action = "hideHUD"
            })
        else
            SendNUIMessage({
                action = "showHUD"
            })
        end
    end
end)

-- Save playtime when player disconnects
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('playerHUD:savePlayTime', playTime)
    end
end)