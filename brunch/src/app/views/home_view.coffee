homeTemplate = require('templates/home')

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate(variable:"name")
		@