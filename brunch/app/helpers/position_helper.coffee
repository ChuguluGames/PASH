helper={}

helper.tag = "PositionHelper"

helper.getRelativePosition = (element, absolutePosition) ->
	offset = $(element).offset(); # from jquery
	relativePosition=
		x: absolutePosition.x - offset.left
		y: absolutePosition.y - offset.top

	app.helpers.log.info relativePosition, @tag

	relativePosition

exports.PositionHelper=helper