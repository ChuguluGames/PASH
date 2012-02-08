class exports.GameTimerView extends View
	template : require "templates/game_timer"
	className: "timer"
	elements : {}

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		self.initializeElements()
		self

	initializeElements: ->
		self=@
		self.elements.value = $(".value", self.el)
		self.elements.events = $(".events", self.el)

	update: (data) ->
		self=@

		self.updateTimeLeft(data.timeLeft) if data.timeLeft?
		self.addTimeEvent(data.timeEvent) if data.timeEvent?

	updateTimeLeft: (timeLeft) ->
		self=@
		self.elements.value.html timeLeft

	addTimeEvent: (event) ->
		self=@
		# self.elements.events.append timeLeftDifference

	reset: ->

