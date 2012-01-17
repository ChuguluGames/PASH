exports.MainRouter = new Router
	routes:
		"": 						-> app.controllers.home.show(arguments)
		"/home": 				-> app.controllers.home.show(arguments)
		"/game": 				-> app.controllers.game.loadItem(arguments)
		"/game/:item": 	-> app.controllers.game.loadItem(arguments)

