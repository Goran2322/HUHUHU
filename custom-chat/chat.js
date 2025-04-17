// Chat configuration
const config = {
    maxMessages: 50,        // Maximum number of messages to show
    hideTimeout: 15000,     // Hide chat after this many milliseconds of inactivity
    fadeTimeout: 3000,      // Start fading after this many milliseconds of inactivity
    commandHistory: []      // Store previous commands for up/down arrow navigation
};

let hideTimeoutId = null;
let currentHistoryIndex = -1;
let chatActive = false;

// Initialize when the document is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Cache DOM elements
    const chatContainer = document.getElementById('chat-container');
    const chatMessages = document.getElementById('chat-messages');
    const inputContainer = document.getElementById('input-container');
    const chatInput = document.getElementById('chat-input');

    // Add initial debug message to verify chat is working
    addDebugMessage('Chat system initialized. Press T to chat.');

    // Initialize chat
    resetTimeout();

    // Listen for input events
    chatInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            const message = chatInput.value;
            
            // Send message to RAGE MP
            if (message.trim() !== '') {
                if (typeof mp !== 'undefined') {
                    try {
                        addDebugMessage(`Sending message: ${message}`);
                        mp.trigger('chatMessageSubmit', message);
                    } catch (error) {
                        addDebugMessage(`Error sending message: ${error.message}`);
                    }
                } else {
                    // Debug mode - add message locally
                    addMessage('DEBUG_USER', message);
                }
                
                // Add to command history if it's a command or regular message
                config.commandHistory.unshift(message);
                if (config.commandHistory.length > 20) {
                    config.commandHistory.pop();
                }
            }
            
            // Clear input and hide
            chatInput.value = '';
            hideInput();
            e.preventDefault();
        } else if (e.key === 'Escape') {
            hideInput();
            e.preventDefault();
        } else if (e.key === 'ArrowUp') {
            // Navigate command history up
            if (config.commandHistory.length > 0) {
                currentHistoryIndex = Math.min(config.commandHistory.length - 1, currentHistoryIndex + 1);
                chatInput.value = config.commandHistory[currentHistoryIndex];
                
                // Move cursor to end
                setTimeout(() => {
                    chatInput.selectionStart = chatInput.selectionEnd = chatInput.value.length;
                }, 0);
            }
            e.preventDefault();
        } else if (e.key === 'ArrowDown') {
            // Navigate command history down
            if (currentHistoryIndex > 0) {
                currentHistoryIndex--;
                chatInput.value = config.commandHistory[currentHistoryIndex];
            } else if (currentHistoryIndex === 0) {
                currentHistoryIndex = -1;
                chatInput.value = '';
            }
            e.preventDefault();
        }
    });

    // Global function to add messages
    window.addMessage = function(player, message) {
        addDebugMessage(`Adding message from ${player}: ${message}`);
        resetTimeout();
        
        // Create message element
        const messageElement = document.createElement('div');
        
        // Check if it's a system message
        if (player === 'SYSTEM') {
            messageElement.className = 'system-message';
            messageElement.innerHTML = `<span class="timestamp">[${getCurrentTime()}]</span> ${message}`;
        } else {
            messageElement.className = 'player-message';
            messageElement.innerHTML = `<span class="timestamp">[${getCurrentTime()}]</span> <span class="player-name">${player}:</span> ${message}`;
        }
        
        // Add to chat container
        chatMessages.appendChild(messageElement);
        
        // Remove old messages if we exceed the limit
        while (chatMessages.children.length > config.maxMessages) {
            chatMessages.removeChild(chatMessages.firstChild);
        }
        
        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;
    };

    // Debug function
    function addDebugMessage(message) {
        const messageElement = document.createElement('div');
        messageElement.className = 'system-message debug-message';
        messageElement.innerHTML = `<span class="timestamp">[${getCurrentTime()}]</span> DEBUG: ${message}`;
        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
        
        console.log(`[CHAT_DEBUG] ${message}`);
    }
    
    window.addDebugMessage = addDebugMessage;

    // Global function to focus the chat
    window.focusChat = function() {
        chatActive = true;
        resetTimeout();
        showInput();
        addDebugMessage('Chat activated');
    };

    // Global function to cancel chat input
    window.cancelChatInput = function() {
        hideInput();
    };

    // Helper functions
    function showInput() {
        inputContainer.style.display = 'block';
        chatContainer.style.opacity = '1';
        chatInput.focus();
        currentHistoryIndex = -1;
    }

    function hideInput() {
        inputContainer.style.display = 'none';
        chatActive = false;
        resetTimeout();
        if (typeof mp !== 'undefined') {
            try {
                mp.trigger('chatClosed');
                addDebugMessage('Chat closed');
            } catch (error) {
                addDebugMessage(`Error closing chat: ${error.message}`);
            }
        }
    }

    function resetTimeout() {
        // Clear existing timeouts
        clearTimeout(hideTimeoutId);
        chatContainer.style.opacity = '1';
        
        // Set new timeout if chat is not active
        if (!chatActive) {
            hideTimeoutId = setTimeout(() => {
                chatContainer.style.transition = 'opacity 1s ease-in-out';
                chatContainer.style.opacity = '0';
            }, config.hideTimeout);
        }
    }

    function getCurrentTime() {
        const now = new Date();
        const hours = now.getHours().toString().padStart(2, '0');
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const seconds = now.getSeconds().toString().padStart(2, '0');
        return `${hours}:${minutes}:${seconds}`;
    }
});

// Debug key handling for testing in browser
if (typeof mp === 'undefined') {
    document.addEventListener('keydown', function(e) {
        if (e.key === 't' || e.key === 'T') {
            window.focusChat();
        }
    });
}