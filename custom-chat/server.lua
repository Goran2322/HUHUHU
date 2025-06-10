-- Custom Chat System Server Side

-- Player money data storage
local playerData = {}

-- Helper function to format money with commas
function FormatMoney(amount)
    local formatted = tostring(amount)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Load player data when they join
AddEventHandler('playerJoining', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0) -- Get primary identifier
    local playerName = GetPlayerName(source)
    
    -- Initialize with default values
    if not playerData[identifier] then
        playerData[identifier] = {
            name = playerName,
            bank_money = 10000, -- Default bank money
            pocket_money = 500  -- Default pocket money
        }
    end
end)

-- Function to check if player is admin using ACE permissions
function IsPlayerAdmin(source)
    return IsPlayerAceAllowed(source, "command.car")
end

-- Send admin status to player
RegisterServerEvent('custom-chat:requestAdminStatus')
AddEventHandler('custom-chat:requestAdminStatus', function()
    local source = source
    local isAdmin = IsPlayerAdmin(source)
    TriggerClientEvent('custom-chat:setAdminStatus', source, isAdmin)
end)

-- Handle vehicle spawn request
RegisterServerEvent('custom-chat:spawnVehicle')
AddEventHandler('custom-chat:spawnVehicle', function(vehicleName)
    local source = source
    
    -- Check admin status using ACE permissions
    if not IsPlayerAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            author = 'System',
            text = '^1Error: You do not have permission to use this command!',
            type = 'system'
        })
        print("^1[Custom Chat] Player " .. GetPlayerName(source) .. " tried to use /car without permission^7")
        return
    end
    
    -- Log admin action
    print("^2[Custom Chat] Admin " .. GetPlayerName(source) .. " spawned vehicle: " .. vehicleName .. "^7")
    
    -- Send back to client to spawn
    TriggerClientEvent('custom-chat:spawnVehicleClient', source, vehicleName)
end)

-- Handle delete vehicle request
RegisterServerEvent('custom-chat:deleteVehicle')
AddEventHandler('custom-chat:deleteVehicle', function()
    local source = source
    
    -- Check admin status using ACE permissions
    if not IsPlayerAceAllowed(source, "command.dv") then
        TriggerClientEvent('chat:addMessage', source, {
            author = 'System',
            text = '^1Error: You do not have permission to use this command!',
            type = 'system'
        })
        print("^1[Custom Chat] Player " .. GetPlayerName(source) .. " tried to use /dv without permission^7")
        return
    end
    
    -- Log admin action
    print("^2[Custom Chat] Admin " .. GetPlayerName(source) .. " used /dv command^7")
    
    -- Send back to client to delete vehicle
    TriggerClientEvent('custom-chat:deleteVehicleClient', source)
end)

-- Handle give weapon request
RegisterServerEvent('custom-chat:giveWeapon')
AddEventHandler('custom-chat:giveWeapon', function(weaponName)
    local source = source
    
    -- Check admin status using ACE permissions
    if not IsPlayerAceAllowed(source, "command.wep") then
        TriggerClientEvent('chat:addMessage', source, {
            author = 'System',
            text = '^1Error: You do not have permission to use this command!',
            type = 'system'
        })
        print("^1[Custom Chat] Player " .. GetPlayerName(source) .. " tried to use /wep without permission^7")
        return
    end
    
    -- Log admin action
    print("^2[Custom Chat] Admin " .. GetPlayerName(source) .. " gave themselves weapon: " .. weaponName .. "^7")
    
    -- Send back to client to give weapon
    TriggerClientEvent('custom-chat:giveWeaponClient', source, weaponName)
end)

-- Handle chat messages
RegisterServerEvent('custom-chat:messageEntered')
AddEventHandler('custom-chat:messageEntered', function(message)
    local source = source
    local playerName = GetPlayerName(source)
    
    if not playerName or not message or string.len(message) == 0 then 
        return 
    end
    
    -- Clean the message
    message = string.gsub(message, "[<>]", "")
    
    -- Format the message
    local formattedMessage = {
        author = playerName,
        text = message,
        type = 'player'
    }
    
    -- Send to all players
    TriggerClientEvent('chat:addMessage', -1, formattedMessage)
    
    -- Log to console
    print(playerName .. ': ' .. message)
end)

-- Override default chat command handler
AddEventHandler('chatMessage', function(source, name, message)
    -- Cancel the default chat message
    CancelEvent()
    
    -- Use our custom system instead
    if message and string.len(message) > 0 then
        TriggerEvent('custom-chat:messageEntered', message)
    end
end)

-- Handle player connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    -- Optional: Add join messages
end)

-- Handle player disconnecting  
AddEventHandler('playerDropped', function(reason)
    local source = source
    local playerName = GetPlayerName(source)
    
    if playerName then
        local message = {
            author = 'System',
            text = playerName .. ' left the server',
            type = 'system'
        }
        TriggerClientEvent('chat:addMessage', -1, message)
    end
end)

-- Add some default commands
RegisterCommand('clear', function(source, args, rawCommand)
    if source > 0 then
        TriggerClientEvent('chat:clear', source)
    end
end, false)

