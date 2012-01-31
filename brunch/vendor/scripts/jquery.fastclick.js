/**
* @author David <david@chugulu.com>
*/

function activateFastClicks() {
	(function($){
		// Special event definition.
		$.event.special.click = {
			setup: function() {
				console.log("setup")
				if(typeof $(this).data("fastclick_activated") === undefined || $(this).data("fastclick_activated") !== true) {

					// listen to touchstart event
					$(this).on('touchstart', function(event) {
						// get the first touche
						var touch = event.originalEvent.touches[0];

						// dispatch click event
						$(this).trigger({
							type: 	"click",
							pageX: 	touch.pageX,
							pageY: 	touch.pageY
						});
					});

					$(this).data("fastclick_activated", true);
				}
			},
			teardown: function() {
				// destroy fastbutton
				$(this).unbind("touchstart")
				$(this).data("fastclick_activated", null);
			}
		};

	})(jQuery);
}