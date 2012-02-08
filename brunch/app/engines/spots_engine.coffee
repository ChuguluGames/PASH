class exports.SpotsEngine
	differenceCount : 0
	clueCount       : 0
	differences     : null
	mode            : null
	delegate        : null
	currentItemIndex: 0
	gameOver        : false
	config          : {}
	excludedProps   : ['mode', 'delegate', 'excludedProps', 'config', 'differences', 'gameOver']

	constructor: (@mode, @delegate, json) ->
		@reloadConfigForCurrentMode()
		if json?
			@fromJSON(json)
		else
			@reset()

	reloadConfigForCurrentMode: ->
		@config = require('config/spots_engine_config').config[@mode]

	destroy: ->
		config        = null
		excludedProps = null
		differences   = null
		mode          = null
		delegate      = null

	# reset counters while keeping the same game mode (ex: restart the game in the same mode)
	reset: ->
		@clueCount         = 0
		@differences       = null
		@differenceCount   = 0

	pause: ->

	resume: ->

	# differences
	useClue: ->
		if @clueCount > 0 and @differenceCount > 0
			@clueCount--
			@differenceCount--
			for difference in @differences # get the first unfound difference
				if not difference.isFound and not difference.isClued
					difference.isClued = true
					@delegateDidUseClue(difference)
					@itemFinished() if @differenceCount < 1
					break

	findDifference: (spotCircle) ->
		for difference in @differences
			if not difference.isFound and not difference.isClued
				if app.helpers.collision.circleCollisionToPolygon(spotCircle, difference.differencePointsArray)
					return @didFindDifference(difference)
		@didNotFindDifference(spotCircle)

	didFindDifference: (difference) ->
		difference.isFound = true
		@delegateDidFindDifference(difference)
		@differenceCount-- if @differenceCount > 0
		@itemFinished() if @differenceCount < 1

	didNotFindDifference: (spotCircle) ->
		@delegateDidNotFindDifference(spotCircle)

	# item
	newItem: (differences) ->
		@clueCount         = 0
		for difference in differences
			difference.isFound = false
			difference.isClued = false
		@differences       = differences
		@differenceCount   = differences.length

	itemFinished: ->
		@delegateDidFinishItem()

	isGameOver: ->
		@gameOver

	endGame: ->
		@gameOver = true

	# delegate
	## difference
	delegateDidFindDifference: (difference) ->
		@delegate.didFindDifference(difference, @differenceCount) if @delegate? and @delegate.didFindDifference?

	delegateDidNotFindDifference: (spotCircle) ->
		@delegate.didNotFindDifference(spotCircle) if @delegate? and @delegate.didNotFindDifference?

	## clues
	delegateDidUseClue: (difference) ->
		@delegate.didUseClue(difference, @clueCount, @differenceCount) if @delegate? and @delegate.didUseClue?

	## game over
	delegateDidFinishItem: ->
		@delegate.didFinishItem() if @delegate? and @delegate.didFinishItem?

	# item navigation: by default loop through the items
	## indexes
	setCurrentItemIndex: (newIndex) ->
		newIndex = parseInt(newIndex)
		newIndex = 0 if isNaN(newIndex)
		@currentItemIndex = newIndex

	getCurrentItemIndex: ->
		@currentItemIndex

	getNextItemIndex: (itemCount) ->
		(@getCurrentItemIndex() + 1) % itemCount

	getPreviousItemIndex: (itemCount) ->
		(@getCurrentItemIndex() + itemCount - 1) + itemCount

#	## identities
#	getCurrentItemIdentity: ->
#		@itemIdentities[@getCurrentItemIndex()]
#
#	getNextItemIdentity: ->
#		nextIndex = @getNextItemIndex()
#		return null if nextIndex == -1
#		@itemIdentities[nextIndex]
#
#	getPreviousItemIdentity: ->
#		prevIndex = @getPreviousItemIndex()
#		return null if prevIndex == -1
#		@itemIdentities[prevIndex]

	# json
	fromJSON: (json) ->
		for prop, val of json
			@[prop] = val if $.inArray(prop, @excludedProps) == -1
		@differences    = json.differences if json.differences?

	toJSON: ->
		filteredObject                = SpotsEngine.filterObject(@)
		filteredObject.differences    = @differences
		filteredObject

	# static helper methods
	## config helper
	@getClosestObjectInConfig = (config, someValue) ->
		closestObject = null
		difference = -1

		for value, object of config
			if value <= someValue or difference < 0
				tmpDifference = someValue - value
				if tmpDifference < difference or difference < 0
					difference    = tmpDifference
					closestObject = object
		closestObject

	## filter helper
	@filterObject = (object, excludedProps) ->
		excludedProps = object.excludedProps if !excludedProps? and object.excludedProps?
		filtered      = {}
		for prop, val of object
			if $.inArray(prop, excludedProps) == -1
				if typeof val is 'object'# Entity (persistencejs)
					if val.toJSON?
						filtered[prop] = val.toJSON()
					else
						filtered[prop] = SpotsEngine.filterObject(val)
				else if typeof val isnt 'function'
					filtered[prop] = val
		filtered
