class exports.SurvivalGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new SurvivalSpotsEngine(self, lastGame)
		console.log self.engine.toJSON()

	## delegate
	## game over
	timeOut: -> console.log "timeOut"
	## delegate