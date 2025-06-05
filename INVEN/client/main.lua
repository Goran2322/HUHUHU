local isInventoryOpen = false
local playerInventory = {} -- Store inventory locally

-- Function to apply/remove game blur
local function SetGameBlur(enable)
    if enable then
        -- Apply blur effect to the game
        SetTimecycleModifier("hud_def_blur")
        SetTimecycleModifierStrength(1.0)
    else
        -- Remove blur effect
        ClearTimecycleModifier()
    end
end

-- Toggle inventory function
function ToggleInventory()
    isInventoryOpen = not isInventoryOpen
    
    SetNuiFocus(isInventoryOpen, isInventoryOpen)
    
    -- Apply/remove game blur
    SetGameBlur(isInventoryOpen)
    
    SendNUIMessage({
        action = 'setVisible',
        visible = isInventoryOpen
    })
    
    if isInventoryOpen then
        -- Calculate total weight
        local totalWeight = 0
        for _, item in ipairs(playerInventory) do
            totalWeight = totalWeight + (item.weight * item.count)
        end
        
        SendNUIMessage({
            action = 'updateInventory',
            inventory = playerInventory,
            totalWeight = totalWeight,
            maxWeight = Config.MaxWeight
        })
    end
end

-- Key handler for opening inventory
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Press TAB to open inventory
        if IsControlJustPressed(0, 37) then -- TAB key
            ToggleInventory()
        end
    end
end)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    isInventoryOpen = false
    SetNuiFocus(false, false)
    SetGameBlur(false)
    
    SendNUIMessage({
        action = 'setVisible',
        visible = false
    })
    
    cb('ok')
end)

RegisterNUICallback('ready', function(data, cb)
    print("Inventory UI is ready")
    cb('ok')
end)

-- Handle item movement
RegisterNUICallback('moveItem', function(data, cb)
    print("Moving item:", json.encode(data))
    
    -- Find and update the item in local inventory
    local itemMoved = false
    for i, item in ipairs(playerInventory) do
        if item.slot == tonumber(data.from.slot) and item.container == data.from.container then
            -- Update item position
            item.slot = tonumber(data.to.slot)
            item.container = data.to.container
            itemMoved = true
            break
        end
    end
    
    if itemMoved then
        -- Recalculate total weight and update UI
        local totalWeight = 0
        for _, item in ipairs(playerInventory) do
            totalWeight = totalWeight + (item.weight * item.count)
        end
        
        SendNUIMessage({
            action = 'updateInventory',
            inventory = playerInventory,
            totalWeight = totalWeight,
            maxWeight = Config.MaxWeight
        })
    end
    
    cb('ok')
end)

-- Handle weapon equip
RegisterNUICallback('equipWeapon', function(data, cb)
    local weaponHash = GetHashKey(data.weapon)
    local ped = PlayerPedId()
    
    print("Equipping weapon:", data.weapon, "Hash:", weaponHash)
    
    -- Give weapon to player
    GiveWeaponToPed(ped, weaponHash, data.ammo or 250, false, true)
    
    -- Notification
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Weapon equipped: " .. data.weapon)
    DrawNotification(false, false)
    
    cb('ok')
end)

-- Handle weapon unequip
RegisterNUICallback('unequipWeapon', function(data, cb)
    local weaponHash = GetHashKey(data.weapon)
    local ped = PlayerPedId()
    
    print("Unequipping weapon:", data.weapon, "Hash:", weaponHash)
    
    -- Remove weapon from player
    RemoveWeaponFromPed(ped, weaponHash)
    
    -- Notification
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~r~Weapon unequipped: " .. data.weapon)
    DrawNotification(false, false)
    
    cb('ok')
end)

-- Make sure to clear blur when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SetGameBlur(false)
        SetNuiFocus(false, false)
    end
end)

-- Clear blur when player disconnects/leaves
AddEventHandler('playerDropped', function()
    SetGameBlur(false)
end)

-- Export function so other scripts can toggle inventory
exports('ToggleInventory', ToggleInventory)

-- Export function to check if inventory is open
exports('IsInventoryOpen', function()
    return isInventoryOpen
end)

-- Command to open inventory (optional)
RegisterCommand('inventory', function()
    ToggleInventory()
end, false)

