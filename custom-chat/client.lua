-- Custom Chat System for FiveM
local chatInput = nil
local chatMessages = nil
local chatContainer = nil
local chatActive = false
local chatInputContainer = nil
local fadeTimeout = nil
local lastMessageTime = GetGameTimer()
local isAdmin = false

-- Define available commands (excluding tx commands)
local commands = {
    {name = "try", description = "Example TRY command"},
    {name = "help", description = "Show help information"},
    {name = "clear", description = "Clear the chat"},
    {name = "me", description = "Roleplay action (*Player_Name action)"},
    {name = "do", description = "Roleplay environment action (*action (Player ID))"},
    {name = "ooc", description = "Out of character chat"},
    {name = "report", description = "Report an issue"},
    {name = "admin", description = "Admin chat"},
    {name = "pm", description = "Private message a player"},
    {name = "stats", description = "View your player statistics"},
    {name = "setbank", description = "Set your bank money (testing)"},
    {name = "setcash", description = "Set your pocket money (testing)"},
    {name = "car", description = "(Admin Only) Spawn any vehicle", isAdmin = true},
    {name = "dv", description = "(Admin Only) Delete nearest vehicle (5m radius)", isAdmin = true},
    {name = "wep", description = "(Admin Only) Give weapon by hash (e.g. WEAPON_PISTOL)", isAdmin = true}
}

-- Initialize chat when resource starts
Citizen.CreateThread(function()
    -- Wait a moment for everything to load
    Citizen.Wait(500)
    
    -- Disable default GTA chat
    SetTextChatEnabled(false)
    SetNuiFocus(false, false)
    
    -- Create custom chat UI
    SendNUIMessage({
        type = 'CREATE_CHAT'
    })
    
    -- Request admin status from server
    TriggerServerEvent('custom-chat:requestAdminStatus')
    
    -- Send available commands to UI
    SendNUIMessage({
        type = 'SET_COMMANDS',
        commands = commands
    })
    
    -- Register the chat command
    RegisterCommand('chatmessage', function(source, args, rawCommand)
        -- This prevents errors from other resources trying to use chat
    end, false)
end)

-- Receive admin status from server
RegisterNetEvent('custom-chat:setAdminStatus')
AddEventHandler('custom-chat:setAdminStatus', function(adminStatus)
    isAdmin = adminStatus
    -- Update UI with admin status
    SendNUIMessage({
        type = 'SET_ADMIN_STATUS',
        isAdmin = isAdmin
    })
end)

-- Handle T key press to open chat
RegisterKeyMapping('openchat', 'Open Chat', 'keyboard', 'T')

RegisterCommand('openchat', function()
    if not chatActive then
        openChat()
    end
end, false)

-- Open chat function
function openChat()
    if chatActive then return end -- Prevent double opening
    
    chatActive = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        type = 'OPEN_CHAT'
    })
end

-- Close chat function
function closeChat()
    if not chatActive then return end -- Prevent double closing
    
    chatActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'CLOSE_CHAT'
    })
end

-- Handle incoming chat messages
RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    -- Ensure message has proper structure
    if type(message) == 'table' then
        SendNUIMessage({
            type = 'ADD_MESSAGE',
            message = message
        })
    elseif type(message) == 'string' then
        -- Convert string messages to proper format
        SendNUIMessage({
            type = 'ADD_MESSAGE',
            message = {
                author = 'System',
                text = message,
                type = 'system'
            }
        })
    end
end)

-- ME command
RegisterCommand('me', function(source, args, rawCommand)
    if #args == 0 then
        return
    end
    
    local message = table.concat(args, ' ')
    TriggerServerEvent('custom-chat:meCommand', message)
end, false)

-- DO command
RegisterCommand('do', function(source, args, rawCommand)
    if #args == 0 then
        return
    end
    
    local message = table.concat(args, ' ')
    TriggerServerEvent('custom-chat:doCommand', message)
end, false)

-- Car spawn command
RegisterCommand('car', function(source, args, rawCommand)
    if not isAdmin then
        return
    end
    
    local vehicleName = args[1]
    
    if not vehicleName then
        return
    end
    
    -- Request server to verify admin and spawn vehicle
    TriggerServerEvent('custom-chat:spawnVehicle', vehicleName)
end, false)

