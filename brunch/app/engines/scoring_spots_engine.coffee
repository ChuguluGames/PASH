class exports.ScoringSpotsEngine extends SpotsEngine
	score            : 0
	time             : 0
	timeSinceLastSpot: 0
	timer            : null
	errorCount       : 0
	comboCount       : 0

	constructor: (@mode, @delegate, json) ->
		@excludedProps.push 'timer'
		@timer = new app.helpers.countdown @time, @
		super
		if json?
			@delegateTimeDidChange()
			@delegateScoreDidChange()

	# reset counters while keeping the same game mode (ex: restart the game in the same mode)
	reset: ->
		super
		@time              = 0
		@score             = 0
		@comboCount        = 0
		@errorCount        = 0
		@timeSinceLastSpot = 0

	onTimeUpdate: (timeLeft) ->
		#@time-- if @time > 0
		@time = timeLeft
		@delegateTimeDidChange()
		@timeSinceLastSpot++ if @errorCount < 1

	onTimeOut: ->
		@delegateTimeOut()

	# unschedule timers
	pause: ->
		@timer.pause() if @timer?

	# reschedule timers
	resume: ->
		@timer.resume() if @timer?

	useClue: ->
		@timeSinceLastSpot = 0
		@comboCount        = 0
		super

	didFindDifference: (difference) ->
		@errorCount = 0
		super

	didNotFindDifference: (spotCircle) ->
		@errorCount++
		@comboCount        = 0
		@timeSinceLastSpot = 0
		super

	itemStarted: (differences) ->
		@comboCount        = 0
		@errorCount        = 0
		@timeSinceLastSpot = 0
		super

	# delegate
	## time
	delegateTimeDidChange: ->
		@delegate.timeDidChange @time if @delegate? and @delegate.timeDidChange?

	delegateTimeBonus: (bonus) ->
		@delegate.timeBonus(bonus, @time) if @delegate? and @delegate.timeBonus?

	delegateTimePenalty: (penalty) ->
		@delegate.timePenalty(penalty, @time) if @delegate? and @delegate.timePenalty?

	delegateTimeOut: ->
		@delegate.timeOut() if @delegate? and @delegate.timeOut?

	## score
	delegateScoreDidChange: ->
		@delegate.scoreDidChange @score if @delegate? and @delegate.scoreDidChange?

	delegateScoreBonus: (bonus) ->
		@delegate.scoreBonus(bonus, @score) if @delegate? and @delegate.scoreBonus?

	delegateScorePenalty: (penalty) ->
		@delegate.scorePenalty(penalty, @score) if @delegate? and @delegate.scorePenalty?

	fromJSON: (json) ->
		super
		@timer.setTimeLeft @time
