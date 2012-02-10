class exports.PopupFactory
	@create = (popupName, events, buttons) ->
		popupController = new PopupController()
		popupController.configure
			name     : popupName
			container: $("body")
			events   : events
			buttons  : buttons
		popupController.create()

class exports.PopupTutoFactory
	@create = (mode, action, onCloseAfterOnAction) ->
		popupName = ("tuto_" + mode).toCamelCase()

		events =
			onBack: ->
				@close ->
					app.router.setRoute app.router.getOptionsRoute()

		# onResume | onStart
		events[("on_" + action).toCamelCase()] = ->
			console.log "fucking fuck"
			@close onCloseAfterOnAction

		buttons =
			back: true
		# resume | start
		buttons[action] = true

		PopupFactory.create popupName, events, buttons

class exports.PopupTimeoutFactory
	@create = (mode) ->
		events =
			onRestart: ->
				@close ->
					app.router.setRoute app.router.getGameStartRoute(mode)
			onResume: ->
				@close ->
					app.router.setRoute app.router.getOptionsRoute()

		buttons =
			restart: true
			resume : true

		PopupFactory.create "timeout", events, buttons

class exports.PopupPauseFactory
	@create = (mode, onCloseOnContinue) ->
		events =
			onRestart: ->
				@close ->
					app.router.setRoute app.router.getGameStartRoute(mode)
			onResume: ->
				@close -> onCloseOnContinue

		buttons =
			restart: true
			resume : true

		PopupFactory.create "pause", events, buttons

class exports.PopupFinishFactory
	@create = (mode) ->
		events =
			onRestart: ->
				@close ->
					app.router.setRoute app.router.getGameStartRoute(mode)
			onResume: ->
				@close ->
					app.router.setRoute app.router.getOptionsRoute()

		buttons =
			restart: true
			resume : true

		PopupFactory.create "finish", events, buttons
