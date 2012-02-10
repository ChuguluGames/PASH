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
		@addTimeEvent(data.timeEvent) if data.timeEvent?  and data.timeEvent isnt 0

	updateTimeLeft: (timeLeft) ->
		@elements.value.html timeLeft

	addTimeEvent: (eventValue) ->
		self=@

		eventElement = $("<div />").addClass("event")
		eventElement.html((if eventValue > 0 then "+" else "") + eventValue)
		eventElement.addClass (if eventValue > 0 then "positive" else "negative")
		@elements.events.append eventElement

		eventElement.on "webkitAnimationEnd", ->
			$(@).remove()
		eventElement.addClass "animate"


	reset: ->