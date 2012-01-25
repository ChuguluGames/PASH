class exports.PointHelper
	constructor: (x, y) ->
		self=@
		self.x = x
		self.y = y
		# don't know what it is
		self._x = (x + 180) * 360
		self._y = (y + 90) * 180

	# get the squared distance between points
	distanceTo: (point) ->
		self=@
		dX = point._x - self._x
		dY = point._y - self._y
		Math.sqrt(dX * dX + dY * dY)

	# get the slope between point
	slopeTo: (point) ->
		self=@
		dX = point._x - self._x
		dY = point._y - self._y
		dY / dX