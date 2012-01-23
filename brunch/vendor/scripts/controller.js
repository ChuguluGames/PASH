function Controller(attributes) {
	var self = this;

	// add the new properties
	for (var prop in attributes) {
		self[prop] = attributes[prop];
	}

	// instanciation of the custom events
	self.delegateEvents();

	return self;
}

Controller.prototype.initialize = function() {};

Controller.prototype.eventSplitter = /^(\S+)\s*(.*)$/;
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

Controller.prototype.subscribers = function() {};

// add subscriber
Controller.prototype.on = function(eventType, fn) {
	var prop = eventType.split(":")[1];
	// add the watcher
  if (!this.watchers[prop]) {
  	this.watch(prop, this.trigger);
  }

  if (!this.subscribers[eventType]) {
    this.subscribers[eventType] = [];
  }
  this.subscribers[eventType].push(fn);
};

// remove subscriber
Controller.prototype.off = function(eventType, fn) {
  var subscribers = this.subscribers[eventType];
  for ( var i = 0; i < subscribers.length; i++) {
    if(subscribers[i] == fn) {
      this.subscribers[eventType].splice(i, 1);
      return true;
    }
  }
  return false;
};

// trigger custom events
Controller.prototype.trigger = function(eventType) {
  if (!this.subscribers[eventType]) { // No subscribers to this event type
    return;
  }
  var subscribers = this.subscribers[eventType].slice(0);
  for(var i = 0; i < subscribers.length; i++) {
    subscribers[i].apply(this, arguments);
  }
};

Controller.prototype.watchers = {};

// watch an object
Controller.prototype.watch = function (prop, handler) {
	var oldVal 	= this[prop];

	this.watchers[prop] = true;

  this.__defineSetter__(prop, function(newVal) {
		this["_" + prop] = newVal;
		handler.call(this, "change:" + prop, prop, oldVal, newVal);
	});

  this.__defineGetter__(prop, function() {
		return this["_" + prop]
	});
};
