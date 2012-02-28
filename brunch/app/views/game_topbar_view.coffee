class exports.GameTopbarView extends View
	template : require "templates/game_topbar"
	attributes:
		class: "topbar-wrapper"
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

		if @clues
			@elements.clues = $(".button-clues a", @el)
			@elements.cluesCount = $("span", @elements.clues)

	update: (data) ->
		@updateDifferencesIndicator(data.differences) if data.differences?
		@timer.update(data.timer) if @timer and data.timer?
		@score.update(data.score) if @score and data.score?
		@updateNext(data.next) if @next and data.next?
		@updateCluesCount(data.cluesCount) if @cluesCount and data.cluesCount?
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
			setTimeout =>
				li.addClass 'fadein'
			, delay

		for difference, index in differences
			li = $("<li />").appendTo(indicator)
			li.addClass(className) if (className = @getDifferenceClassName difference)?

			if DeviceHelper.canPerformAnimation()
				fadeInLi li, index * @differencesIndicator.delayBetweenAppearance
			else li.css 'opacity', '1'

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

	updateCluesCount: (cluesCount) ->
		@elements.clues[(if cluesCount is 0 then "addClass" else "removeClass")]("disabled")
		@elements.cluesCount.html("X" + cluesCount)

	disableButtons: ->
		$(".button, .button a", @el).addClass("disabled")
		@

	enableButtons: ->
		$(".button, .button a", @el).removeClass("disabled")
		@