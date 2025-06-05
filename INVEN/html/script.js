// Goran2322's Inventory System - Complete Script with Weapon Equipment
// Date: 2025-06-04
// Drag and drop state
let isDragging = false;
let currentItem = null;
let originalSlot = null;
let ghostElement = null;
let mouseX = 0;
let mouseY = 0;

// Weapon categories
const weaponCategories = {
    heavy: ['rpg', 'grenadelauncher', 'minigun', 'firework', 'railgun', 'hominglauncher', 'compactlauncher', 'rayminigun'],
    pistol: ['pistol', 'combatpistol', 'pistol50', 'snspistol', 'heavypistol', 'vintagepistol', 'marksmanpistol', 'revolver', 'appistol', 'stungun', 'flaregun'],
    melee: ['knife', 'bat', 'crowbar', 'golfclub', 'hammer', 'hatchet', 'machete', 'switchblade', 'nightstick', 'wrench', 'poolcue']
};

// Weapon hashes for GTA V
const weaponHashes = {
    // Melee
    'knife': 'WEAPON_KNIFE',
    'bat': 'WEAPON_BAT',
    'crowbar': 'WEAPON_CROWBAR',
    'golfclub': 'WEAPON_GOLFCLUB',
    'hammer': 'WEAPON_HAMMER',
    'hatchet': 'WEAPON_HATCHET',
    'machete': 'WEAPON_MACHETE',
    'switchblade': 'WEAPON_SWITCHBLADE',
    'nightstick': 'WEAPON_NIGHTSTICK',
    'wrench': 'WEAPON_WRENCH',
    'poolcue': 'WEAPON_POOLCUE',
    // Pistols
    'pistol': 'WEAPON_PISTOL',
    'combatpistol': 'WEAPON_COMBATPISTOL',
    'pistol50': 'WEAPON_PISTOL50',
    'snspistol': 'WEAPON_SNSPISTOL',
    'heavypistol': 'WEAPON_HEAVYPISTOL',
    'vintagepistol': 'WEAPON_VINTAGEPISTOL',
    'marksmanpistol': 'WEAPON_MARKSMANPISTOL',
    'revolver': 'WEAPON_REVOLVER',
    'appistol': 'WEAPON_APPISTOL',
    'stungun': 'WEAPON_STUNGUN',
    'flaregun': 'WEAPON_FLAREGUN',
    // Heavy
    'rpg': 'WEAPON_RPG',
    'grenadelauncher': 'WEAPON_GRENADELAUNCHER',
    'minigun': 'WEAPON_MINIGUN',
    'firework': 'WEAPON_FIREWORK',
    'railgun': 'WEAPON_RAILGUN',
    'hominglauncher': 'WEAPON_HOMINGLAUNCHER',
    'compactlauncher': 'WEAPON_COMPACTLAUNCHER',
    'rayminigun': 'WEAPON_RAYMINIGUN'
};

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    console.log('[Inventory] Initializing system...');
    initInventory();
});

function initInventory() {
    // Set up event listeners
    window.addEventListener('message', handleMessage);
    document.addEventListener('mousemove', handleMouseMove);
    document.addEventListener('mouseup', handleMouseUp);
    document.addEventListener('keydown', handleKeyDown);
    
    // Prevent right click
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
    });
    
    // Notify FiveM that UI is ready
    if (window.GetParentResourceName) {
        const resourceName = window.GetParentResourceName();
        fetch(`https://${resourceName}/ready`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
    
    console.log('[Inventory] System initialized');
}

function handleMessage(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'setVisible':
            setVisible(data.visible);
            break;
        case 'updateInventory':
            updateInventory(data.inventory, data.totalWeight, data.maxWeight);
            break;
    }
}

function setVisible(visible) {
    const container = document.getElementById('inventory-container');
    if (visible) {
        container.classList.remove('hidden');
        console.log('[Inventory] Opened');
    } else {
        container.classList.add('hidden');
        console.log('[Inventory] Closed');
    }
}

function updateInventory(inventory, totalWeight, maxWeight) {
    console.log('[Inventory] Updating with', inventory.length, 'items');
    
    // Clear all existing items
    document.querySelectorAll('.item').forEach(item => item.remove());
    document.querySelectorAll('.slot').forEach(slot => slot.classList.remove('occupied'));
    
    // Update weight display
    const weightDisplay = document.querySelector('.weight-display');
    if (weightDisplay) {
        weightDisplay.textContent = `${totalWeight.toFixed(1)}/${maxWeight}vol`;
        if (totalWeight > maxWeight) {
            weightDisplay.style.color = '#ff0000';
        } else if (totalWeight > maxWeight * 0.8) {
            weightDisplay.style.color = '#ffaa00';
        } else {
            weightDisplay.style.color = '#00ff00';
        }
    }
    
    // Add items to slots
    inventory.forEach(item => {
        const slot = document.querySelector(`[data-slot="${item.slot}"][data-container="${item.container}"]`);
        if (slot) {
            createItem(slot, item);
        }
    });
}

