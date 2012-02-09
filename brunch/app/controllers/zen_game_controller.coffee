class exports.ZenGameController extends GameController

	initializeEngine: (lastGame) ->
		@engine = new ZenSpotsEngine(@, lastGame)
