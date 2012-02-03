class exports.GameTimerView extends View
	className   : "timer"
	elements: {}

	render: ->
		self=@
		self

	initializeElements: ->
		self=@
		self.elements.timer = $(".button-next-item a", self.el)
		self.elements.timerEvents = $(".button-next-item a", self.el)

	update: (data) ->
		self=@

		self.updateTimerTimeLeft(data.timer) if data.timer?
		self.updateTimerEvents(data.timerEvents) if data.timerEvents?

	updateTimeLeft: (timeLeft) ->
		self=@
		self.elements.timer.html timeLeft

	updateEvents: (timeLeftDifference) ->
		self=@
		self.elements.timerEvents.append timeLeftDifference

	reset: ->

