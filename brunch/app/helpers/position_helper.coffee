class exports.PositionHelper
	# dependencies: LogHelper

	@tag = "PositionHelper"

	@getRelativePosition = (element, absolutePosition) ->
		offset = $(element).offset(); # from jquery
		relativePosition =
			x: absolutePosition.x - offset.left
			y: absolutePosition.y - offset.top

		LogHelper.info relativePosition, @tag

		relativePosition