class exports.PolygonHelper
	self=@

	self.tag = "PolygonHelper"

	# check if the point is in the polygon
	self.isPointInPolygon = (point, polygon) ->
		inPolygon = false
		i = 0
		j = polygon.length - 1

		while i < polygon.length
			inPolygon = not inPolygon  if (polygon[i].y > point.y) isnt (polygon[j].y > point.y) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x)
			j = i++

		app.helpers.log.info "the point", point, "is in the polygon", self.tag if inPolygon

		console.log inPolygon
		inPolygon

	# get the extremity of the polygon and return a rectangle
	self.polygonToRectangle = (polygon) ->
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

		app.helpers.log.info "the bounds of polygon are ", bounds, self.tag

		return {
			dimensions:
				width : bounds.x2 - bounds.x
				height: bounds.y2 - bounds.y
			position:
				x: bounds.x
				y: bounds.y
		}

	self.getRectangleCenter = (rectangle) ->
		center = {
			x: rectangle.dimensions.width / 2 + rectangle.position.x
			y: rectangle.dimensions.height / 2 + rectangle.position.y
		}

		center

	# create a rectangle bound to the target and center relativly to the point
	self.rectangleFromPointAndTarget = (point, target, dimensions) ->
		center =
			x: point.x - dimensions.width / 2
			y: point.y - dimensions.height / 2

		rectangle =
			dimensions: dimensions
			position: center

		app.helpers.log.info "the rectangle generated is ", rectangle, self.tag

		rectangle

	# order the polygon point clockwise
	self.orderPoints = (points) ->
		upperPoint = self.getUpperLeftPoint(points)

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

		points.sort(sortPoints)

	# get the upper left point of a polygon
	self.getUpperLeftPoint = (points) ->
		top = points[0]
		i = 1

		while i < points.length
			temp = points[i]
			top = temp if temp.y > top.y or (temp.y is top.y and temp.x < top.x)
			i++
		top