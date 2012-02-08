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
		self=@
		self.topbar = new GameTopbarView(self.configuration)
		self.item   = new GameItemView()

	render: (data) ->
		self=@

		$(self.el).append self.topbar.render().el
		$(self.el).append self.item.render().el

		self.update data

		self

	update: (data) ->
		self=@
		self.topbar.update(data)
		self.item.update(data)
		self

	reset: ->
		self=@
		self.topbar.reset()
		self.item.reset()
		self