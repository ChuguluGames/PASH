# table definition
DifferencePointDefinition = persistence.define 'difference_point',
  x: "INT"
  y: "INT"

# relations

# custom methods
# ItemDefinition.fetchSelected = ->
# ItemDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

	# get the squared distance between points
DifferencePointDefinition::distanceTo = (point) ->
	dX = point.x - @x
	dY = point.y - @y
	Math.sqrt(dX * dX + dY * dY)

	# get the slope between point
DifferencePointDefinition::slopeTo = (point) ->
	dX = point.x - @x
	dY = point.y - @y
	dY / dX

DifferencePointDefinition::getSimpleObject = ->
	new Object
		x: @x
		y: @y

# custom mapping
DifferencePointDefinition.fromJSON = (json) ->
  new DifferencePointDefinition((if json.point_diff? then json.point_diff else json))

# making it visible outside as Model
exports.DifferencePointModel = DifferencePointDefinition
