// This is the entry point for the custom chat
// Include this in your client_packages/index.js with:
// require('./custom-chat/index.js');

// Make sure default chat is disabled
mp.gui.chat.show(false);

// Create the browser
const chat = mp.browsers.new('package://custom-chat/chat.html');

// Debug function
function logDebug(message) {
    mp.console.logInfo(`[CLIENT_DEBUG] ${message}`);
}

logDebug('Client chat script initializing...');

// Event handler for when a message is sent from the server
mp.events.add('chatMessage', (player, message) => {
    logDebug(`Received chat message: player=${player}, message=${message}`);
    
    // Escape special characters to prevent JS injection
    const escapedPlayer = player.replace(/'/g, "\\'").replace(/"/g, '\\"');
    const escapedMessage = message.replace(/'/g, "\\'").replace(/"/g, '\\"');
    
    try {
        chat.execute(`addMessage('${escapedPlayer}', '${escapedMessage}');`);
        logDebug('Message added to chat');
    } catch (error) {
        logDebug(`Error displaying message: ${error.message}`);
    }
});

// Command handler - when T is pressed
mp.keys.bind(0x54, false, function() { // T key
    logDebug('T key pressed, showing chat input');
    mp.gui.chat.show(false); // Ensure default chat stays disabled
    chat.execute('focusChat();');
    mp.gui.cursor.visible = true;
});

// Send message to server
mp.events.add('chatMessageSubmit', (message) => {
    logDebug(`Submitting message: ${message}`);
    
    if (message.trim() === '') return;
    
    if (message.startsWith('/')) {
        // It's a command
        logDebug(`Processing as command: ${message}`);
        mp.events.callRemote('serverCommand', message.substring(1));
    } else {
        // It's a regular message
        logDebug(`Processing as chat message: ${message}`);
        mp.events.callRemote('serverChatMessage', message);
    }
    
    mp.gui.cursor.visible = false;
});

// Allow canceling chat input
mp.keys.bind(0x1B, false, function() { // ESC key
    if (mp.gui.cursor.visible) {
        logDebug('ESC key pressed, canceling chat input');
        chat.execute('cancelChatInput();');
        mp.gui.cursor.visible = false;
    }
});

// Add debug info
mp.events.add('render', () => {
    // Ensure default chat stays disabled
    mp.gui.chat.show(false);
});

// Add a chat initialization event to confirm it's loaded
mp.events.add('browserDomReady', (browser) => {
    if (browser === chat) {
        // Chat browser is ready
        logDebug('Chat browser ready, initializing...');
        mp.events.callRemote('serverSystemMessage', 'Custom chat initialized successfully');
    }
});

// Log successful initialization
logDebug('Client chat script initialized successfully!');