class exports.GameView extends View
	id: 'game-view'

	render: ->
		self=@
		$(@el).html require('templates/game')
		@