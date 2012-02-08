class exports.RetinaHelper
	self=@

	self.tag = "RetinaHelper"

	self.positionToRetina = (position) ->
		return {
			x: (position.x * 2) / DynamicScreenHelper.itemRatio
			y: (position.y * 2) / DynamicScreenHelper.itemRatio
		}

	self.positionRetinaToNonRetina = (position) ->
		return {
			x: (position.x / 2) * DynamicScreenHelper.itemRatio
			y: (position.y / 2) * DynamicScreenHelper.itemRatio
		}

	self.dimensionsRetinaToNonRetina = (dimensions) ->
		return {
			width : (dimensions.width / 2) * DynamicScreenHelper.itemRatio
			height: (dimensions.height / 2) * DynamicScreenHelper.itemRatio
		}

	self.rectangleRetinaToNonRetina = (rectangleRetina) ->
		return {
			dimensions: self.dimensionsRetinaToNonRetina(rectangleRetina.dimensions)
			position  : self.positionRetinaToNonRetina(rectangleRetina.position)
		}