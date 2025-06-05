-- Weapon on Back Script for FiveM
-- This script displays weapons on the player's back when equipped

local weapons_on_back = {}
local attached_weapons = {}
local last_weapon = nil
local last_used_weapons = {} -- Track last used weapon per category
local weapon_switch_in_category = false -- Track if we're switching within same category

-- Weapon priority (higher number = higher priority)
local weapon_priority = {
    -- Pistols (highest priority pistols)
    [`WEAPON_PISTOL50`] = 10,
    [`WEAPON_REVOLVER_MK2`] = 9,
    [`WEAPON_REVOLVER`] = 8,
    [`WEAPON_HEAVYPISTOL`] = 7,
    [`WEAPON_PISTOL_MK2`] = 6,
    [`WEAPON_COMBATPISTOL`] = 5,
    [`WEAPON_PISTOL`] = 4,
    [`WEAPON_APPISTOL`] = 3,
    [`WEAPON_SNSPISTOL_MK2`] = 2,
    [`WEAPON_SNSPISTOL`] = 1,
    
    -- Rifles (highest priority rifles)
    [`WEAPON_MILITARYRIFLE`] = 10,
    [`WEAPON_HEAVYRIFLE`] = 9,
    [`WEAPON_CARBINERIFLE_MK2`] = 8,
    [`WEAPON_CARBINERIFLE`] = 7,
    [`WEAPON_ASSAULTRIFLE_MK2`] = 6,
    [`WEAPON_ASSAULTRIFLE`] = 5,
    [`WEAPON_SPECIALCARBINE_MK2`] = 4,
    [`WEAPON_SPECIALCARBINE`] = 3,
    [`WEAPON_BULLPUPRIFLE_MK2`] = 2,
    [`WEAPON_BULLPUPRIFLE`] = 1,
    
    -- Shotguns
    [`WEAPON_COMBATSHOTGUN`] = 7,
    [`WEAPON_HEAVYSHOTGUN`] = 6,
    [`WEAPON_ASSAULTSHOTGUN`] = 5,
    [`WEAPON_PUMPSHOTGUN_MK2`] = 4,
    [`WEAPON_PUMPSHOTGUN`] = 3,
    [`WEAPON_BULLPUPSHOTGUN`] = 2,
    [`WEAPON_SAWNOFFSHOTGUN`] = 1,
    
    -- SMGs
    [`WEAPON_SMG_MK2`] = 5,
    [`WEAPON_SMG`] = 4,
    [`WEAPON_ASSAULTSMG`] = 3,
    [`WEAPON_COMBATPDW`] = 2,
    [`WEAPON_MINISMG`] = 1,
    
    -- Snipers
    [`WEAPON_HEAVYSNIPER_MK2`] = 5,
    [`WEAPON_HEAVYSNIPER`] = 4,
    [`WEAPON_MARKSMANRIFLE_MK2`] = 3,
    [`WEAPON_MARKSMANRIFLE`] = 2,
    [`WEAPON_SNIPERRIFLE`] = 1,
    
    -- Knives (priority order)
    [`WEAPON_KNIFE`] = 5,
    [`WEAPON_SWITCHBLADE`] = 4,
    [`WEAPON_DAGGER`] = 3,
    [`WEAPON_BOTTLE`] = 2,
    [`WEAPON_STONE_HATCHET`] = 1,
}

