Router::currentController = null
Router::firstRoute = true

Router::onFirstRoute = ->

Router::getRoutes = ->
	modeRoutes =
		start : {}
		resume: {}
	modes = ConfigHelper.getSpotsModes()
	for key,mode of modes
		modeRoutes.start[mode]  = @getGameStartRoute(mode)
		modeRoutes.resume[mode] = @getGameResumeRoute(mode)
	return {
		game   : modeRoutes
		home   : @getHomeRoute()
		options: @getOptionsRoute()
	}

Router::getBaseRoute = ->
	"/" + LocaleHelper.getLocale()

Router::getGameRoute = ->
	return @getBaseRoute() + "/game"

Router::getItemRoute = (mode, item ) ->
	return @getGameRoute() + "/mode/" + mode + "/item/" + item

Router::getHomeRoute = ->
	return @getBaseRoute() + "/home"

Router::getOptionsRoute = ->
	return @getBaseRoute() + "/options"

Router::getGameStartRoute = (mode) ->
	@getGameRoute() + '/start/' + mode

Router::getGameResumeRoute = (mode) ->
	@getGameRoute() + '/resume/' + mode

Router::changeController = (controllerClass, viewClass, onCreate, onResume) ->
	# same controller
	if onResume? and @currentController? and @currentController.constructor is controllerClass
		onResume.apply(@currentController)

	# new controller
	else
		# remove last controller
		if @currentController?
			@currentController.destroy()
			@currentController = null

		# create the new one
		newController = new controllerClass(view: new viewClass)
		newController.initialize()
		onCreate.apply(newController)

		@currentController = newController

Router::getGameClassesName = (mode) ->
	return {
		controller: window[(mode + "_game_controller").toPascalCase()]
		view      : window[(mode + "_game_view").toPascalCase()]
	}

Router::refresh = ->
	@dispatch 'on', @getCurrentRoute()

# keep the old prototype
superSetRoute = Router::setRoute
Router::setRoute = (route) ->
	# same route, force binding
	if @getCurrentRoute() is route
		@refresh()
	else
		superSetRoute.apply @, arguments

Router::getCurrentRoute = ->
	"/" + @getRoute().join "/"

exports.MainRouter = new Router(
	routes:
		"":
			on: ->
				if @firstRoute
					@firstRoute = false
					@onFirstRoute()

		"/:locale":

			on: (locale) ->
				LocaleHelper.setLocale locale
			"/home":
				on: ->
					@changeController HomeController, HomeView, -> @show()

			"/options":
				on: ->
					console.log "in options"

					@changeController OptionsController, OptionsView, -> @show()

			"/game/start/:mode":
				on: (locale, mode) ->
					classesName = @getGameClassesName(mode)

					@changeController classesName.controller, classesName.view, ->
						@start()
					, ->
						@reset().start()

			"/game/resume/:mode":
				on: (locale, mode) ->
					classesName = @getGameClassesName(mode)

					@changeController classesName.controller, classesName.view, ->
						@resume(mode)
					, ->
						@reset().resume(mode)

			"/game/mode/:mode/item/:item":
				on: (locale, mode, itemIndex) ->
					classesName = @getGameClassesName(mode)

					@changeController classesName.controller, classesName.view, ->
						@play(itemIndex)
					, ->
						@reset().play(itemIndex)

).configure({ recurse: 'forward' }) # make the first function bind

exports.MainRouter.tag = "MainRouter"