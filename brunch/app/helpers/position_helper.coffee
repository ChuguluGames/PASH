helper={}

helper.verbose=false
helper.tag = "PositionHelper"

helper.log = (message) ->
  console.log "[" + helper.tag + "] " , message if message? && @verbose

helper.getRelativePosition = (element, absolutePosition) ->
	offset = $(element).offset(); # from jquery
	relativePosition=
		x: absolutePosition.x - offset.left
		y: absolutePosition.y - offset.top

	PositionHelper.log relativePosition

	relativePosition

exports.PositionHelper=helper