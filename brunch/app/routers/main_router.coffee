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
					console.log "empty route"
					this.setRoute "home"
				else
					console.log "on route: " + route

).configure({ recurse: 'forward' }) # make the first function bind