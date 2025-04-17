// Make sure to register serverCommand and serverChatMessage events
mp.events.add('serverChatMessage', (player, message) => {
    console.log(`Main.js: Received chat message from ${player.name}: ${message}`);
    // Forward to your chat handler
    mp.events.call('chatMessage', player.name, message, 'regular');
});

mp.events.add('serverCommand', (player, command) => {
    console.log(`Main.js: Received command from ${player.name}: /${command}`);
    // Add any global command handling here
});

// Add test command that definitely works
mp.events.addCommand('hello', (player) => {
    player.call('chatMessage', ['SYSTEM', 'Hello there!', 'system']);
});