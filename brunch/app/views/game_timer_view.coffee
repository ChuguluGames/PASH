class exports.GameTimerView extends View
	template : require "templates/game_timer"
	className: "timer"
	elements : {}

	render: ->
		$(@el).html TemplateHelper.generate @template
		@initializeElements()
		@

	initializeElements: ->
		@elements.value = $(".value", @el)
		@elements.events = $(".events", @el)

	update: (data) ->
		@updateTimeLeft(data.timeLeft) if data.timeLeft?
		@addTimeEvent(data.timeEvent) if data.timeEvent?

	updateTimeLeft: (timeLeft) ->
		@elements.value.html timeLeft

	addTimeEvent: (event) ->
		self=@
		# @elements.events.append timeLeftDifference

	reset: ->

