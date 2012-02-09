class exports.CollisionHelper
	# dependencies: PolygonHelper

	@tag = "CollisionHelper"

	# check if a circle is in a polygon (polygon pints sould be ordered first)
	@circleCollisionToPolygon = (circle, polygon) ->
		circleInPolygon = false

		# center of the circle is in the polygon
		return true if PolygonHelper.isPointInPolygon circle.center, polygon

		l = polygon.length
		i = 0
		y = 1
		while i < l
			y = 0 if i is l - 1
			edge = polygon[i]
			nextEdge = polygon[y]

			segment =
				start: edge
				end  : nextEdge

			# get the closest distance (project of the point on the segment) between the segment and the circle center
			distance = @getDistanceBetweenPointAndSegment(circle.center, segment)

			# the distance is lower than the circle center, so the circle is in collision with the polygon
			return true if distance <= circle.radius

			i++
			y++

		false

	# source: http://coding.pressbin.com/65/PHP-Find-shortest-distance-from-point-to-line-segment
	@getDistanceBetweenPointAndSegment = (point, segment) ->
		segmentEndSegmentStartX = segment.end.x - segment.start.x
		segmentEndSegmentStartY = segment.end.y - segment.start.y
		pointSegmentStartX = point.x - segment.start.x
		pointSegmentStartY = point.y - segment.start.y

		r_numerator = pointSegmentStartX * segmentEndSegmentStartX + pointSegmentStartY * segmentEndSegmentStartY
		r_denominator = Math.pow(segmentEndSegmentStartX, 2) + Math.pow(segmentEndSegmentStartY, 2)

		r = r_numerator / r_denominator
		s = ((segment.start.y - point.y) * segmentEndSegmentStartX - (segment.start.x - point.x) * segmentEndSegmentStartY) / r_denominator

		distanceLine = Math.abs(s) * Math.sqrt(r_denominator)

		if r >= 0 and r <= 1
			distanceSegment = distanceLine
		else
			dist1 = Math.pow(pointSegmentStartX, 2) + Math.pow(pointSegmentStartY, 2)
			dist2 = Math.pow(point.x - segment.end.x, 2) + Math.pow(point.y - segment.end.y, 2)
			if dist1 < dist2
				distanceSegment = Math.sqrt(dist1)
			else
				distanceSegment = Math.sqrt(dist2)
		distanceSegment