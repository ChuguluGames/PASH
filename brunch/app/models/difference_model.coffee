# table definition
DifferenceDefinition = persistence.define 'difference', {}

DifferenceDefinition::differencePointsArray = null

DifferenceDefinition::fetchPoints = (callback) ->
	@difference_points.list (points) =>
		PolygonHelper.orderPoints points
		@differencePointsArray = []
		for point in points
			@differencePointsArray.push point.getSimpleObject()

		callback(@differencePointsArray) if callback?

DifferenceDefinition::getSimpleObject = ->
	new Object
		isClued              : false
		isFound              : false
		differencePointsArray: @differencePointsArray

# custom mapping
DifferenceDefinition.fromJSON = (json) ->
	json = (if json.difference? then json.difference else json)
	difference = new DifferenceDefinition(identity: json.identity)
	for diffPoint in json.point_diffs
		difference.difference_points.add(DifferencePointModel.fromJSON(diffPoint))
	difference

exports.DifferenceModel = DifferenceDefinition