function createItem(slot, itemData) {
    const item = document.createElement('div');
    item.className = 'item';
    
    // Check if item is a weapon
    const isWeapon = isItemWeapon(itemData.name);
    if (isWeapon) {
        item.classList.add('weapon-item');
    }
    
    // Store item data
    item.dataset.itemName = itemData.name;
    item.dataset.itemCount = itemData.count;
    item.dataset.itemWeight = itemData.weight || 0;
    item.dataset.itemLabel = itemData.label || itemData.name;
    item.dataset.isWeapon = isWeapon;
    
    // Create item HTML
    item.innerHTML = `
        <div class="item-weight">${(itemData.weight * itemData.count).toFixed(1)} vol.</div>
        <div class="item-icon">
            <img src="icons/${itemData.name}.png" draggable="false" alt="${itemData.label}">
        </div>
        <div class="item-name">${itemData.count > 1 ? itemData.label + ' ' + itemData.count + 'x' : itemData.label}</div>
    `;
    
    // Handle missing icon
    const img = item.querySelector('img');
    img.onerror = function() {
        this.parentElement.innerHTML = `<div class="item-icon-fallback">${itemData.name.substring(0, 3).toUpperCase()}</div>`;
    };
    
    // Add mouse down event to start dragging
    item.addEventListener('mousedown', function(e) {
        e.preventDefault();
        startDrag(e, item, slot);
    });
    
    // Prevent text selection
    item.addEventListener('selectstart', function(e) {
        e.preventDefault();
        return false;
    });
    
    // Add to slot
    slot.appendChild(item);
    slot.classList.add('occupied');
}

function startDrag(e, item, slot) {
    console.log('[Drag] Starting drag for', item.dataset.itemName);
    
    isDragging = true;
    currentItem = item;
    originalSlot = slot;
    
    // Store mouse position
    mouseX = e.clientX;
    mouseY = e.clientY;
    
    // Create ghost element (visual copy that follows mouse)
    ghostElement = item.cloneNode(true);
    ghostElement.className = 'item-ghost';
    if (item.dataset.isWeapon === 'true') {
        ghostElement.classList.add('weapon-ghost');
    }
    ghostElement.style.position = 'fixed';
    ghostElement.style.pointerEvents = 'none';
    ghostElement.style.zIndex = '9999';
    ghostElement.style.width = '76px';
    ghostElement.style.height = '76px';
    ghostElement.style.opacity = '0.8';
    ghostElement.style.transform = 'scale(1.1) rotate(-2deg)';
    ghostElement.style.boxShadow = '0 10px 20px rgba(0,0,0,0.3)';
    document.body.appendChild(ghostElement);
    
    // Fade original item
    item.style.opacity = '0.3';
    
    // Set initial ghost position
    updateGhostPosition(e);
    
    // Prevent default drag
    e.preventDefault();
}

function handleMouseMove(e) {
    if (!isDragging || !ghostElement) return;
    
    // Update mouse position
    mouseX = e.clientX;
    mouseY = e.clientY;
    
    // Update ghost position
    updateGhostPosition(e);
    
    // Get element under mouse (excluding ghost)
    ghostElement.style.display = 'none';
    const element = document.elementFromPoint(mouseX, mouseY);
    ghostElement.style.display = 'block';
    
    // Find slot under mouse
    const slot = element?.closest('.slot');
    
    // Clear all hover states
    document.querySelectorAll('.slot').forEach(s => {
        s.classList.remove('drag-over', 'invalid-drop');
    });
    
    // Check if hovering over a valid slot
    if (slot && slot !== originalSlot) {
        const hasItem = slot.querySelector('.item');
        if (!hasItem) {
            // Empty slot - check if item can be placed here
            const itemName = currentItem.dataset.itemName;
            const targetContainer = slot.dataset.container;
            
            if (canPlaceItem(itemName, targetContainer, slot)) {
                slot.classList.add('drag-over');
            } else {
                slot.classList.add('invalid-drop');
            }
        } else {
            // Slot has item
            slot.classList.add('invalid-drop');
        }
    }
}

function handleMouseUp(e) {
    if (!isDragging) return;
    
    console.log('[Drag] Ending drag');
    
    // Get element under mouse
    if (ghostElement) {
        ghostElement.style.display = 'none';
    }
    const element = document.elementFromPoint(mouseX, mouseY);
    const targetSlot = element?.closest('.slot');
    
    // Remove ghost element
    if (ghostElement) {
        ghostElement.remove();
        ghostElement = null;
    }
    
    // Clear all hover states
    document.querySelectorAll('.slot').forEach(s => {
        s.classList.remove('drag-over', 'invalid-drop');
    });
    
    // Try to drop item
    if (targetSlot && targetSlot !== originalSlot) {
        const hasItem = targetSlot.querySelector('.item');
        if (!hasItem) {
            const itemName = currentItem.dataset.itemName;
            const targetContainer = targetSlot.dataset.container;
            
            if (canPlaceItem(itemName, targetContainer, targetSlot)) {
                // Valid drop - move item
                console.log('[Drag] Moving item to new slot');
                moveItem(targetSlot);
            } else {
                console.log('[Drag] Invalid placement');
            }
        } else {
            console.log('[Drag] Target slot occupied');
        }
    }
    
    // Reset item opacity
    if (currentItem) {
        currentItem.style.opacity = '1';
    }
    
    // Reset drag state
    isDragging = false;
    currentItem = null;
    originalSlot = null;
}

