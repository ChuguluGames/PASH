class exports.ChallengeGameController extends ScoringGameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new ChallengeSpotsEngine(self, lastGame)

	## delegate
	didFindAllDifferences: ->
		console.log "found everything, a winner is you, kthx"
