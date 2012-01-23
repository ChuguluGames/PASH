/**
* @author David <david@chugulu.com>
*/

function activateFastClicks() {
	(function($){
		// Special event definition.
		$.event.special.click = {
			setup: function() {
				var self = this;
				console.log ("fastclick")
				// add fastbutton on the element if it doesnt exist yet
				if($(self).data("fastbutton") === undefined) {
					// console.log("add fclick to " + $(this).attr("id"))
					$(self).data("fastbutton", new fastButton(self));
				}
			},
			teardown: function() {
				var self = this;

				// destroy fastbutton
				$(self).unbind("touchstart")
				$(self).data("fastbutton", null);
			}
		};

	})(jQuery);

	$("a").on ("click", function(event) {
		return true;
	});
}

/* Construct the FastButton with a reference to the element and click handler. */
var fastButton = function (element) {
	var self = this;

	self.element = element;

	if(element.addEventListener) {
		element.addEventListener('touchstart', self, false);
	}
};

/* acts as an event dispatcher */
fastButton.prototype.handleEvent = function(event) {
	console.log ("fastcliced")

	event.preventDefault();
	event.stopPropagation();

	var dispatch = jQuery.Event("click");
	dispatch.type = "click";
	dispatch.pageX = event.touches[0].clientX;
	dispatch.pageY = event.touches[0].clientY;
	$(self.element).trigger(dispatch);

	return false;
};