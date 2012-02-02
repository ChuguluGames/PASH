class exports.CountdownHelper
	timer          : null
	frequenceUpdate: 200
	_timeLeft      : 0
	timeLeft       : 0
	startAt        : null
	updatedAt      : null
	pauseAt        : null

	constructor: (timeLeft) ->
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
			@onOver()
		else
			@timer = setTimeout =>
				console.log "update"
				@timeout() if @update() isnt 0 # continue if some time is left
			, updateIn

	resume: ->
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
		@removeTime(diffTimeSinceLastUpdate)

	setTimeLeft: (@timeLeft) ->
		@_timeLeft = @timeLeft

	addTime: (duration) ->
		@timeLeft += duration
		@onUpdate(@timeLeft)
		@timeLeft

	removeTime: (duration) ->
		@timeLeft = Math.max 0, @timeLeft - duration

		@onUpdate(@timeLeft)
		@onOver() if @timeLeft is 0

		@timeLeft

	# delegates
	onUpdate: ->
	onOver: ->

	# statics methods
	@now = ->
		new Date().getTime()