class exports.HomeView extends View
	id: 			'home-view'
	template: require 'templates/home'

	render: ->
		self=@
		$(self.el).html self.template
		self
