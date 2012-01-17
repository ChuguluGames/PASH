/**
* @author David <david@chugulu.com>
*/

(function($){
	// Special event definition.
	$.event.special.click = {
		setup: function() {
			var self = this;
			// add fastbutton on the element if it doesnt exist yet
			if($(self).data("fastbutton") === undefined) {
				// console.log("add fclick to " + $(this).attr("id"))
				$(self).data("fastbutton", new fastButton(self));
			}
		},
		teardown: function() {
			var self = this;

			// destroy fastbutton
			$(self).unbind("click,touchstart,touchmove,touchend")
			$(self).data("fastbutton", null);
		}
	};

})(jQuery);

/* Construct the FastButton with a reference to the element and click handler. */
var fastButton = function (element) {
	var self = this;

	self.element = element;

	if(element.addEventListener) {
		element.addEventListener('click', self, false);
		element.addEventListener('touchstart', self, false);
	}
};

fastButton.prototype.startX = null;
fastButton.prototype.startY = null;

/* acts as an event dispatcher */
fastButton.prototype.handleEvent = function(event) {
	var self = this;

	switch(event.type) {
		case 'touchstart':
			// save the position
			self.startX = event.touches[0].clientX;
			self.startY = event.touches[0].clientY;

			self.element.addEventListener('touchend', self, false);
			document.body.addEventListener('touchmove', self, false);
		break;
		case 'touchmove':
			// check if the user moved more than 10px
			if (Math.abs(event.touches[0].clientX - self.startX) > 10 ||
					Math.abs(event.touches[0].clientY - self.startY) > 10) {
				self.reset();
			}
		break;
		case 'touchend':
			event.stopPropagation();
			self.reset();
			self.onClick(event);

		break;
		case 'click': self.onClick(event); break;
	}
};

fastButton.prototype.reset = function() {
	var self = this;

	self.element.removeEventListener('touchend', self, false);
	document.body.removeEventListener('touchmove', self, false);
};

/*Invoke the actual click handler and prevent ghost clicks if this was a touchend event.*/
fastButton.prototype.onClick = function(event) {
	var self = this;

	event.preventDefault();
	event.stopPropagation();

	var dispatch = jQuery.Event("click");

	dispatch.type = "click";

	switch (event.type) {
		case 'touchend':
			dispatch.pageX = self.startX;
			dispatch.pageY = self.startY;
		break;
		case 'click':
			dispatch.pageX = event.pageX;
			dispatch.pageY = event.pageY;
		break;
	}
	$(self.element).trigger(dispatch);

	return false;
};