-- Delete Vehicle command
RegisterCommand('dv', function(source, args, rawCommand)
    if not isAdmin then
        return
    end
    
    -- Request server to verify admin
    TriggerServerEvent('custom-chat:deleteVehicle')
end, false)

-- Give Weapon command
RegisterCommand('wep', function(source, args, rawCommand)
    if not isAdmin then
        return
    end
    
    local weaponHash = args[1]
    
    if not weaponHash then
        return
    end
    
    -- Request server to verify admin and give weapon
    TriggerServerEvent('custom-chat:giveWeapon', weaponHash)
end, false)

-- Handle vehicle spawn from server
RegisterNetEvent('custom-chat:spawnVehicleClient')
AddEventHandler('custom-chat:spawnVehicleClient', function(vehicleName)
    local playerPed = PlayerPedId()
    local vehicleHash = GetHashKey(vehicleName)
    
    if not IsModelValid(vehicleHash) then
        return
    end
    
    -- Request the model
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end
    
    -- Get player position and heading
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local heading = GetEntityHeading(playerPed)
    
    -- Delete current vehicle if in one
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    if currentVehicle ~= 0 then
        DeleteEntity(currentVehicle)
    end
    
    -- Spawn the vehicle
    local vehicle = CreateVehicle(vehicleHash, x, y, z + 0.5, heading, true, false)
    
    -- Put player in driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)
    
    -- Set vehicle properties
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    -- Clean up
    SetModelAsNoLongerNeeded(vehicleHash)
end)

-- Handle delete vehicle from server
RegisterNetEvent('custom-chat:deleteVehicleClient')
AddEventHandler('custom-chat:deleteVehicleClient', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local radius = 5.0
    
    -- Check if player is in a vehicle first
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        -- Delete the vehicle player is in
        DeleteEntity(vehicle)
        return
    end
    
    -- Find nearest vehicle within radius
    local nearestVehicle = nil
    local nearestDistance = radius
    
    local vehicles = GetGamePool('CVehicle')
    for _, veh in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(veh)
        local distance = #(playerCoords - vehCoords)
        
        if distance <= radius and distance < nearestDistance then
            nearestVehicle = veh
            nearestDistance = distance
        end
    end
    
    if nearestVehicle then
        DeleteEntity(nearestVehicle)
    end
end)

-- Handle give weapon from server
RegisterNetEvent('custom-chat:giveWeaponClient')
AddEventHandler('custom-chat:giveWeaponClient', function(weaponHashInput)
    local playerPed = PlayerPedId()
    local weaponHash = GetHashKey(weaponHashInput)
    
    -- Check if the weapon hash is valid
    if not IsWeaponValid(weaponHash) then
        return
    end
    
    -- Give weapon with max ammo
    GiveWeaponToPed(playerPed, weaponHash, 9999, false, true)
    
    -- Add weapon components if it's a customizable weapon
    local weaponGroup = GetWeapontypeGroup(weaponHash)
    if weaponGroup == 970310034 or weaponGroup == 1159398588 or weaponGroup == 416676503 then
        -- Add all components for assault rifles, SMGs, and snipers
        for i = 0, 10 do
            GiveWeaponComponentToPed(playerPed, weaponHash, i)
        end
    end
end)

-- Register some example commands
RegisterCommand('try', function(source, args, rawCommand)
    TriggerEvent('chat:addMessage', {
        author = 'TRY Command',
        text = 'TRY command executed with args: ' .. table.concat(args, ' '),
        type = 'system'
    })
end, false)

RegisterCommand('help', function(source, args, rawCommand)
    local helpText = 'Available commands: /try, /help, /clear, /me, /do, /ooc, /report, /admin, /pm, /stats'
    if isAdmin then
        helpText = helpText .. ', ^1/car^7, ^1/dv^7, ^1/wep^7'
    end
    TriggerEvent('chat:addMessage', {
        author = 'Help',
        text = helpText,
        type = 'system'
    })
end, false)

RegisterCommand('clear', function(source, args, rawCommand)
    SendNUIMessage({
        type = 'CLEAR_CHAT'
    })
end, false)

-- Add command to update available commands dynamically
RegisterCommand('addcommand', function(source, args, rawCommand)
    if args[1] and args[2] then
        table.insert(commands, {name = args[1], description = table.concat(args, ' ', 2)})
        SendNUIMessage({
            type = 'SET_COMMANDS',
            commands = commands
        })
        TriggerEvent('chat:addMessage', {
            author = 'System',
            text = 'Command /' .. args[1] .. ' added',
            type = 'system'
        })
    end
end, false)