RegisterCommand('say', function(source, args, rawCommand)
    if source == 0 then
        -- Console message
        local message = table.concat(args, ' ')
        TriggerClientEvent('chat:addMessage', -1, {
            author = 'Console',
            text = message,
            type = 'system'
        })
    end
end, true)

RegisterCommand('stats', function(source, args, rawCommand)
    if source == 0 then return end -- Ignore console
    
    local identifier = GetPlayerIdentifier(source, 0)
    local playerName = GetPlayerName(source)
    
    -- Get player data
    local data = playerData[identifier] or {
        name = playerName,
        bank_money = 0,
        pocket_money = 0
    }
    
    -- Send two separate messages to ensure they appear on different lines
    -- First message: INFO and player name
    TriggerClientEvent('chat:addMessage', source, {
        author = '',
        text = "^3[INFO]: ^4PLAYER STATS FOR ^7" .. playerName .. ":",
        type = 'system'
    })
    
    -- Second message: Money values
    TriggerClientEvent('chat:addMessage', source, {
        author = '',
        text = "^4[Bank Money: ^2$" .. FormatMoney(data.bank_money) .. "^4] [Pocket Money: ^2$" .. FormatMoney(data.pocket_money) .. "^4]",
        type = 'system'
    })
end, false)

-- Optional: Commands to modify money for testing
RegisterCommand('setbank', function(source, args, rawCommand)
    if source == 0 then return end
    
    local amount = tonumber(args[1])
    if not amount then 
        TriggerClientEvent('chat:addMessage', source, {
            author = 'System',
            text = '^1Usage: /setbank [amount]',
            type = 'system'
        })
        return 
    end
    
    local identifier = GetPlayerIdentifier(source, 0)
    if not playerData[identifier] then
        playerData[identifier] = {
            name = GetPlayerName(source),
            bank_money = 0,
            pocket_money = 0
        }
    end
    
    playerData[identifier].bank_money = amount
    
    TriggerClientEvent('chat:addMessage', source, {
        author = 'System',
        text = '^2Bank money set to $' .. FormatMoney(amount),
        type = 'system'
    })
end, false)

RegisterCommand('setcash', function(source, args, rawCommand)
    if source == 0 then return end
    
    local amount = tonumber(args[1])
    if not amount then 
        TriggerClientEvent('chat:addMessage', source, {
            author = 'System',
            text = '^1Usage: /setcash [amount]',
            type = 'system'
        })
        return 
    end
    
    local identifier = GetPlayerIdentifier(source, 0)
    if not playerData[identifier] then
        playerData[identifier] = {
            name = GetPlayerName(source),
            bank_money = 0,
            pocket_money = 0
        }
    end
    
    playerData[identifier].pocket_money = amount
    
    TriggerClientEvent('chat:addMessage', source, {
        author = 'System',
        text = '^2Pocket money set to $' .. FormatMoney(amount),
        type = 'system'
    })
end, false)

-- Register admin commands with ACE permissions
RegisterCommand('car', function(source, args, rawCommand)
    -- This is handled client-side, but we register it here for ACE permissions
end, true) -- true = restricted command

RegisterCommand('dv', function(source, args, rawCommand)
    -- This is handled client-side, but we register it here for ACE permissions
end, true) -- true = restricted command

RegisterCommand('wep', function(source, args, rawCommand)
    -- This is handled client-side, but we register it here for ACE permissions
end, true) -- true = restricted command

-- Provide chat API for other resources
exports('addMessage', function(target, message)
    TriggerClientEvent('chat:addMessage', target, message)
end)

-- Export functions for other resources to use
exports('GetPlayerMoney', function(source)
    local identifier = GetPlayerIdentifier(source, 0)
    if playerData[identifier] then
        return {
            bank = playerData[identifier].bank_money,
            cash = playerData[identifier].pocket_money
        }
    end
    return {bank = 0, cash = 0}
end)

exports('SetPlayerMoney', function(source, moneyType, amount)
    local identifier = GetPlayerIdentifier(source, 0)
    if not playerData[identifier] then
        playerData[identifier] = {
            name = GetPlayerName(source),
            bank_money = 0,
            pocket_money = 0
        }
    end
    
    if moneyType == 'bank' then
        playerData[identifier].bank_money = amount
    elseif moneyType == 'cash' then
        playerData[identifier].pocket_money = amount
    end
end)

-- ME command handler
RegisterServerEvent('custom-chat:meCommand')
AddEventHandler('custom-chat:meCommand', function(message)
    local source = source
    local playerName = GetPlayerName(source)
    
    -- Format: *Player_Name message
    local formattedMessage = "^6*" .. playerName .. " " .. message
    
    -- Send to all players
    TriggerClientEvent('chat:addMessage', -1, {
        author = '',
        text = formattedMessage,
        type = 'roleplay'
    })
end)

-- DO command handler
RegisterServerEvent('custom-chat:doCommand')
AddEventHandler('custom-chat:doCommand', function(message)
    local source = source
    local playerId = source
    
    -- Format: *message ( Player (ID) )
    local formattedMessage = "^6*" .. message .. " ( Player (" .. playerId .. ") )"
    
    -- Send to all players
    TriggerClientEvent('chat:addMessage', -1, {
        author = '',
        text = formattedMessage,
        type = 'roleplay'
    })
end)