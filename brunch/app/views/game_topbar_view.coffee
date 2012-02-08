class exports.GameTopbarView extends View
	template : require "templates/game_topbar"
	className: "topbar-wrapper"
	elements : {}

	differencesIndicator:
		fadeInSpeed           : 400
		delayBetweenAppearance: 200

	# subviews
	timer: false
	score: false
	next : false
	clues: false

	initialize: (attributes) ->
		self=@

		self.timer = new GameTimerView() if attributes.timer? and attributes.timer
		self.score = new GameScoreView() if attributes.score? and attributes.score
		if attributes.next? and attributes.next
			self.next = true
		else if attributes.clues? and attributes.clues
			self.clues = true

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		$(".toolbar-center", self.el).prepend(self.timer.render().el) if self.timer
		$(".toolbar-center", self.el).prepend(self.score.render().el) if self.score
		$(".toolbar-center", self.el).after(app.helpers.template.generate require "templates/game_topbar_next") if self.next
		$(".toolbar-center", self.el).after(app.helpers.template.generate require "templates/game_topbar_clues") if self.clues

		self.initializeElements()

		self

	initializeElements: ->
		self=@
		self.elements.differencesIndicator = $(".differences-status ul", self.el)
		self.elements.next = $(".button-next-item", self.el) if self.next
		self.elements.clues = $(".button-clues", self.el) if self.clues

	update: (data) ->
		self=@
		self.updateDifferencesIndicator(data.differences) if data.differences?
		self.timer.update(data.timer) if self.timer and data.timer?
		self.score.update(data.score) if self.score and data.score?
		self.updateNext(data.next) if self.next and data.next?
		self

	reset: ->
		self=@
		self.resetDifferencesIndicator()
		self.timer.reset() if self.timer
		self.score.reset() if self.score

	getDifferenceClassName: (difference) ->
		if difference.isFound? and difference.isFound
			return "found"
		if difference.isClued? and difference.isClued
			return "clued"
		null

	initializeDifferenceCounter: (differences) ->
		self=@

		return if not differences?

		indicator = self.elements.differencesIndicator.empty() # empty the counter container

		fadeInLi = (li, delay) ->
			setTimeout ->
				li.fadeIn(self.differencesIndicator.fadeInSpeed)
			, delay

		for difference, index in differences
			li = $("<li />").appendTo(indicator)
			li.addClass(className) if (className = self.getDifferenceClassName difference)?
			fadeInLi(li, index * self.differencesIndicator.delayBetweenAppearance)

	updateDifferenceCounterWithDifferences: (differences) ->
		self=@

		return if not differences?

		for difference, index in differences
			if (className = self.getDifferenceClassName difference)?
				li = $("li:eq(" + index + ")", self.elements.differencesIndicator)
				li.removeClass("found clued")
				li.addClass(className)
		self

	updateDifferenceCounterWithDifference: (difference) ->
		self=@
		if (className = self.getDifferenceClassName difference)?
			$("li:not(.found,.clued):first", self.elements.differencesIndicator).addClass(className)

	resetDifferencesIndicator: ->
		self=@
		self.elements.differencesIndicator.empty()

	updateNext: (nextRoute) ->
		self=@
		$("a", self.elements.next).attr("href", nextRoute)

	disableButtons: ->
		self=@
		$(".button, .button a", self.el).addClass("disabled")
		self

	enableButtons: ->
		self=@
		$(".button, .button a", self.el).removeClass("disabled")
		self