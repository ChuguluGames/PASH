helper={}

helper.verbose=false
helper.tag = "PositionHelper"

helper.log = (message) ->
  console.log "[" + helper.tag + "] " , message if message? && @verbose

helper.getRelativePosition = (element, absolutePosition) ->
	offset = $(element).offset(); # from jquery
	relativePosition=
		x: absolutePosition.x - offset.left
		y: absolutePosition.y - offset.top

	PositionHelper.log relativePosition

	return relativePosition

helper.isPointInPolygon = (point, polygon) ->
	inPolygon = false
	i = -1
	polygonSides = polygon.length
	j = polygonSides - 1

	while ++i < polygonSides
		(polygon[i].y <= point.y and point.y < polygon[j].y) or
		(polygon[j].y <= point.y and point.y < polygon[i].y) and
		(point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) and
		(inPolygon = not inPolygon)
		j = i

	helper.log inPolygon
	inPolygon

exports.PositionHelper=helper