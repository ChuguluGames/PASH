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
				# empty route
				if this.getRoute()[0] == ""
					this.setRoute("home")

).configure({ recurse: 'forward' }) # make the first function bind