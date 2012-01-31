Router::firstRoute = true
Router::onFirstRoute = ->

Router::getRoutes = ->
	return {
		game: @getGameRoute()
		home: @getHomeRoute()
	}

Router::getBaseRoute = ->
	"/" + app.helpers.locale.getLocale()

Router::getGameRoute = ->
	return @getBaseRoute() + "/game"

Router::getItemRoute = (item, mode) ->
	return @getBaseRoute() + "/game/" + item + "/mode/" + mode

Router::getHomeRoute = ->
	return @getBaseRoute() + "/home"

exports.MainRouter = new Router(
	routes:
		"/:locale":
			on: (locale) ->
				app.helpers.locale.setLocale locale
			"/home":
				on: ->
					console.log "in home"
					app.controllers.game.rendered = false if app.controllers.game?

					app.views.home       = new HomeView()
					app.controllers.home = new HomeController(view: app.views.home)
					app.controllers.home.show()
					if @firstRoute
						@firstRoute = false
						@onFirstRoute()

			"/game":
				on: (locale, item, mode) ->
					# no current game
					if not app.controllers.game? or not app.controllers.game.loaded
						app.views.game = new GameView()
						app.controllers.game = new GameController(view: app.views.game).start(item, mode)
					# guess it's a resume
					else if not item?
						app.controllers.game.resume()
					# load from the arguments
					else app.controllers.game.loadItem(item, mode)

				"/:item":
					on: ->
					"/mode":
						on: ->
						"/:mode":
							on: ->

).configure({ recurse: 'forward' }) # make the first function bind

exports.MainRouter.tag = "MainRouter"