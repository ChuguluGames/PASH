class exports.PositionHelper
	self=@

	self.tag = "PositionHelper"

	self.getRelativePosition = (element, absolutePosition) ->
		offset = $(element).offset(); # from jquery
		relativePosition=
			x: absolutePosition.x - offset.left
			y: absolutePosition.y - offset.top

		app.helpers.log.info relativePosition, self.tag

		relativePosition