function moveItem(targetSlot) {
    const itemName = currentItem.dataset.itemName;
    const fromContainer = originalSlot.dataset.container;
    const toContainer = targetSlot.dataset.container;
    
    // Check if moving weapon to/from loadout
    if (isItemWeapon(itemName)) {
        // Moving weapon FROM loadout TO inventory (unequip)
        if (fromContainer.startsWith('loadout-') && toContainer === 'inventory') {
            console.log('[Weapon] Unequipping weapon:', itemName);
            if (window.GetParentResourceName) {
                const resourceName = window.GetParentResourceName();
                fetch(`https://${resourceName}/unequipWeapon`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        weapon: weaponHashes[itemName] || itemName
                    })
                });
            }
        }
        // Moving weapon FROM inventory TO loadout (equip)
        else if (fromContainer === 'inventory' && toContainer.startsWith('loadout-')) {
            console.log('[Weapon] Equipping weapon:', itemName);
            if (window.GetParentResourceName) {
                const resourceName = window.GetParentResourceName();
                fetch(`https://${resourceName}/equipWeapon`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        weapon: weaponHashes[itemName] || itemName,
                        ammo: 250 // Default ammo count
                    })
                });
            }
        }
    }
    
    // Move item to new slot
    targetSlot.appendChild(currentItem);
    targetSlot.classList.add('occupied');
    originalSlot.classList.remove('occupied');
    
    // Send update to server
    if (window.GetParentResourceName) {
        const resourceName = window.GetParentResourceName();
        fetch(`https://${resourceName}/moveItem`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                from: {
                    container: fromContainer,
                    slot: originalSlot.dataset.slot
                },
                to: {
                    container: toContainer,
                    slot: targetSlot.dataset.slot
                },
                item: {
                    name: itemName,
                    count: parseInt(currentItem.dataset.itemCount),
                    weight: parseFloat(currentItem.dataset.itemWeight)
                }
            })
        });
    }
}

function updateGhostPosition(e) {
    if (ghostElement) {
        ghostElement.style.left = (e.clientX - 38) + 'px';
        ghostElement.style.top = (e.clientY - 38) + 'px';
    }
}

function isItemWeapon(itemName) {
    // Check if item is in any weapon category
    return weaponCategories.heavy.includes(itemName) ||
           weaponCategories.pistol.includes(itemName) ||
           weaponCategories.melee.includes(itemName);
}

function getWeaponCategory(itemName) {
    if (weaponCategories.heavy.includes(itemName)) return 'heavy';
    if (weaponCategories.pistol.includes(itemName)) return 'pistol';
    if (weaponCategories.melee.includes(itemName)) return 'melee';
    return null;
}

function canPlaceItem(itemName, container, targetSlot) {
    // All items (including weapons) can go in main inventory
    if (container === 'inventory') return true;
    
    // Non-weapons cannot go in loadout slots
    if (!isItemWeapon(itemName)) {
        if (container.startsWith('loadout-')) return false;
    }
    
    // Clothing restrictions (no weapons in clothing)
    if (container === 'clothing') {
        return !isItemWeapon(itemName);
    }
    
    // Loadout restrictions based on weapon type and slot number
    if (container === 'loadout-heavy') {
        // Only slot 1 accepts heavy weapons
        const slotNum = targetSlot.dataset.slot;
        return slotNum === '1' && weaponCategories.heavy.includes(itemName);
    }
    
    if (container === 'loadout-pistol') {
        // Slots 2 and 3 accept pistols
        const slotNum = targetSlot.dataset.slot;
        return (slotNum === '2' || slotNum === '3') && weaponCategories.pistol.includes(itemName);
    }
    
    if (container === 'loadout-melee') {
        // Slot 4 accepts melee weapons
        const slotNum = targetSlot.dataset.slot;
        return slotNum === '4' && weaponCategories.melee.includes(itemName);
    }
    
    return false;
}

function handleKeyDown(e) {
    const container = document.getElementById('inventory-container');
    const isVisible = !container.classList.contains('hidden');
    
    if (isVisible && (e.key === 'Escape' || e.key === 'i' || e.key === 'I')) {
        if (window.GetParentResourceName) {
            const resourceName = window.GetParentResourceName();
            fetch(`https://${resourceName}/close`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    }
}

// Debug function for testing
window.debugInventory = function() {
    console.log('[Debug] Current drag state:', {
        isDragging: isDragging,
        currentItem: currentItem,
        originalSlot: originalSlot
    });
    console.log('[Debug] Weapon categories:', weaponCategories);
};