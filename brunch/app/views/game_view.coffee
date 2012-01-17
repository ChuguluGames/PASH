class exports.GameView extends View
	id: 			'game-view'
	template: require 'templates/game'

	render: (item) ->
		self=@

		$(self.el).html self.template item: item
		self