function preferenceGet() {
    nbridge.preference.get('key', 'defaultValue').then(function(value) {
        alert('value : ' + value);
    });
}

function preferenceSet() {
    nbridge.preference.set('key', 'value');
}

function preferenceRemove() {
    nbridge.preference.remove('key');
}

function locationAvailable() {
    nbridge.location.available().then(function(result) {
        // 위치 권한
        alert('available');
    }, function(error) {
        alert('not available');
    });
}

function locationCurrent() {
    nbridge.location.current().then(function(result) {
//        alert('longitude : ' + result.longitude + '\nlatitude : ' + result.latitude);
        updateLocationInfo('longitude : ' + result.longitude + '\n latitude: ' + result.latitude);
    }, function(error) {
        alert('error : ' + error);
        updateLocationInfo('')
    });
    updateLocationInfo('running');
}

function locationWatch() {
    nbridge.location.watch(function(position) {
        updateLocationInfo('longitude : ' + result.longitude + '\n latitude: ' + result.latitude);
    }).then(function(result) {
    }, function(error) {
        alert('error : ' + error);
        updateLocationInfo('')
    });
    updateLocationInfo('watching');

}

function locationClearWatch() {
    updateLocationInfo('')
    nbridge.location.clearWatch().then(function(result) {
        alert('success to clear watch');
    }, function(error) {
        alert('error : ' + error);
    });
}

function updateLocationInfo(msg) {
    document.getElementById('loc').innerHTML = msg
}

