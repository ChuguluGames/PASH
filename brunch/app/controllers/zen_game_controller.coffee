class exports.ZenGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new ZenSpotsEngine(self, lastGame)
		console.log self.engine.toJSON()

	getNextItem: ->
		self=@
		# get index
		self.itemNext = (self.itemCurrent + 1) % self.items.length
		# get route
		self.itemNextRoute = app.router.getItemRoute(self.mode, self.itemNext)
		self.itemNext

	getPreviousItem: ->
		self=@
		# get index
		self.itemPrevious = if self.itemCurrent > 0 then self.itemCurrent - 1 else self.items.length - 1

		# get the route
		self.itemPreviousRoute = app.router.getItemRoute(self.mode, self.itemPrevious)
		self.itemPrevious