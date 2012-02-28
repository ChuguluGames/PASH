class exports.GameScoreView extends View
	template : require "templates/game_score"

	attributes:
		class: 'score vcenter'

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
		@addScoreEvent(data.scoreEvent) if data.scoreEvent? and data.scoreEvent isnt 0

	reset: ->

	updateScore: (score) ->
		@elements.value.html score

	addScoreEvent: (eventValue) ->
		self=@

		eventElement = $("<div />").addClass("event")

		eventElement.html((if eventValue > 0 then "+" else "") + eventValue)

		eventElement.addClass (if eventValue > 0 then "positive" else "negative")

		@elements.events.append eventElement

		eventElement.on "webkitAnimationEnd", ->
			$(@).remove()

		eventElement.addClass "animate"