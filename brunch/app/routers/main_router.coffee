exports.MainRouter = new Router(
	routes:
		"/":
			"/home": ->
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
				if route[0] == ""
					app.log.info "empty route", @tag
					this.setRoute "home"
				else
					app.log.info "on route: " + route, @tag

).configure({ recurse: 'forward' }) # make the first function bind

exports.MainRouter.tag = "MainRouter"