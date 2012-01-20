helper={}

helper.tag = "PolygonHelper"

# check if the point is in the polygon
helper.isPointInPolygon = (point, polygon) ->
	inPolygon = false
	i = 0
	j = polygon.length - 1

	while i < polygon.length
	  inPolygon = not inPolygon  if (polygon[i].y > point.y) isnt (polygon[j].y > point.y) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x)
	  j = i++

	app.log.info "the point", point, "is in the polygon", @tag if inPolygon
	inPolygon

# get the extremity of the polygon and return a rectangle
helper.polygonToRectangle = (polygon) ->
	polygon = app.helpers.db.collectionToArray polygon

	bounds =
		x: null
		y: null
		x2: null
		y2: null

	i = 0
	j = polygon.length - 1

	while i < polygon.length
		point = polygon[i]
		bounds.x = if not bounds.x then point.x else Math.min point.x, bounds.x
		bounds.y = if not bounds.y then point.y else Math.min point.y, bounds.y
		bounds.x2 = if not bounds.x2 then point.x else Math.max point.x, bounds.x2
		bounds.y2 = if not bounds.y2 then point.y else Math.max point.y, bounds.y2

		i++

	app.log.info "the bounds of polygon are ", bounds, @tag

	return {
		dimensions:
			width: bounds.x2 - bounds.x
			height: bounds.y2 - bounds.y
		position:
			x: bounds.x
			y: bounds.y
	}

# create a rectangle bound to the target and center relativly to the point
helper.rectangleFromPointAndTarget = (point, target, dimensions) ->
	targetElement = $(target)
	targetDimensions =
		width: targetElement.width()
		height: targetElement.height()

	center =
		x: point.x - dimensions.width / 2
		y: point.y - dimensions.height / 2

	position =
		x: Math.min(targetDimensions.width - dimensions.width, Math.max(0, center.x))
		y: Math.min(targetDimensions.height - dimensions.height, Math.max(0, center.y))

	rectangle =
		dimensions: dimensions
		position: position

	app.log.info "the rectangle generated is ", rectangle, @tag

	rectangle

exports.PolygonHelper=helper