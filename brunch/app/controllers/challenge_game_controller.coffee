class exports.ChallengeGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new ChallengeSpotsEngine(self, lastGame)
		console.log self.engine.toJSON()

	## delegate
	didFindAllDifferences: ->
		console.log "found everything, a winner is you, kthx"

	timeOut: -> console.log "timeOut"
	## delegate