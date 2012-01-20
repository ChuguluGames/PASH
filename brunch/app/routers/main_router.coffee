exports.MainRouter = new Router(
	routes:
		"/":
			"/home": ->
				app.log.info "caca ", @tag
				app.views.home       = new HomeView()
				app.controllers.home = new HomeController(view: app.views.home)
				app.controllers.home.show()

			"/game":
				on: (item, mode) ->
					app.views.game = new GameView()
					app.controllers.game = new GameController(view: app.views.game)
					app.controllers.game.loadItem item, mode

				"/:item":
					on: ->
					"/mode":
						on: ->
						"/:mode":
							on: ->
			on: ->
				route = this.getRoute()

				# empty route
				app.log.info "on route: " + route, @tag

).configure({ recurse: 'forward' }) # make the first function bind

exports.MainRouter.tag = "MainRouter"