class exports.SurvivalGameController extends ScoringGameController

	initializeEngine: (lastGame) ->
		@engine = new SurvivalSpotsEngine(@, lastGame)

	# update the clues number
	# disable button when no more clues
	#