-- Override default chat suggestions to prevent errors
RegisterNetEvent('chat:addSuggestion')
AddEventHandler('chat:addSuggestion', function(name, help, params)
    -- Don't add tx commands to our list
    if string.sub(name, 1, 2) == 'tx' or string.sub(name:gsub('^/', ''), 1, 2) == 'tx' then
        return
    end
    
    -- Add to our command list if not already there
    local found = false
    for _, cmd in ipairs(commands) do
        if cmd.name == name:gsub('^/', '') then
            found = true
            break
        end
    end
    
    if not found then
        table.insert(commands, {name = name:gsub('^/', ''), description = help or ''})
        SendNUIMessage({
            type = 'SET_COMMANDS',
            commands = commands
        })
    end
end)

RegisterNetEvent('chat:removeSuggestion')
AddEventHandler('chat:removeSuggestion', function(name)
    -- Remove from our command list
    for i, cmd in ipairs(commands) do
        if cmd.name == name:gsub('^/', '') then
            table.remove(commands, i)
            SendNUIMessage({
                type = 'SET_COMMANDS',
                commands = commands
            })
            break
        end
    end
end)

RegisterNetEvent('chat:clear')
AddEventHandler('chat:clear', function()
    -- Handle clear if needed
    SendNUIMessage({
        type = 'CLEAR_CHAT'
    })
end)

-- Handle NUI callbacks
RegisterNUICallback('chatMessage', function(data, cb)
    SetNuiFocus(false, false) -- Release focus immediately
    
    local message = data.message
    
    -- Only process non-empty messages
    if message and string.len(message) > 0 then
        -- Check if it's a command
        if string.sub(message, 1, 1) == '/' then
            -- Check if it's a tx command - if so, let it pass through normally
            local command = string.sub(message, 2)
            if string.sub(command, 1, 2) == 'tx' then
                -- Execute the tx command without our wrapper
                ExecuteCommand(command)
            else
                -- Execute other commands normally
                ExecuteCommand(command)
            end
        else
            -- Send regular chat message
            TriggerServerEvent('custom-chat:messageEntered', message)
        end
    end
    
    -- Close chat
    chatActive = false
    SendNUIMessage({
        type = 'CLOSE_CHAT'
    })
    
    cb({ok = true})
end)

RegisterNUICallback('closeChat', function(data, cb)
    SetNuiFocus(false, false) -- Release focus immediately
    chatActive = false
    SendNUIMessage({
        type = 'CLOSE_CHAT'
    })
    cb({ok = true})
end)

-- Disable default chat controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not chatActive then
            DisableControlAction(0, 245, true) -- Disable default T key
            DisableControlAction(0, 246, true) -- Disable default Y key
        end
    end
end)

-- DON'T handle _chat:messageEntered for commands to avoid interference
AddEventHandler('_chat:messageEntered', function(author, color, message)
    -- Only redirect non-command messages
    if message and string.len(message) > 0 then
        if string.sub(message, 1, 1) ~= '/' then
            -- Only handle non-commands
            TriggerServerEvent('custom-chat:messageEntered', message)
        end
        -- Let commands be handled by the game/txAdmin
    end
end)

-- Don't interfere with command fallback
AddEventHandler('__cfx_internal:commandFallback', function(command)
    -- Don't intercept any commands starting with /tx
    if string.sub(command, 1, 3) == '/tx' then
        -- Let txAdmin handle it
        return
    end
    
    -- For other unknown commands, show error
    if string.sub(command, 1, 1) == '/' then
        TriggerEvent('chat:addMessage', {
            author = 'System',
            text = 'Unknown command: ' .. command,
            type = 'system'
        })
    end
end)

-- Export functions for other resources
exports('addMessage', function(message)
    TriggerEvent('chat:addMessage', message)
end)

exports('chatActive', function()
    return chatActive
end)

-- Emergency escape - Press F8 to force close chat if stuck
RegisterCommand('forceclosechat', function()
    chatActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'CLOSE_CHAT'
    })
    print("Chat force closed")
end, false)
RegisterKeyMapping('forceclosechat', 'Force Close Chat', 'keyboard', 'F8')