-- Weapon bone and position configurations
local weapon_config = {
    -- Assault Rifles
    [`WEAPON_CARBINERIFLE`] = {bone = 24818, x = 0.0012, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_CARBINERIFLE_MK2`] = {bone = 24818, x = 0.0012, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_ASSAULTRIFLE`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_ASSAULTRIFLE_MK2`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_SPECIALCARBINE`] = {bone = 24818, x = -0.04, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_SPECIALCARBINE_MK2`] = {bone = 24818, x = -0.04, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_BULLPUPRIFLE`] = {bone = 24818, x = -0.04, y = -0.15, z = -0.02, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_BULLPUPRIFLE_MK2`] = {bone = 24818, x = 0.01, y = -0.15, z = -0.02, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_MILITARYRIFLE`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_HEAVYRIFLE`] = {bone = 24818, x = -0.01, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_TACTICALRIFLE`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.015, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    
    -- SMGs
    [`WEAPON_SMG`] = {bone = 24818, x = -0.01, y = -0.15, z = 0.026, rx = 0.0, ry = 35.0, rz = 0.0, category = "heavy"},
    [`WEAPON_SMG_MK2`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 35.0, rz = 0.0, category = "heavy"},
    [`WEAPON_ASSAULTSMG`] = {bone = 24818, x = 0.1, y = -0.15, z = -0.05, rx = 0.0, ry = 35.0, rz = 0.0, category = "heavy"},
    [`WEAPON_COMBATPDW`] = {bone = 24818, x = -0.03, y = -0.15, z = 0.01, rx = 0.0, ry = 35.0, rz = 0.0, category = "heavy"},
    [`WEAPON_MINISMG`] = {bone = 24818, x = -0.25, y = -0.14, z = -0.10, rx = 180.0, ry = 195.0, rz = 0.0, category = "heavy"},
    
    -- Shotguns
    [`WEAPON_PUMPSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_PUMPSHOTGUN_MK2`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_SAWNOFFSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_ASSAULTSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_BULLPUPSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_HEAVYSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_COMBATSHOTGUN`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    
    -- Snipers
    [`WEAPON_SNIPERRIFLE`] = {bone = 24818, x = -0.2, y = -0.15, z = 0.038, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_HEAVYSNIPER`] = {bone = 24818, x = -0.2, y = -0.15, z = 0.038, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_HEAVYSNIPER_MK2`] = {bone = 24818, x = -0.2, y = -0.17, z = 0.038, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_MARKSMANRIFLE`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.038, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_MARKSMANRIFLE_MK2`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.038, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    
    -- Pistols (now on back like other weapons)
    [`WEAPON_PISTOL`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_PISTOL_MK2`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_COMBATPISTOL`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_APPISTOL`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_STUNGUN`] = {bone = 23553, x = -0.01  , y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_PISTOL50`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_SNSPISTOL`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_SNSPISTOL_MK2`] = {bone = 23553, x = -0.08, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_HEAVYPISTOL`] = {bone = 23553, x = -0.05, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_VINTAGEPISTOL`] = {bone = 23553, x = -0.08, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_FLAREGUN`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_MARKSMANPISTOL`] = {bone = 23553, x = -0.04, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_REVOLVER`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_REVOLVER_MK2`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_DOUBLEACTION`] = {bone = 23553, x = -0.04, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_RAYPISTOL`] = {bone = 23553, x = -0.06, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_CERAMICPISTOL`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_NAVYREVOLVER`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_GADGETPISTOL`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    [`WEAPON_PISTOLXM3`] = {bone = 23553, x = -0.02, y = -0.15, z = -0.12, rx = 0.0, ry = 178.0, rz = 0.0, category = "pistol"},
    
    -- Heavy Weapons
    [`WEAPON_RPG`] = {bone = 24818, x = 0.2, y = -0.15, z = -0.14, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_GRENADELAUNCHER`] = {bone = 24818, x = -0.1, y = -0.15, z = 0.023, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_MINIGUN`] = {bone = 24818, x = -0.2, y = -0.15, z = 0.04, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_RAILGUN`] = {bone = 24818, x = -0.2, y = -0.15, z = 0.1, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_HOMINGLAUNCHER`] = {bone = 24818, x = 0.2, y = -0.15, z = -0.2, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    [`WEAPON_COMPACTLAUNCHER`] = {bone = 24818, x = -0.01, y = -0.15, z = -0.02, rx = 0.0, ry = 30.0, rz = 0.0, category = "heavy"},
    
    -- Melee (large weapons only)
    [`WEAPON_BAT`] = {bone = 51826, x = -0.012, y = 0.01, z = 0.13, rx = 0.0, ry = 90.0, rz = 0.0, category = "melee"},
    [`WEAPON_GOLFCLUB`] = {bone = 51826, x = -0.012, y = 0.01, z = 0.13, rx = 0.0, ry = 90.0, rz = 0.0, category = "melee"},
    [`WEAPON_CROWBAR`] = {bone = 51826, x = -0.015, y = 0.01, z = 0.12, rx = 0.0, ry = 90.0, rz = 0.0, category = "melee"},
    [`WEAPON_BOTTLE`] = {bone = 24818, x = -0.075, y = -0.15, z = -0.02, rx = 0.0, ry = 165.0, rz = 0.0, category = "melee"},
    [`WEAPON_DAGGER`] = {bone = 24818, x = -0.075, y = -0.15, z = -0.02, rx = 0.0, ry = 165.0, rz = 0.0, category = "melee"},
    [`WEAPON_HATCHET`] = {bone = 24818, x = -0.075, y = -0.15, z = -0.02, rx = 0.0, ry = 165.0, rz = 0.0, category = "melee"},
    [`WEAPON_MACHETE`] = {bone = 24818, x = -0.075, y = -0.15, z = -0.02, rx = 0.0, ry = 165.0, rz = 0.0, category = "melee"},
    [`WEAPON_POOLCUE`] = {bone = 24818, x = -0.075, y = -0.15, z = -0.02, rx = 0.0, ry = 165.0, rz = 0.0, category = "melee"},
    
    -- Knives (new additions)
    [`WEAPON_KNIFE`] = {bone = 58271, x = 0.02, y = 0.02, z = -0.02, rx = 180.0, ry = 180.0, rz = 0.0, category = "knife"},
    [`WEAPON_SWITCHBLADE`] = {bone = 58271, x = 0.02, y = 0.02, z = -0.02, rx = 180.0, ry = 180.0, rz = 0.0, category = "knife"},
    [`WEAPON_STONE_HATCHET`] = {bone = 58271, x = 0.02, y = 0.02, z = -0.02, rx = 180.0, ry = 180.0, rz = 0.0, category = "knife"},
}

-- Function to check if player has a weapon
local function hasWeapon(weaponHash)
    return HasPedGotWeapon(PlayerPedId(), weaponHash, false)
end

-- Function to create weapon prop
local function createWeaponObject(weaponHash)
    local weaponModel = GetWeapontypeModel(weaponHash)
    
    RequestModel(weaponModel)
    while not HasModelLoaded(weaponModel) do
        Wait(1)
    end
    
    local object = CreateObject(weaponModel, 0.0, 0.0, 0.0, true, true, false)
    SetEntityCollision(object, false, false)
    SetEntityAlpha(object, 255, false)
    
    return object
end

-- Function to attach weapon to back
local function attachWeaponToBack(weaponHash)
    if attached_weapons[weaponHash] then
        return
    end
    
    local config = weapon_config[weaponHash]
    if not config then
        return
    end
    
    local ped = PlayerPedId()
    local weaponObject = createWeaponObject(weaponHash)
    
    if weaponObject then
        AttachEntityToEntity(
            weaponObject,
            ped,
            GetPedBoneIndex(ped, config.bone),
            config.x,
            config.y,
            config.z,
            config.rx,
            config.ry,
            config.rz,
            false,
            false,
            false,
            false,
            2,
            true
        )
        
        attached_weapons[weaponHash] = weaponObject
    end
end

-- Function to remove weapon from back
local function removeWeaponFromBack(weaponHash)
    if attached_weapons[weaponHash] then
        DeleteObject(attached_weapons[weaponHash])
        attached_weapons[weaponHash] = nil
    end
end

-- Function to remove all weapons from back
local function removeAllWeaponsFromBack()
    for weaponHash, object in pairs(attached_weapons) do
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
    end
    attached_weapons = {}
end

-- Function to get highest priority weapon in a list
local function getHighestPriorityWeapon(weaponList)
    local highestPriority = -1
    local highestWeapon = nil
    
    for _, weaponHash in ipairs(weaponList) do
        local priority = weapon_priority[weaponHash] or 0
        if priority > highestPriority then
            highestPriority = priority
            highestWeapon = weaponHash
        end
    end
    
    return highestWeapon
end

-- Function to get all player weapons by category
local function getPlayerWeaponsByCategory()
    local weapons = {
        heavy = {},
        pistol = {},
        melee = {},
        knife = {}
    }
    
    for weaponHash, config in pairs(weapon_config) do
        if hasWeapon(weaponHash) then
            if weapons[config.category] then
                table.insert(weapons[config.category], weaponHash)
            end
        end
    end
    
    return weapons
end

-- Function to update weapons on back
local function updateWeaponsOnBack()
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)
    
    local weaponsByCategory = getPlayerWeaponsByCategory()
    local weaponsToShow = {}
    
    -- For each category, determine which weapon to show
    for category, weaponList in pairs(weaponsByCategory) do
        if #weaponList > 0 then
            local weaponToShow = nil
            
            -- If switching within same category, show the last weapon
            if weapon_switch_in_category and last_weapon and weapon_config[last_weapon] and weapon_config[last_weapon].category == category then
                if last_weapon ~= currentWeapon and hasWeapon(last_weapon) then
                    weaponToShow = last_weapon
                end
            else
                -- Check if we have a last used weapon for this category
                if last_used_weapons[category] and hasWeapon(last_used_weapons[category]) and last_used_weapons[category] ~= currentWeapon then
                    weaponToShow = last_used_weapons[category]
                else
                    -- Use highest priority weapon that's not currently held
                    local filteredList = {}
                    for _, weapon in ipairs(weaponList) do
                        if weapon ~= currentWeapon then
                            table.insert(filteredList, weapon)
                        end
                    end
                    
                    if #filteredList > 0 then
                        weaponToShow = getHighestPriorityWeapon(filteredList)
                    end
                end
            end
            
            if weaponToShow then
                weaponsToShow[weaponToShow] = true
            end
        end
    end
    
    -- Update attached weapons
    for weaponHash, config in pairs(weapon_config) do
        if weaponsToShow[weaponHash] then
            if not attached_weapons[weaponHash] then
                attachWeaponToBack(weaponHash)
            end
        else
            if attached_weapons[weaponHash] then
                removeWeaponFromBack(weaponHash)
            end
        end
    end
end

-- Variable to track if script is enabled
local isEnabled = true

-- Main thread
CreateThread(function()
    while true do
        if isEnabled then
            updateWeaponsOnBack()
            -- Reset category switch flag after update
            weapon_switch_in_category = false
        end
        Wait(100)
    end
end)

-- Thread to detect weapon changes and track last used
CreateThread(function()
    while true do
        if isEnabled then
            local ped = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(ped)
            
            -- Detect weapon change
            if currentWeapon ~= last_weapon then
                -- Check if switching within same category
                if last_weapon and last_weapon ~= `WEAPON_UNARMED` and currentWeapon ~= `WEAPON_UNARMED` then
                    local lastConfig = weapon_config[last_weapon]
                    local currentConfig = weapon_config[currentWeapon]
                    
                    if lastConfig and currentConfig and lastConfig.category == currentConfig.category then
                        weapon_switch_in_category = true
                    end
                end
                
                -- Update last used weapon for the category
                if last_weapon and last_weapon ~= `WEAPON_UNARMED` then
                    local lastConfig = weapon_config[last_weapon]
                    if lastConfig then
                        last_used_weapons[lastConfig.category] = last_weapon
                    end
                end
                
                last_weapon = currentWeapon
                updateWeaponsOnBack()
            end
        end
        Wait(50)
    end
end)

-- Clean up when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    removeAllWeaponsFromBack()
end)

-- Command to toggle the script
RegisterCommand('toggleweaponback', function()
    isEnabled = not isEnabled
    
    if not isEnabled then
        removeAllWeaponsFromBack()
        TriggerEvent('chat:addMessage', {
            args = {'[WeaponBack]', 'Weapon visibility disabled'}
        })
    else
        TriggerEvent('chat:addMessage', {
            args = {'[WeaponBack]', 'Weapon visibility enabled'}
        })
    end
end, false)

-- Debug command to check pistol visibility
RegisterCommand('debugpistol', function()
    local ped = PlayerPedId()
    local weapons = getPlayerWeaponsByCategory()
    
    print("=== PISTOL DEBUG ===")
    print("Pistols in inventory:", #weapons.pistol)
    for _, weapon in ipairs(weapons.pistol) do
        print("- Weapon:", weapon, "Config exists:", weapon_config[weapon] ~= nil)
    end
    
    print("\nAttached pistols:")
    for hash, obj in pairs(attached_weapons) do
        if weapon_config[hash] and weapon_config[hash].category == "pistol" then
            print("- Attached:", hash, "Object exists:", DoesEntityExist(obj))
        end
    end
end, false)