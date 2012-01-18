exports.MainRouter = new Router(
	routes:
		"/":
			"/home": -> app.controllers.home.show()

			"/game":
				on: (item, mode) -> app.controllers.game.loadItem item, mode
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