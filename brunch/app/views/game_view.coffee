class exports.GameView extends View
	id      : 'game-view'
	elements: {}
	className: 'vcenter'

	# default configuration
	configuration:
		score: false
		timer: false
		next : false
		clues: false

	# subviews
	topbar: null
	item  : null

	initialize: ->
		@topbar = new GameTopbarView(@configuration)
		@item   = new GameItemView()

	render: (data) ->
		$(@el).append @topbar.render().el
		$(@el).append @item.render().el

		@update data
		@

	update: (data) ->
		@topbar.update(data)
		@item.update(data)
		@

	reset: ->
		@topbar.reset()
		@item.reset()
		@