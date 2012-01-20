function View(attributes) {
	var self = this;
	for (var prop in attributes) {
		self[prop] = attributes[prop];
	}

	self.el = null

	// create the element
	self.make();

	self.initialize();

	return self;
}

View.prototype.tagName = "div";
View.prototype.id = null;
View.prototype.className = null;

View.prototype.make = function() {
	var self = this,
			attributes = {};

	if (self.id) attributes.id = self.id;
	if (self.className) attributes['class'] = self.className;

	var el = document.createElement(self.tagName);
	if (attributes) $(el).attr(attributes);
	self.el = el;
},

View.prototype.initialize = function() {};
View.prototype.render = function() {};
View.prototype.destroy = function() {
	$(this.el).remove();
};