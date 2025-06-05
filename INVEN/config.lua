Config = {}

-- Inventory settings
Config.MaxWeight = 50.0
Config.MaxSlots = 18

-- Key to open inventory (you can change this)
Config.OpenKey = 'TAB' -- or 'I' for I key

-- Item settings with complete item list
Config.Items = {
    -- WEAPONS - MELEE
    ['knife'] = {
        label = 'Knife',
        weight = 0.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['bat'] = {
        label = 'Baseball Bat',
        weight = 1.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['crowbar'] = {
        label = 'Crowbar',
        weight = 1.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['golfclub'] = {
        label = 'Golf Club',
        weight = 0.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['hammer'] = {
        label = 'Hammer',
        weight = 0.6,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['hatchet'] = {
        label = 'Hatchet',
        weight = 0.9,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['machete'] = {
        label = 'Machete',
        weight = 0.7,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['switchblade'] = {
        label = 'Switchblade',
        weight = 0.3,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['nightstick'] = {
        label = 'Nightstick',
        weight = 0.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['wrench'] = {
        label = 'Wrench',
        weight = 0.7,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['poolcue'] = {
        label = 'Pool Cue',
        weight = 0.6,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - PISTOLS
    ['pistol'] = {
        label = 'Pistol',
        weight = 1.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['combatpistol'] = {
        label = 'Combat Pistol',
        weight = 1.7,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['pistol50'] = {
        label = 'Pistol .50',
        weight = 2.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['snspistol'] = {
        label = 'SNS Pistol',
        weight = 1.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['heavypistol'] = {
        label = 'Heavy Pistol',
        weight = 1.9,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['vintagepistol'] = {
        label = 'Vintage Pistol',
        weight = 1.4,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['marksmanpistol'] = {
        label = 'Marksman Pistol',
        weight = 1.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['revolver'] = {
        label = 'Revolver',
        weight = 2.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['appistol'] = {
        label = 'AP Pistol',
        weight = 1.6,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['stungun'] = {
        label = 'Stun Gun',
        weight = 1.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['flaregun'] = {
        label = 'Flare Gun',
        weight = 1.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - SMG
    ['microsmg'] = {
        label = 'Micro SMG',
        weight = 2.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['smg'] = {
        label = 'SMG',
        weight = 3.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['assaultsmg'] = {
        label = 'Assault SMG',
        weight = 3.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['combatpdw'] = {
        label = 'Combat PDW',
        weight = 2.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['machinepistol'] = {
        label = 'Machine Pistol',
        weight = 2.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['minismg'] = {
        label = 'Mini SMG',
        weight = 2.4,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - RIFLES
    ['assaultrifle'] = {
        label = 'Assault Rifle',
        weight = 4.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['carbinerifle'] = {
        label = 'Carbine Rifle',
        weight = 4.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['advancedrifle'] = {
        label = 'Advanced Rifle',
        weight = 4.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['specialcarbine'] = {
        label = 'Special Carbine',
        weight = 4.3,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['bullpuprifle'] = {
        label = 'Bullpup Rifle',
        weight = 3.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['compactrifle'] = {
        label = 'Compact Rifle',
        weight = 3.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - SNIPERS
    ['sniperrifle'] = {
        label = 'Sniper Rifle',
        weight = 6.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['heavysniper'] = {
        label = 'Heavy Sniper',
        weight = 7.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['marksmanrifle'] = {
        label = 'Marksman Rifle',
        weight = 5.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['musket'] = {
        label = 'Musket',
        weight = 4.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - SHOTGUNS
    ['pumpshotgun'] = {
        label = 'Pump Shotgun',
        weight = 3.8,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['sawnoffshotgun'] = {
        label = 'Sawed-Off Shotgun',
        weight = 3.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['assaultshotgun'] = {
        label = 'Assault Shotgun',
        weight = 4.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['bullpupshotgun'] = {
        label = 'Bullpup Shotgun',
        weight = 3.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['heavyshotgun'] = {
        label = 'Heavy Shotgun',
        weight = 4.2,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['dbshotgun'] = {
        label = 'Double Barrel Shotgun',
        weight = 3.6,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['autoshotgun'] = {
        label = 'Auto Shotgun',
        weight = 4.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- WEAPONS - HEAVY
    ['rpg'] = {
        label = 'RPG',
        weight = 8.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['grenadelauncher'] = {
        label = 'Grenade Launcher',
        weight = 7.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['minigun'] = {
        label = 'Minigun',
        weight = 10.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['firework'] = {
        label = 'Firework Launcher',
        weight = 5.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['railgun'] = {
        label = 'Railgun',
        weight = 9.0,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['hominglauncher'] = {
        label = 'Homing Launcher',
        weight = 8.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['compactlauncher'] = {
        label = 'Compact Launcher',
        weight = 5.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    ['rayminigun'] = {
        label = 'Widowmaker',
        weight = 9.5,
        stackable = false,
        usable = true,
        type = 'weapon'
    },
    
    -- THROWABLES
    ['grenade'] = {
        label = 'Grenade',
        weight = 0.4,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['bzgas'] = {
        label = 'BZ Gas',
        weight = 0.4,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['molotov'] = {
        label = 'Molotov',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['stickybomb'] = {
        label = 'Sticky Bomb',
        weight = 0.6,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['proxmine'] = {
        label = 'Proximity Mine',
        weight = 0.8,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['snowball'] = {
        label = 'Snowball',
        weight = 0.1,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['pipebomb'] = {
        label = 'Pipe Bomb',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['ball'] = {
        label = 'Ball',
        weight = 0.2,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['smokegrenade'] = {
        label = 'Smoke Grenade',
        weight = 0.4,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    ['flare'] = {
        label = 'Flare',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'weapon'
    },
    
    -- AMMO
    ['pistol_ammo'] = {
        label = 'Pistol Ammo',
        weight = 0.02,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['smg_ammo'] = {
        label = 'SMG Ammo',
        weight = 0.03,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['rifle_ammo'] = {
        label = 'Rifle Ammo',
        weight = 0.04,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['sniper_ammo'] = {
        label = 'Sniper Ammo',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['shotgun_ammo'] = {
        label = 'Shotgun Ammo',
        weight = 0.04,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['mg_ammo'] = {
        label = 'MG Ammo',
        weight = 0.06,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    ['rocket'] = {
        label = 'Rocket',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'ammo'
    },
    
    -- CONSUMABLES
    ['bread'] = {
        label = 'Bread',
        weight = 0.25,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['water'] = {
        label = 'Water',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['burger'] = {
        label = 'Burger',
        weight = 0.35,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['pizza'] = {
        label = 'Pizza Slice',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['hotdog'] = {
        label = 'Hotdog',
        weight = 0.25,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['sandwich'] = {
        label = 'Sandwich',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['taco'] = {
        label = 'Taco',
        weight = 0.2,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['apple'] = {
        label = 'Apple',
        weight = 0.15,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['banana'] = {
        label = 'Banana',
        weight = 0.15,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['orange'] = {
        label = 'Orange',
        weight = 0.15,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['chocolate'] = {
        label = 'Chocolate Bar',
        weight = 0.1,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['donut'] = {
        label = 'Donut',
        weight = 0.15,
        stackable = true,
        usable = true,
        type = 'food'
    },
    ['coffee'] = {
        label = 'Coffee',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['beer'] = {
        label = 'Beer',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['wine'] = {
        label = 'Wine',
        weight = 0.6,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['whiskey'] = {
        label = 'Whiskey',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['vodka'] = {
        label = 'Vodka',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['cola'] = {
        label = 'Cola',
        weight = 0.35,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['energy'] = {
        label = 'Energy Drink',
        weight = 0.35,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    ['juice'] = {
        label = 'Juice',
        weight = 0.4,
        stackable = true,
        usable = true,
        type = 'drink'
    },
    
    -- MEDICAL
    ['bandage'] = {
        label = 'Bandage',
        weight = 0.1,
        stackable = true,
        usable = true,
        type = 'medical'
    },
    ['firstaid'] = {
        label = 'First Aid Kit',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'medical'
    },
    ['medkit'] = {
        label = 'Medical Kit',
        weight = 1.0,
        stackable = true,
        usable = true,
        type = 'medical'
    },
    ['painkillers'] = {
        label = 'Painkillers',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'medical'
    },
    ['morphine'] = {
        label = 'Morphine',
        weight = 0.1,
        stackable = true,
        usable = true,
        type = 'medical'
    },
    
    -- TOOLS
    ['lockpick'] = {
        label = 'Lockpick',
        weight = 0.2,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['advancedlockpick'] = {
        label = 'Advanced Lockpick',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['repairkit'] = {
        label = 'Repair Kit',
        weight = 2.5,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['cleaningkit'] = {
        label = 'Cleaning Kit',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['rope'] = {
        label = 'Rope',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['handcuffs'] = {
        label = 'Handcuffs',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['zipties'] = {
        label = 'Zip Ties',
        weight = 0.1,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['flashlight'] = {
        label = 'Flashlight',
        weight = 0.3,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['binoculars'] = {
        label = 'Binoculars',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['camera'] = {
        label = 'Camera',
        weight = 0.4,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['drill'] = {
        label = 'Drill',
        weight = 1.5,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['thermite'] = {
        label = 'Thermite',
        weight = 0.8,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    
    -- MATERIALS
    ['iron'] = {
        label = 'Iron',
        weight = 0.5,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['copper'] = {
        label = 'Copper',
        weight = 0.5,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['aluminum'] = {
        label = 'Aluminum',
        weight = 0.3,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['steel'] = {
        label = 'Steel',
        weight = 0.6,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['glass'] = {
        label = 'Glass',
        weight = 0.3,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['plastic'] = {
        label = 'Plastic',
        weight = 0.2,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['rubber'] = {
        label = 'Rubber',
        weight = 0.3,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['fabric'] = {
        label = 'Fabric',
        weight = 0.1,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['wood'] = {
        label = 'Wood',
        weight = 0.4,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['diamond'] = {
        label = 'Diamond',
        weight = 0.05,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['gold'] = {
        label = 'Gold',
        weight = 0.3,
        stackable = true,
        usable = false,
        type = 'material'
    },
    ['silver'] = {
        label = 'Silver',
        weight = 0.25,
        stackable = true,
        usable = false,
        type = 'material'
    },
    
    -- ELECTRONICS
    ['phone'] = {
        label = 'Phone',
        weight = 0.2,
        stackable = false,
        usable = true,
        type = 'electronic'
    },
    ['radio'] = {
        label = 'Radio',
        weight = 0.3,
        stackable = false,
        usable = true,
        type = 'electronic'
    },
    ['laptop'] = {
        label = 'Laptop',
        weight = 1.5,
        stackable = false,
        usable = true,
        type = 'electronic'
    },
    ['usb'] = {
        label = 'USB Drive',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'electronic'
    },
    ['electronickit'] = {
        label = 'Electronic Kit',
        weight = 0.8,
        stackable = true,
        usable = true,
        type = 'electronic'
    },
    ['gps'] = {
        label = 'GPS',
        weight = 0.2,
        stackable = true,
        usable = true,
        type = 'electronic'
    },
    
    -- ILLEGAL ITEMS
    ['weed'] = {
        label = 'Weed',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'drug'
    },
    ['coke'] = {
        label = 'Cocaine',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'drug'
    },
    ['meth'] = {
        label = 'Meth',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'drug'
    },
    ['joint'] = {
        label = 'Joint',
        weight = 0.02,
        stackable = true,
        usable = true,
        type = 'drug'
    },
    
    -- MISCELLANEOUS
    ['money'] = {
        label = 'Cash',
        weight = 0.0,
        stackable = true,
        usable = false,
        type = 'money'
    },
    ['black_money'] = {
        label = 'Dirty Money',
        weight = 0.0,
        stackable = true,
        usable = false,
        type = 'money'
    },
    ['id_card'] = {
        label = 'ID Card',
        weight = 0.01,
        stackable = false,
        usable = true,
        type = 'document'
    },
    ['driver_license'] = {
        label = 'Driver License',
        weight = 0.01,
        stackable = false,
        usable = true,
        type = 'document'
    },
    ['weaponlicense'] = {
        label = 'Weapon License',
        weight = 0.01,
        stackable = false,
        usable = true,
        type = 'document'
    },
    ['cigarette'] = {
        label = 'Cigarette',
        weight = 0.01,
        stackable = true,
        usable = true,
        type = 'consumable'
    },
    ['lighter'] = {
        label = 'Lighter',
        weight = 0.05,
        stackable = true,
        usable = true,
        type = 'tool'
    },
    ['rollingpaper'] = {
        label = 'Rolling Paper',
        weight = 0.01,
        stackable = true,
        usable = true,
        type = 'material'
    },
    ['armor'] = {
        label = 'Body Armor',
        weight = 2.0,
        stackable = true,
        usable = true,
        type = 'equipment'
    },
    ['parachute'] = {
        label = 'Parachute',
        weight = 3.0,
        stackable = true,
        usable = true,
        type = 'equipment'
    },
    ['scubagear'] = {
        label = 'Scuba Gear',
        weight = 4.0,
        stackable = true,
        usable = true,
        type = 'equipment'
    },
    ['nightvision'] = {
        label = 'Night Vision',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'equipment'
    },
    ['thermalvision'] = {
        label = 'Thermal Vision',
        weight = 0.5,
        stackable = true,
        usable = true,
        type = 'equipment'
    }
}

-- Container types
Config.Containers = {
    inventory = {slots = 18},
    clothing = {slots = 13},
    loadout = {slots = 4}
}

-- Weapon type categorization for loadout slots
Config.WeaponCategories = {
    heavy = {'rpg', 'grenadelauncher', 'minigun', 'firework', 'railgun', 'hominglauncher', 'compactlauncher', 'rayminigun'},
    pistol = {'pistol', 'combatpistol', 'pistol50', 'snspistol', 'heavypistol', 'vintagepistol', 'marksmanpistol', 'revolver', 'appistol', 'stungun', 'flaregun'},
    melee = {'knife', 'bat', 'crowbar', 'golfclub', 'hammer', 'hatchet', 'machete', 'switchblade', 'nightstick', 'wrench', 'poolcue'}
}