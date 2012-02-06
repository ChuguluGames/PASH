(function($) {
	function _pop(options) {

		$.extend({
			element: null,
			direction: "in",
			reverse: false,
			duration: 350,
			complete: null
		}, options);

		jElement = $(options.element);
		elementClasses = 'animating pop ' + options.direction + (options.reverse ? ' reverse' : '');

		jElement[0].style.webkitAnimationDuration = options.duration + "ms";

		jElement[0].addEventListener("webkitAnimationEnd", function(){
			if (options.direction == "out" || options.reverse && options.direction == "in")
				jElement.hide()

			jElement.removeClass(elementClasses);

			if (options.complete) options.complete()
		}, false);

		jElement.addClass(elementClasses).show();

	}

	$.fn.popIn = function(duration, complete) {
		this.each(function() { _pop({
			element: this,
			direction: "in",
			reverse: false,
			complete: complete
		}); });
	}
	$.fn.popOut = function(duration, complete) {
		this.each(function() { _pop({
			element: this,
			direction: "in",
			reverse: true,
			complete: complete
		}); });
	}
})(jQuery);