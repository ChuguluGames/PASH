if (typeof PhoneGap === "undefined") {
	var PhoneGap = {};

	if (!window.plugins) {
			window.plugins = {};
	}

	PhoneGap.fire = function(eventType) {
		var event = document.createEvent('Event');
		event.initEvent(eventType, true, false);
		document.dispatchEvent(event);
	};

	PhoneGap.exec = function(success, fail, service, action, args) {

	};

	PhoneGap.addConstructor = function(func) {
		func();
	};

	PhoneGap.addPlugin = function(name, obj) {
		if (!window.plugins[name]) {
			window.plugins[name] = obj;
		}
		else {
			console.log("Error: Plugin " + name + " already exists.");
		}
	};

	PhoneGap.onDeviceReady = {
		fired: true
	};
	PhoneGap.fire("deviceready");
}