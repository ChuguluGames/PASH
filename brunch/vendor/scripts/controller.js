function Controller(attributes) {
	var self = this;

	// add the new properties
	for (var prop in attributes) {
		self[prop] = attributes[prop];
	}

	return self;
}

Controller.prototype.initialize = function() {};

Controller.prototype.destroy = function() {
	this.delegateEvents('off');
	this.onDestroy();
};

Controller.prototype.activate = function() {
	this.onActivate();
};

Controller.prototype.onDestroy = function() {};
Controller.prototype.onActivate = function() {};

Controller.prototype.eventSplitter = /^(\S+)\s*(.*)$/;
Controller.prototype.events = {
	"click a": "onClickLink"
};

Controller.prototype.delegateEvents = function(action) {
	if (typeof action == 'undefined') {
		action = 'on';
	}
	var self = this,
			el = self.view.el,
			key, method, match, eventName;

	for (var key in self.events) {
		method = self[self.events[key]];
		match = key.match(this.eventSplitter);
		eventName = match[1], selector = match[2];

		self.delegateEvent(selector, el, eventName, method, action);
	}
};

Controller.prototype.delegateEvent = function(selector, el, eventName, method, action) {
	var self = this;

	if (selector == "document" || selector == "window") {
		el = window[selector];
		selector = "";
	}
	// TODO: find a way to link anonymous function (off)
	if (selector === '') {
		if (action == "off")
				$(el).off(eventName);
		else
			$(el).on(eventName, function(evt) { return method.call(self, evt); });
	} else {
		if (action == "off")
				$(el).off(eventName);
		else
			$(selector, el).on(eventName, function(evt) { return method.call(self, evt); });
	}
};

Controller.prototype.onClickLink = function(event) {
	event.preventDefault();
	if (event.target.tagName != "A") {
		var parent = $(event.target).parent()[0]
		if (parent.tagName == "A") {
			event.target = parent
		} else {
			return false;
		}
	}
	var route = $(event.target).attr("href");

	if (route.substr(0, 1) == "#" && route.length > 1) {
		app.router.setRoute(route.substr(2)); // get ride of #/
	} else if (route !== "" && route !== "#") {
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
