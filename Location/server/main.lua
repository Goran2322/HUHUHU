local playTimeData = {}
local dataFile = "playtime_data.json"

-- Load saved data on resource start
CreateThread(function()
    local loadedData = LoadResourceFile(GetCurrentResourceName(), dataFile)
    if loadedData then
        playTimeData = json.decode(loadedData) or {}
        print("^2[PlayerHUD] Loaded playtime data for " .. tablelength(playTimeData) .. " players^0")
    else
        print("^3[PlayerHUD] No saved playtime data found, creating new file^0")
        SaveResourceFile(GetCurrentResourceName(), dataFile, json.encode({}), -1)
    end
end)

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- Get player identifier
function GetPlayerIdentifierByType(source, idType)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, idType) then
            return identifier
        end
    end
    return nil
end

-- Request playtime
RegisterNetEvent('playerHUD:requestPlayTime')
AddEventHandler('playerHUD:requestPlayTime', function()
    local source = source
    local identifier = GetPlayerIdentifierByType(source, "license:")
    
    if identifier then
        local savedTime = playTimeData[identifier] or 0
        TriggerClientEvent('playerHUD:receivePlayTime', source, savedTime)
    end
end)

-- Save playtime
RegisterNetEvent('playerHUD:savePlayTime')
AddEventHandler('playerHUD:savePlayTime', function(playTime)
    local source = source
    local identifier = GetPlayerIdentifierByType(source, "license:")
    
    if identifier then
        playTimeData[identifier] = playTime
        -- Save to file
        SaveResourceFile(GetCurrentResourceName(), dataFile, json.encode(playTimeData), -1)
    end
end)

-- Save when player drops
AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = GetPlayerIdentifierByType(source, "license:")
    
    if identifier and playTimeData[identifier] then
        -- Data is already saved periodically, but we save one more time on disconnect
        SaveResourceFile(GetCurrentResourceName(), dataFile, json.encode(playTimeData), -1)
        print("^2[PlayerHUD] Saved playtime for player: " .. GetPlayerName(source) .. "^0")
    end
end)

-- Save all data when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SaveResourceFile(GetCurrentResourceName(), dataFile, json.encode(playTimeData), -1)
        print("^2[PlayerHUD] Saved all playtime data^0")
    end
end)