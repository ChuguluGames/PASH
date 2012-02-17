# table definition
DifferenceDefinition = persistence.define 'difference', {}

DifferenceDefinition.hasMany('difference_points', DifferencePointModel, 'difference')

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
	json = (if json.difference? then json.differece else json)
	difference = new DifferenceDefinition(identity: json.identity)
	difference.difference_points.add(DifferencePointModel.fromJSON(diffPoint)) for diffPoint in json.point_diffs
	difference

exports.DifferenceModel = DifferenceDefinition