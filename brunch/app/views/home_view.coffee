class exports.HomeView extends View
	id: 'home-view'

	render: ->
		self=@
		$(@el).html require('templates/home')
		@
