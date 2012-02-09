class exports.ScaleHelper
	@tag = "ScaleHelper"

	@scalePositionTo = (position, scale) ->
		new Object
			x: position.x * scale
			y: position.y * scale

	@scaleDimensionsTo = (dimensions, scale) ->
		new Object
			width : dimensions.width * scale
			height: dimensions.height * scale

	@scaleRectangleTo = (rectangle, scale) ->
		new Object
			dimensions: @scaleDimensionsTo rectangle.dimensions, scale
			position  : @scalePositionTo rectangle.position, scale
