// Main client entry point
console.log('Client scripts loading...');

// Load the login module
require('./login/index.js');
require('./playerIDDisplay.js');
require('./custom-chat/index.js');

// Client initialization
mp.events.add('render', () => {
    // This confirms the client is running (only once)
    if (mp.players.local.getVariable('firstConnect') !== true) {
        mp.players.local.setVariable('firstConnect', true);
        console.log('Client initialized');
    }
});

// Global notification handler
mp.events.add('showNotification', (message) => {
    mp.game.ui.setNotificationTextEntry('STRING');
    mp.game.ui.addTextComponentSubstringPlayerName(message);
    mp.game.ui.drawNotification(false, false);
    
    // Also show in chat for debugging
    mp.gui.chat.push(`Notification: ${message}`);
});