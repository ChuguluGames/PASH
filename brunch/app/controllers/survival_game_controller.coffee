class exports.SurvivalGameController extends ScoringGameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new SurvivalSpotsEngine(self, lastGame)
