class exports.PositionHelper
	getRelativePosition: (element, absolutePosition) ->
		offset = $(element).offset(); # from jquery

		return {
			x: absolutePosition.x - offset.left
			y: absolutePosition.y - offset.top
		}

	isPointInPolygon = (point, polygon) ->
	  c = false
	  i = -1
	  l = polygon.length
	  j = l - 1

	  while ++i < l
	    (polygon[i].y <= point.y and point.y < polygon[j].y) or (polygon[j].y <= point.y and point.y < polygon[i].y) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) and (c = not c)
	    j = i
	  c