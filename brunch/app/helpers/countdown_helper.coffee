class exports.CountdownHelper
	timer          : null
	frequenceUpdate: 1000
	_timeLeft      : 0
	timeLeft       : 0
	startAt        : null
	updatedAt      : null
	pauseAt        : null
	delegate 			 : null

	constructor: (timeLeft, @delegate) ->
		@setTimeLeft(timeLeft)

	start: (updateIn) ->
		@reset()
		@startAt = CountdownHelper.now()
		@timeout(updateIn)

	timeout: (updateIn) ->
		@updatedAt = CountdownHelper.now()

		if not updateIn? or updateIn > @frequenceUpdate
			updateIn = if @frequenceUpdate > @timeLeft then @timeLeft else @frequenceUpdate

		if updateIn is 0
			@delegateOnOver()
		else
			@timer = setTimeout =>
				console.log "update"
				@timeout() if @update() isnt 0 # continue if some time is left
			, updateIn

	resume: ->
		return @start() if not startAt?
		diffSinceLastPause = if @pauseAt? then CountdownHelper.now() - @pauseAt else 0
		@start(diffSinceLastPause)

	pause: ->
		@pauseAt = CountdownHelper.now()
		@update()
		@clearTimer()

	stop: ->
		@clearTimer()
		@update()

	clearTimer: ->
		clearTimeout(@timer) if @timer?

	reset: ->
		@timeLeft = @_timeLeft # reset timeLeft initial
		@startAt = null
		@updatedAt = null
		@pauseAt = null

	update: ->
		diffTimeSinceLastUpdate = CountdownHelper.now() - @updatedAt
		@removeTime(diffTimeSinceLastUpdate / 1000)

	setTimeLeft: (timeLeft) ->
		@timeLeft = timeLeft * 1000
		@_timeLeft = @timeLeft

	addTime: (duration) ->
		duration *= 1000
		@timeLeft += duration
		@delegateOnUpdate(Math.round(@timeLeft / 1000))
		@timeLeft

	removeTime: (duration) ->
		@timeLeft = Math.max 0, @timeLeft - duration * 1000
		@delegateOnUpdate(Math.round(@timeLeft / 1000))
		@delegateOnOver() if @timeLeft is 0

		@timeLeft

	# delegates
	delegateOnUpdate: (timeLeft) ->
		@delegate.onTimeUpdate(timeLeft) if @delegate? and @delegate.onTimeUpdate?

	delegateOnOver: ->
		@delegate.onTimeOut() if @delegate? and @delegate.onTimeOut?

	# statics methods
	@now = ->
		new Date().getTime()