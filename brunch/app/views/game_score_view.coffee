class exports.GameScoreView extends View
	template : require "templates/game_score"
	className: "score"
	elements : {}

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		self.initializeElements()
		self

	initializeElements: ->
		self=@
		self.elements.value = $(".score-value div", self.el)
		self.elements.events = $(".score-events", self.el)

	update: (data) ->
		self=@
		self.updateScore(data.scoreValue) if data.scoreValue?
		self.addScoreEvent(data.timerEvent) if data.timerEvent?

	reset: ->

	updateScore: (score) ->
		self=@
		self.elements.value.html score

	addScoreEvent: (event) ->
		self=@