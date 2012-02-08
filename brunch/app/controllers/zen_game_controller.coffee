class exports.ZenGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new ZenSpotsEngine(self, lastGame)
