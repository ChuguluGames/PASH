class exports.GameView extends View
	id: 			'game-view'
	template: require 'templates/game'

	render: (data) ->
		self=@

		$(self.el).html self.template
			item: 			data.item
			next: 			data.nextItem
			mode: 			data.mode
			score: 			data.score
		self

	hideLoading: ->
		self=@
		$(".item-loading", self.el).hide()

	showLoading: ->
		self=@
		$(".item-loading", self.el).show()