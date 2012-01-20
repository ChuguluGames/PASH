helper={}

helper.tag = "RetinaHelper"

helper.getFactor = ->
	resolution = app.client.getResolution()
	factor = 2 / resolution
	factor

helper.positionToRetina = (position) ->
	factor = @getFactor()
	return position if factor == 1
	return {
		x: position.x * factor
		y: position.y * factor
	}

helper.dimensionsToRetina = (dimensions) ->
	factor = @getFactor()
	return dimensions if factor == 1
	return {
		width : dimensions.width * factor
		height: dimensions.height * factor
	}

helper.positionRetinaToClientResolution = (position) ->
	factor = @getFactor()
	return position if factor == 1
	return {
		x: position.x / factor
		y: position.y / factor
	}

helper.dimensionsRetinaToClientResolution = (dimensions) ->
	factor = @getFactor()
	return dimensions if factor == 1
	return {
		width : dimensions.width / factor
		height: dimensions.height / factor
	}

helper.rectangleRetinaToClientResolution = (rectangleRetina) ->
	return rectangleRetina if @getFactor() == 1
	return {
		dimensions: @dimensionsRetinaToClientResolution(rectangleRetina.dimensions)
		position  : @positionRetinaToClientResolution(rectangleRetina.position)
	}

exports.RetinaHelper=helper