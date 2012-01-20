function Controller(attributes) {
	var self = this;
	for (var prop in attributes) {
		self[prop] = attributes[prop];
	}

	// instanciation of the events
	self.delegateEvents();

	self.initialize();

	return self;
}

Controller.eventSplitter = /^(\S+)\s*(.*)$/;

Controller.prototype.events = {};

Controller.prototype.delegateEvents = function() {
	var self = this,
			el = self.view.el,
			key, method, match, eventName;

	for (var key in self.events) {
		method = self[self.events[key]];
		match = key.match(Controller.eventSplitter);
		eventName = match[1], selector = match[2];
		if (selector === '') {
			$(el).on(eventName, function(evt) { method.call(self, evt); });
		} else {
			$(el).on(eventName, selector, function(evt) { method.call(self, evt); });
		}
	}
};

Controller.prototype.initialize = function() {};