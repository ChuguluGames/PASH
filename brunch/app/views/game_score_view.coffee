class exports.GameScoreView extends View
	template : require "templates/game_score"
	className: "score"
	elements : {}

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		self

	initializeElements: ->
		self=@
		self.elements.score = $(".button-next-item a", self.el)
		self.elements.timerEvents = $(".button-next-item a", self.el)

	update: (data) ->
		self=@
		self.updateTimerTimeLeft(data.timer) if data.timer?
		self.updateTimerEvents(data.timerEvents) if data.timerEvents?

	reset: ->
