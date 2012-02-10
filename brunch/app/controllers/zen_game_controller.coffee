class exports.ZenGameController extends GameController

	initializeEngine: (lastGame) ->
		@engine = new ZenSpotsEngine(@, lastGame)

	onClickLink: (event) ->
		super

		if $(event.delegateTarget).hasClass("button-next-item")
			# disable links until next item is loaded
			@disabledClicks = true