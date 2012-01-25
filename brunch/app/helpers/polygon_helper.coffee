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

	app.helpers.log.info "the point", point, "is in the polygon", @tag if inPolygon
	inPolygon

# get the extremity of the polygon and return a rectangle
helper.polygonToRectangle = (polygon) ->
	bounds =
		x: null
		y: null
		x2: null
		y2: null

	i = 0
	j = polygon.length - 1

	while i < polygon.length
		point = polygon[i]
		bounds.x  = if not bounds.x then point.x else Math.min point.x, bounds.x
		bounds.y  = if not bounds.y then point.y else Math.min point.y, bounds.y
		bounds.x2 = if not bounds.x2 then point.x else Math.max point.x, bounds.x2
		bounds.y2 = if not bounds.y2 then point.y else Math.max point.y, bounds.y2

		i++

	app.helpers.log.info "the bounds of polygon are ", bounds, @tag

	return {
		dimensions:
			width : bounds.x2 - bounds.x
			height: bounds.y2 - bounds.y
		position:
			x: bounds.x
			y: bounds.y
	}

# create a rectangle bound to the target and center relativly to the point
helper.rectangleFromPointAndTarget = (point, target, dimensions) ->
	targetElement = $(target)
	targetDimensions =
		width : targetElement.width()
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

	app.helpers.log.info "the rectangle generated is ", rectangle, @tag

	rectangle

# order the polygon point clockwise
helper.orderPoints = (points) ->
	self=@

	pointsToBeOrder = []
	for point in points
		pointsToBeOrder.push(new app.helpers.point(point.x, point.y))

	upperPoint = self.getUpperLeftPoint(pointsToBeOrder)

	# custom array sort function
	sortPoints = (pointA, pointB) ->
		# exclude the upper point fron the sort
		return -1 if pointA is upperPoint
		return 1 if pointB is upperPoint
		# get the slope of the point when a line is rawn from those points through the upper point
		slopeA = upperPoint.slopeTo(pointA)
		slopeB = upperPoint.slopeTo(pointB)
		# the point are on the same line towards the upper one
		return (if pointA.distanceTo(upperPoint) < pointB.distanceTo(upperPoint) then -1 else 1) if slopeA is slopeB
		# if the pointA is to the right of the upper one and pointB to the left
		return -1 if slopeA <= 0 and slopeB > 0
		# if the pointA is to the left of the upper one and pointB to the right
		return 1 if slopeA > 0 and slopeB <= 0
		# both slopes are either positive, or negative
		(if slopeA > slopeB then -1 else 1)

	pointsToBeOrder.sort(sortPoints)
	pointsToBeOrder

# get the upper left point of a polygon
helper.getUpperLeftPoint = (points) ->
	top = points[0]
	i = 1

	while i < points.length
		temp = points[i]
		top = temp if temp.y > top.y or (temp.y is top.y and temp.x < top.x)
		i++
	top

exports.PolygonHelper=helper