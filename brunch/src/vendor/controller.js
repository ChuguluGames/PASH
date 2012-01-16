function Controller(view) {
	this.view = view;
	this.initialize();
}

Controller.prototype.events = {};

Controller.prototype.initialize = function() {
	// instanciation of the events
	for (var event_type in this.events) {

	}
};