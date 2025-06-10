let hudVisible = false;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'showHUD':
            showHUD();
            break;
        case 'hideHUD':
            hideHUD();
            break;
        case 'updateHUD':
            updateHUD(data);
            break;
    }
});

function showHUD() {
    hudVisible = true;
    document.getElementById('playerHUD').classList.remove('hidden');
}

function hideHUD() {
    hudVisible = false;
    document.getElementById('playerHUD').classList.add('hidden');
}

function updateHUD(data) {
    if (!hudVisible) return;
    
    // Update player ID
    document.getElementById('playerId').textContent = data.playerId;
    
    // Update playtime
    document.getElementById('playTime').textContent = data.playTime;
    
    // Update voice mode with animation
    const voiceModeElement = document.getElementById('voiceMode');
    if (voiceModeElement.textContent !== data.voiceMode) {
        voiceModeElement.textContent = data.voiceMode;
        document.querySelector('.voice-info').classList.add('pulse');
        setTimeout(() => {
            document.querySelector('.voice-info').classList.remove('pulse');
        }, 300);
    }
    
    // Update street name WITHOUT adding "St"
    document.getElementById('streetName').textContent = data.streetName;
    
    // Update zone name
    document.getElementById('zoneName').textContent = data.zoneName;
    
    // Update compass direction - only the letter part
    const compassElement = document.getElementById('compassDirection');
    const directionMap = {
        'North': 'N',
        'South': 'S',
        'East': 'E',
        'West': 'W'
    };
    const shortDirection = directionMap[data.direction] || 'N';
    compassElement.textContent = ` ${shortDirection} `;
}

// Optional: Add smooth transitions for value changes
let lastValues = {
    playerId: '',
    playTime: '',
    voiceMode: '',
    streetName: '',
    zoneName: '',
    direction: ''
};

function animateChange(elementId, newValue) {
    const element = document.getElementById(elementId);
    if (lastValues[elementId] !== newValue) {
        element.style.transition = 'opacity 0.2s ease';
        element.style.opacity = '0.5';
        setTimeout(() => {
            element.textContent = newValue;
            element.style.opacity = '1';
        }, 200);
        lastValues[elementId] = newValue;
    }
}