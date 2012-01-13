class exports.MainRouter extends Backbone.Router
	routes:
		":page": "dispatch"

	dispatch: (page) ->
		if app.views[page]?
			$('body').html app.views[page].render().el
		else
			this.navigate "home", true