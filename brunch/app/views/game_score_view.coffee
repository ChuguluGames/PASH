class exports.GameScoreView extends View
	template : require "templates/game_score"
	className: "score vcenter"
	elements : {}

	render: ->
		$(@el).html TemplateHelper.generate @template
		@initializeElements()
		@

	initializeElements: ->
		@elements.value = $(".value", @el)
		@elements.events = $(".events", @el)

	update: (data) ->
		@updateScore(data.scoreValue) if data.scoreValue?
		@addScoreEvent(data.timerEvent) if data.timerEvent?

	reset: ->

	updateScore: (score) ->
		@elements.value.html score

	addScoreEvent: (event) ->
		self=@