function View(attributes) {
	for (var prop in attributes) {
		this[prop] = attributes[prop];
	}

	this.el = null

	// create the element
	this.make();

	this.initialize();
}

View.prototype.tagName = "div";
View.prototype.id = null;
View.prototype.className = null;

View.prototype.make = function() {
	var attributes = {};

	if (this.id) attributes.id = this.id;
	if (this.className) attributes['class'] = this.className;

	var el = document.createElement(this.tagName);
	if (attributes) $(el).attr(attributes);
	this.el = el;
},

View.prototype.initialize = function() {};
View.prototype.render = function() {};
View.prototype.destroy = function() {};