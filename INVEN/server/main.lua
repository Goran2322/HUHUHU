-- Standalone server script for inventory

-- Example player inventory storage (you should use a database in production)
local playerInventories = {}

-- Function to get player inventory
function GetPlayerInventory(source)
    local identifier = GetPlayerIdentifier(source, 0)
    if not playerInventories[identifier] then
        -- Initialize default inventory
        playerInventories[identifier] = {
            items = {},
            weight = 0.0,
            maxWeight = 50.0
        }
    end
    return playerInventories[identifier]
end

-- Function to save player inventory
function SavePlayerInventory(source, inventory)
    local identifier = GetPlayerIdentifier(source, 0)
    playerInventories[identifier] = inventory
    -- Here you would save to database in production
    print("Saved inventory for player: " .. identifier)
end

-- Event to get player inventory
RegisterServerEvent('inventory:getInventory')
AddEventHandler('inventory:getInventory', function()
    local source = source
    local inventory = GetPlayerInventory(source)
    
    TriggerClientEvent('inventory:receiveInventory', source, inventory)
end)

-- Event to move items
RegisterServerEvent('inventory:moveItem')
AddEventHandler('inventory:moveItem', function(from, to, item)
    local source = source
    local inventory = GetPlayerInventory(source)
    
    -- Add your item movement logic here
    print("Player " .. source .. " moving item: " .. json.encode(item))
    
    -- Example: Simple item movement logic
    -- You should implement proper validation and movement logic
    
    SavePlayerInventory(source, inventory)
    
    -- Send updated inventory back to client
    TriggerClientEvent('inventory:receiveInventory', source, inventory)
end)

-- Event when player connects
AddEventHandler('playerConnecting', function()
    local source = source
    -- Initialize player inventory if needed
    GetPlayerInventory(source)
end)

-- Event when player disconnects
AddEventHandler('playerDropped', function()
    local source = source
    -- Save player inventory before they disconnect
    local inventory = GetPlayerInventory(source)
    SavePlayerInventory(source, inventory)
end)