exports.MainRouter = new Router(
	routes:
			"/home":
				on: ->
					console.log "in home"
					app.controllers.game.rendered = false if app.controllers.game?

					app.views.home       = new HomeView()
					app.controllers.home = new HomeController(view: app.views.home)
					app.controllers.home.show()

			"/game":
				on: (item, mode) ->
					console.log "in game"
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