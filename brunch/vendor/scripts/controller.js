function Controller(attributes) {
	var self = this;

	// add the new properties
	for (var prop in attributes) {
		self[prop] = attributes[prop];
	}

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
		match = key.match(this.eventSplitter);
		eventName = match[1], selector = match[2];

		self.delegateEvent(selector, el, eventName, method);
	}
};

Controller.prototype.delegateEvent = function(selector, el, eventName, method) {
	var self = this;

	if (selector === '') {
		$(el).on(eventName, function(evt) { return method.call(self, evt); });
	} else {
		$(selector, el).on(eventName, function(evt) { return method.call(self, evt); });
	}
};

Controller.prototype.onClickLink = function(event) {
	event.preventDefault();
	var route = $(event.target).addClass("clicked").attr("href");

	if (route.substr(0, 1) == "#") {
		app.router.setRoute(route.substr(2)); // get ride of #/
	}
	else {
		window.location.href = route;
	}
	return false;
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
