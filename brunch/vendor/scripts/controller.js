function Controller(attributes) {
	for (var prop in attributes) {
		this[prop] = attributes[prop];
	}

	// instanciation of the events
	this.delegateEvents();

	this.initialize();
}

Controller.eventSplitter = /^(\S+)\s*(.*)$/;

Controller.prototype.events = {};

Controller.prototype.delegateEvents = function() {
	var self = this,
			el = this.view.el,
			key, method, match, eventName;

	for (var key in this.events) {
		method = this[this.events[key]];
		match = key.match(Controller.eventSplitter);
		eventName = match[1], selector = match[2];
		if (selector === '') {
			$(el).on(eventName, method);
		} else {
			$(el).on(eventName, selector, method);
		}
	}
};

Controller.prototype.initialize = function() {};