-- Command to spawn weapon in inventory
RegisterCommand('giveweapon', function(source, args)
    local weaponName = args[1]
    if not weaponName then
        print("Usage: /giveweapon [weapon_name]")
        print("Examples: /giveweapon pistol, /giveweapon rpg, /giveweapon knife")
        print("For rifles: /giveweapon carbinerifle, /giveweapon assaultrifle")
        return
    end
    
    -- Check if weapon exists in our config
    local weaponConfig = Config.Items[weaponName]
    if not weaponConfig then
        print("Unknown weapon: " .. weaponName)
        print("Available weapons:")
        print("- Pistols: pistol, combatpistol, pistol50, revolver")
        print("- Rifles: carbinerifle, assaultrifle, advancedrifle, specialcarbine")
        print("- Heavy: rpg, minigun, grenadelauncher")
        print("- Melee: knife, bat, crowbar, hammer")
        return
    end
    
    -- Find first empty slot in inventory
    local emptySlot = nil
    for i = 1, 18 do
        local slotOccupied = false
        for _, item in ipairs(playerInventory) do
            if item.container == "inventory" and item.slot == i then
                slotOccupied = true
                break
            end
        end
        if not slotOccupied then
            emptySlot = i
            break
        end
    end
    
    if not emptySlot then
        print("Inventory full!")
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~Inventory is full!")
        DrawNotification(false, false)
        return
    end
    
    -- Add weapon to inventory
    table.insert(playerInventory, {
        name = weaponName,
        label = weaponConfig.label,
        count = 1,
        weight = weaponConfig.weight,
        slot = emptySlot,
        container = "inventory"
    })
    
    print("Added " .. weaponConfig.label .. " to inventory slot " .. emptySlot)
    
    -- Show notification
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Added " .. weaponConfig.label .. " to inventory")
    DrawNotification(false, false)
    
    -- Update UI if inventory is open
    if isInventoryOpen then
        local totalWeight = 0
        for _, item in ipairs(playerInventory) do
            totalWeight = totalWeight + (item.weight * item.count)
        end
        
        SendNUIMessage({
            action = 'updateInventory',
            inventory = playerInventory,
            totalWeight = totalWeight,
            maxWeight = Config.MaxWeight
        })
    end
end, false)

-- Command to give specific items
RegisterCommand('giveitem', function(source, args)
    local itemName = args[1]
    local count = tonumber(args[2]) or 1
    
    if not itemName then
        print("Usage: /giveitem [item_name] [count]")
        print("Examples: /giveitem bread 5, /giveitem water 10")
        return
    end
    
    -- Check if item exists in our config
    local itemConfig = Config.Items[itemName]
    if not itemConfig then
        print("Unknown item: " .. itemName)
        return
    end
    
    -- Find first empty slot in inventory
    local emptySlot = nil
    for i = 1, 18 do
        local slotOccupied = false
        for _, item in ipairs(playerInventory) do
            if item.container == "inventory" and item.slot == i then
                slotOccupied = true
                break
            end
        end
        if not slotOccupied then
            emptySlot = i
            break
        end
    end
    
    if not emptySlot then
        print("Inventory full!")
        return
    end
    
    -- Add item to inventory
    table.insert(playerInventory, {
        name = itemName,
        label = itemConfig.label,
        count = count,
        weight = itemConfig.weight,
        slot = emptySlot,
        container = "inventory"
    })
    
    print("Added " .. count .. "x " .. itemConfig.label .. " to inventory")
    
    -- Update UI if inventory is open
    if isInventoryOpen then
        local totalWeight = 0
        for _, item in ipairs(playerInventory) do
            totalWeight = totalWeight + (item.weight * item.count)
        end
        
        SendNUIMessage({
            action = 'updateInventory',
            inventory = playerInventory,
            totalWeight = totalWeight,
            maxWeight = Config.MaxWeight
        })
    end
end, false)

-- Debug command for testing weapons
RegisterCommand('testweapons', function()
    print("Testing weapons system...")
    
    -- Clear inventory
    playerInventory = {}
    
    -- Add various weapons to inventory
    local testWeapons = {
        {name = "rpg", slot = 1},
        {name = "minigun", slot = 2},
        {name = "pistol", slot = 3},
        {name = "combatpistol", slot = 4},
        {name = "pistol50", slot = 5},
        {name = "knife", slot = 6},
        {name = "bat", slot = 7},
        {name = "carbinerifle", slot = 8},
        {name = "assaultrifle", slot = 9},
        {name = "bread", slot = 10},
        {name = "water", slot = 11}
    }
    
    for _, weapon in ipairs(testWeapons) do
        local itemConfig = Config.Items[weapon.name]
        if itemConfig then
            table.insert(playerInventory, {
                name = weapon.name,
                label = itemConfig.label,
                count = 1,
                weight = itemConfig.weight,
                slot = weapon.slot,
                container = "inventory"
            })
        end
    end
    
    -- Show notification
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Test weapons added to inventory")
    DrawNotification(false, false)
    
    -- Open inventory
    ToggleInventory()
end, false)

-- Command to clear inventory
RegisterCommand('clearinventory', function()
    playerInventory = {}
    print("Inventory cleared")
    
    if isInventoryOpen then
        SendNUIMessage({
            action = 'updateInventory',
            inventory = playerInventory,
            totalWeight = 0,
            maxWeight = Config.MaxWeight
        })
    end
end, false)

-- Optional: Register a key mapping
RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'TAB')