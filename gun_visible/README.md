# Weapon on Back Script for FiveM

This script displays all weapons that you have equipped on your character's back when they're not actively being held.

## Features

- Automatically displays weapons on your back when not in use
- Supports a wide variety of weapons including:
  - Assault Rifles
  - SMGs
  - Shotguns
  - Sniper Rifles
  - Heavy Weapons
  - Large Melee Weapons
- Weapons disappear from back when equipped in hand
- Toggle command to enable/disable the feature
- Optimized performance with 1-second update intervals

## Installation

1. Create a new folder in your server's `resources` directory called `weapon-on-back`
2. Copy the provided files into this folder:
   - `fxmanifest.lua`
   - `client/main.lua`
3. Add `ensure weapon-on-back` to your server.cfg

## Usage

The script works automatically once installed. All weapons in your inventory will appear on your back when not actively held.

### Commands

- `/toggleweaponback` - Toggle the weapon visibility on/off

## Configuration

You can modify weapon positions by editing the `weapon_config` table in `client/main.lua`. Each weapon has the following properties:

- `bone` - The bone ID to attach to (24818 is the spine)
- `x, y, z` - Position offset
- `rx, ry, rz` - Rotation offset

Example:
```lua
[`WEAPON_CARBINERIFLE`] = {
    bone = 24818,
    x = -0.075,
    y = -0.15,
    z = -0.02,
    rx = 0.0,
    ry = 165.0,
    rz = 0.0
}
```

## Adding More Weapons

To add more weapons, simply add them to the `weapon_config` table with their hash and position configuration.

## Performance

The script updates every second to check for weapon changes, ensuring minimal performance impact while maintaining responsive weapon display.

## Known Issues

- Some weapon models may clip through certain clothing
- Position adjustments may be needed for different player models

## Support

For issues or suggestions, please create an issue on the repository or contact the script author.