# table definition
DifferenceDefinition = persistence.define 'difference', {}

# relations
# DifferenceDefinition.hasMany('difference_points', DifferencePointModel, 'difference')

# custom methods
# DifferenceDefinition.fetchSelected = ->
#  DifferenceDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

DifferenceDefinition::differencePointsArray = null

DifferenceDefinition::fetchPoints = (callback) ->
	self=@
	self.difference_points.list (points) ->
		app.helpers.polygoner.orderPoints points
		self.differencePointsArray = []
		for point in points
			self.differencePointsArray.push point.getSimpleObject()
		callback(self.differencePointsArray) if callback?

DifferenceDefinition::getSimpleObject = ->
	simple =
		isClued              : false
		isFound              : false
		differencePointsArray: @differencePointsArray

# custom mapping
DifferenceDefinition.fromJSON = (json) ->
	json = (if json.difference? then json.differece else json)
	difference = new DifferenceDefinition(identity: json.identity)
	difference.difference_points.add(DifferencePointModel.fromJSON(diffPoint)) for diffPoint in json.point_diffs
	difference

# making it visible outside as Model
exports.DifferenceModel = DifferenceDefinition
