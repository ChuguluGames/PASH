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
		@timer = new GameTimerView() if attributes.timer? and attributes.timer
		@score = new GameScoreView() if attributes.score? and attributes.score
		if attributes.next? and attributes.next
			@next = true
		else if attributes.clues? and attributes.clues
			@clues = true

	render: ->
		$(@el).html TemplateHelper.generate @template

		toolbarCenterWrapper = $(".topbar-center-wrapper", @el)
		$(".topbar-center .timer-container", @el).html(@timer.render().el) if @timer
		$(".topbar-center .score-container", @el).html(@score.render().el) if @score
		toolbarCenterWrapper.after(TemplateHelper.generate require "templates/game_topbar_next") if @next
		toolbarCenterWrapper.after(TemplateHelper.generate require "templates/game_topbar_clues") if @clues

		@initializeElements()
		@

	initializeElements: ->
		@elements.differencesIndicator = $(".indicators ul", @el)
		@elements.next = $(".button-next-item", @el) if @next
		@elements.clues = $(".button-clues", @el) if @clues

	update: (data) ->
		@updateDifferencesIndicator(data.differences) if data.differences?
		@timer.update(data.timer) if @timer and data.timer?
		@score.update(data.score) if @score and data.score?
		@updateNext(data.next) if @next and data.next?
		@

	reset: ->
		@resetDifferencesIndicator()
		@timer.reset() if @timer
		@score.reset() if @score

	getDifferenceClassName: (difference) ->
		if difference.isFound? and difference.isFound
			return "found"
		if difference.isClued? and difference.isClued
			return "clued"
		null

	initializeDifferenceCounter: (differences) ->
		return if not differences?

		indicator = @elements.differencesIndicator.empty() # empty the counter container

		fadeInLi = (li, delay) =>
			# TODO: create a callback function (faster than creating x anonymous function)
			setTimeout =>
				li.fadeIn(@differencesIndicator.fadeInSpeed)
			, delay

		for difference, index in differences
			li = $("<li />").appendTo(indicator)
			li.addClass(className) if (className = @getDifferenceClassName difference)?
			fadeInLi(li, index * @differencesIndicator.delayBetweenAppearance)

	updateDifferenceCounterWithDifferences: (differences) ->
		return if not differences?

		for difference, index in differences
			if (className = @getDifferenceClassName difference)?
				li = $("li:eq(" + index + ")", @elements.differencesIndicator)
				li.removeClass("found clued")
				li.addClass(className)
		@

	updateDifferenceCounterWithDifference: (difference) ->
		if (className = @getDifferenceClassName difference)?
			$("li:not(.found,.clued):first", @elements.differencesIndicator).addClass(className)

	resetDifferencesIndicator: ->
		@elements.differencesIndicator.empty()

	updateNext: (nextRoute) ->
		$("a", @elements.next).attr("href", nextRoute)

	disableButtons: ->
		$(".button, .button a", @el).addClass("disabled")
		@

	enableButtons: ->
		$(".button, .button a", @el).removeClass("disabled")
		@