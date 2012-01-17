exports.MainRouter = new Router
	routes:
		["/home", ""]: -> app.controllers.home.show(arguments)
		["/game", "/game/:item", "/game/:item/"]: (item) -> app.controllers.game.loadItem(item)

