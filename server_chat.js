// Server-side chat handling
mp.events.add('serverChatMessage', (player, message) => {
    console.log(`[CHAT] ${player.name}: ${message}`);
    
    // Broadcast message to all players within 20 units
    mp.players.forEach((p) => {
        if (p.dist(player.position) <= 20) {
            p.call('chatMessage', [player.name, message]);
        }
    });
});

// Command handler
mp.events.add('serverCommand', (player, command) => {
    console.log(`[COMMAND] ${player.name} used command: ${command}`);
    
    // Parse the command
    const args = command.split(' ');
    const cmd = args[0].toLowerCase();
    
    // Handle commands
    switch (cmd) {
        case 'car':
            // Car spawning command
            let vehicleName = 'adder'; // Default car
            
            if (args.length > 1) {
                vehicleName = args[1].toLowerCase();
            }
            
            try {
                // Get player's position and heading
                const pos = player.position;
                const heading = player.heading;
                
                // Calculate position in front of player (3 units)
                const frontX = pos.x + (Math.sin(-heading * Math.PI / 180) * 3);
                const frontY = pos.y + (Math.cos(-heading * Math.PI / 180) * 3);
                
                // Create vehicle
                const vehicle = mp.vehicles.new(mp.joaat(vehicleName), new mp.Vector3(frontX, frontY, pos.z));
                
                // Set the heading to match player's direction
                vehicle.rotation = new mp.Vector3(0, 0, heading);
                
                // Set dimension to match player's dimension
                vehicle.dimension = player.dimension;
                
                // Notify player
                player.call('chatMessage', ['SYSTEM', `Vehicle ${vehicleName} spawned!`]);
                
                console.log(`[VEHICLE] ${player.name} spawned vehicle: ${vehicleName}`);
            } catch (error) {
                console.error(`Error spawning vehicle: ${error.message}`);
                player.call('chatMessage', ['SYSTEM', `Error: Could not spawn vehicle ${vehicleName}`]);
            }
            break;
            
        // Keep a few basic commands for testing
        case 'me':
            if (args.length > 1) {
                const actionText = args.slice(1).join(' ');
                mp.players.forEach((p) => {
                    if (p.dist(player.position) <= 20) {
                        p.call('chatMessage', ['SYSTEM', `* ${player.name} ${actionText}`]);
                    }
                });
            } else {
                player.call('chatMessage', ['SYSTEM', 'Usage: /me [action]']);
            }
            break;
            
        case 'test':
            player.call('chatMessage', ['SYSTEM', 'Chat system is working!']);
            break;
            
        default:
            player.call('chatMessage', ['SYSTEM', `Unknown command: /${cmd}`]);
            break;
    }
});

// System message function
mp.events.add('serverSystemMessage', (player, message) => {
    player.call('chatMessage', ['SYSTEM', message]);
});

// Player join handler
mp.events.add('playerJoin', (player) => {
    // Send welcome message after a short delay
    setTimeout(() => {
        player.call('chatMessage', ['SYSTEM', 'Welcome to the server! Use /car [modelname] to spawn a vehicle.']);
    }, 2000);
});

console.log('Chat and commands system loaded');