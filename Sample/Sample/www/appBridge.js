nbridge.app = (function(nbridge) {
	return {
		service : 'app',
		appInfo : function() {
			return nbridge.callToNative(this.service, 'appInfo', {});
		}, 
		deviceInfo : function() { 
			return nbridge.callToNative(this.service, 'deviceInfo', {});
		}, 
		exit : function() {
			nbridge.callToNative(this.service, 'exit', {});
		}
	}
})(nbridge);
