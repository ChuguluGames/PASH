class exports.SurvivalGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new SurvivalSpotsEngine(self, lastGame)

	## delegate
	## game over
	timeOut: -> console.log "timeOut"
	## delegate