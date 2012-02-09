class exports.SurvivalGameController extends ScoringGameController

	initializeEngine: (lastGame) ->
		@engine = new SurvivalSpotsEngine(@, lastGame)
