class exports.GameController extends Controller
	# -- static --
	GameController.tag = "GameController"
	@indicatorsDimensions =
		found: {width: 64, height: 64}
		error: {width: 36, height: 36}
		clue : {width: 64, height: 64}
	# -- static --

	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image .image-padding, .item .second-image .image-padding": "onClickItem"
		"pause document"                               : "onDevicePause"
		"resume document"                              : "onDeviceResume"

	toleranceAccuracy   : 20
	loaded              : false
	disabledClicks      : true
	selectedItemIDs     : null
	engine              : null

	initialize: ->
		# create the view
		$("body").html @view.render(
			score: 0
		).el

		# initiate events
		@delegateEvents()

		@

	onDestroy: ->
		LogHelper.info "destroying game", GameController.tag

		@view.destroy() # destroy the view
		@save()
		@engine.destroy()
		@engine          = null
		@selectedItemIDs = null
		@reset()
		@

	onDeviceResume: ->
		LogHelper.info "on device resume", GameController.tag

	onDevicePause: ->
		LogHelper.info "on device pause", GameController.tag

		@engine.pause()
		@save()
		app.router.setRoute(app.router.getOptionsRoute())

	toJSON: ->
		json =
			engine          : @engine.toJSON()
			selectedItemIDs : @selectedItemIDs

	fromJSON: (json) ->
		@selectedItemIDs  = json.selectedItemIDs
		# load engine from last game lastGame
		@initializeEngine(json.engine)
		@loaded = true

	save: ->
		LogHelper.info "saving game", GameController.tag

		# save the engine data to localstorage
		if @engine.isGameOver() || @getNextItemIndex() == -1 # if gameover or no more items => remove old data
			localStorage.removeItem('game_' + @engine.mode)
		else # save
			localStorage.setItem('game_' + @engine.mode, JSON.stringify(@toJSON()))

	load: (callback) ->
		if not @loaded and (not itemsList? or itemsList.length == 0)
			ItemModel.fetchSelectedIdentities (itemIdentities) =>
				@selectedItemIDs  = itemIdentities
				@loaded           = true
				callback() if callback?
		else if callback?
			callback()
		@

	# start a new game
	start: ->
		LogHelper.info "start game", GameController.tag
		@load =>
			@initializeEngine()
			app.router.setRoute app.router.getItemRoute @engine.mode, @engine.getCurrentItemIndex()

	reset: ->
		@view.reset() # reset visuals
		@disabledClicks = true # disable clicks
		@

	# play a game
	play: (itemIndex, resumedGame) ->

		# not yet loaded? => need for development
		if not @loaded
			args = arguments
			@load =>
				@play.apply @, args
			return

		@initializeEngine() if not @engine?

		@engine.setCurrentItemIndex itemIndex

		if !(itemIdentity = @selectedItemIDs[@engine.getCurrentItemIndex()])?
			alert "error, no item at " + @engine.getCurrentItemIndex()
			return false

		#@mode = mode
		#@engine.setCurrentItemIndex(parseInt(itemIndex))

		@reset()

		@view.topbar.disableButtons() # add disabled style on links
		@view.item.showLoading()  # show loading

		# load the item
		ItemModel.fetchFullItemForIdentity itemIdentity, !resumedGame, (item) =>

			# preloading the images
			new PreloadHelper().load (images) =>

				# update the view
				@view.update(
					first_image : images[0]
					second_image: images[1]
					next        : "#" + @getNextItemRoute() 	# update the next link
				)
				@view.item.hideLoading() # hide the loading indicator
				@view.topbar.enableButtons() # enable links

				if resumedGame
					@engine.resume()
				else
					@engine.newItem(item.differencesArray)

				@view.topbar.initializeDifferenceCounter(@engine.differences) # initialize difference indicator
				@showDifferenceIndicators(@engine.differences)

				@disabledClicks = false # enable clicks

				# preloading errors
			, (error) ->
				alert error
				# load next item
				@loadNextItem()

			, item.first_image.getSrc(), item.second_image.getSrc()

	# resume a game
	resume: (mode) ->
		LogHelper.info "resume game", GameController.tag

		# get last game from local storage
		lastGame = JSON.parse localStorage.getItem('game_' + mode)

		if lastGame?
			@fromJSON lastGame
			@play(@engine.getCurrentItemIndex(), true)

		else @start()

	showDifferenceIndicators: (differences) ->
		for difference in differences
			if difference.isFound? and difference.isFound
				indicatorType = "found"
			else if difference.isClued? and difference.isClued
				indicatorType = "clue"
			else continue

			@activateDifferenceIndicator indicatorType, difference

	getNextItemRoute: ->
		nextIndex = @getNextItemIndex()
		return null if nextIndex == -1
		app.router.getItemRoute(@engine.mode, nextIndex)

	getPreviousItemRoute: ->
		prevIndex = @getPreviousItemIndex()
		return null if prevIndex == -1
		app.router.getItemRoute(@engine.mode, prevIndex)

	getNextItemIndex: ->
		@engine.getNextItemIndex(@selectedItemIDs.length)

	getPreviousItemIndex: ->
		@engine.getPreviousItemIndex(@selectedItemIDs.length)

	loadNextItem: ->
		nextIndex = @getNextItemIndex()
		# no more item
		if nextIndex == -1
			# else load the end game
		# change the route
		else
			app.router.setRoute @getNextItemRoute()
			@engine.setCurrentItemIndex(nextIndex)

	onClickLink: (event) ->
		if @disabledClicks
			event.preventDefault()
			return false

		if $(event.target).hasClass("action-showClue")
			@engine.useClue()
			return false

		super

	# when the user click on the first image or the second
	onClickItem: (event) ->
		if @disabledClicks
			event.preventDefault()
			return false

		position=
			x: event.pageX
			y: event.pageY

		# make the position relative to the item
		relativePosition = PositionHelper.getRelativePosition event.currentTarget, position

		# make the position adapt the used scale
		scaledPosition = ScaleHelper.scalePositionTo relativePosition, 2 / DynamicScreenHelper.itemScale

		differenceFound = false

		# create a circle from the position and the given tolerance accuracy
		circle =
			relativePosition: relativePosition # needed for activateDifferenceIndicator difference center
			center          : scaledPosition
			radius          : @toleranceAccuracy # do we need to adapt the tolerance wth the scale?

		@engine.findDifference(circle)

		return false

	## delegate

	## difference
	didFindDifference: (difference, differenceCount) ->
		@activateDifferenceIndicator "found", difference
		@view.topbar.updateDifferenceCounterWithDifference difference

	didNotFindDifference: (spotCircle) ->
		@activateDifferenceIndicator "error", spotCircle.relativePosition

	## clues
	didUseClue: (difference, clueCount, differenceCount) ->
		@activateDifferenceIndicator "clue", difference
		@view.topbar.updateDifferenceCounterWithDifference difference

	## game over
	didFinishItem: ->
		setTimeout =>
			@loadNextItem()
		, 1000 # temporize the loading of the next item

	## delegate

	activateDifferenceIndicator: (type, difference, target) ->
		if type is "error"
			errorBounds = PolygonHelper.rectangleFromPoint difference, GameController.indicatorsDimensions.error
			@view.item.showIndicator "error", errorBounds
			return @

		if not target?
			target = @view.item.elements.firstImage

		# create the rectangle that wrap the polygon
		unscaledRectangle = PolygonHelper.polygonToRectangle difference.differencePointsArray

		# find the center point of the rectangle
		unscaledRectangleCenter = PolygonHelper.getRectangleCenter unscaledRectangle

		# scale the rectangle center
		scaledRectangleCenter = ScaleHelper.scalePositionTo unscaledRectangleCenter, 1 / (2 / DynamicScreenHelper.itemScale)

		# create the difference
		differenceRectangle = PolygonHelper.rectangleFromPoint scaledRectangleCenter, GameController.indicatorsDimensions[type]

		@view.item.showIndicator type, differenceRectangle # display the difference position

		@
