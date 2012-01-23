helper={}

helper.tag = "RetinaHelper"

helper.positionToRetina = (position) ->
	return {
		x: position.x * 2
		y: position.y * 2
	}

helper.positionRetinaToNonRetina = (position) ->
	return {
		x: position.x / 2
		y: position.y / 2
	}

helper.dimensionsRetinaToNonRetina = (dimensions) ->
	return {
		width : dimensions.width / 2
		height: dimensions.height / 2
	}

helper.rectangleRetinaToNonRetina = (rectangleRetina) ->
	return {
		dimensions: @dimensionsRetinaToNonRetina(rectangleRetina.dimensions)
		position  : @positionRetinaToNonRetina(rectangleRetina.position)
	}

exports.RetinaHelper=helper