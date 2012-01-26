class exports.RetinaHelper
	self=@

	self.tag = "RetinaHelper"

	self.positionToRetina = (position) ->
		return {
			x: position.x * 2
			y: position.y * 2
		}

	self.positionRetinaToNonRetina = (position) ->
		return {
			x: position.x / 2
			y: position.y / 2
		}

	self.dimensionsRetinaToNonRetina = (dimensions) ->
		return {
			width : dimensions.width / 2
			height: dimensions.height / 2
		}

	self.rectangleRetinaToNonRetina = (rectangleRetina) ->
		return {
			dimensions: self.dimensionsRetinaToNonRetina(rectangleRetina.dimensions)
			position  : self.positionRetinaToNonRetina(rectangleRetina.position)
		}