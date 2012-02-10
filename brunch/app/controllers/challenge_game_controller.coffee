class exports.ChallengeGameController extends ScoringGameController

	initializeEngine: (lastGame) ->
		@engine = new ChallengeSpotsEngine(@, lastGame)

	## delegate
	didFindAllDifferences: ->
		console.log "found everything, a winner is you, kthx"