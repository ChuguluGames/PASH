
	# 	# devices events
	# 	"pause document": "onDevicePause"
	# 	"resume document": "onDeviceResume"

	# onDeviceResume: ->
	# 	console.log "onDeviceResume"

	# onDevicePause: ->
	# 	console.log "onDevicePause"

		# timer = new app.helpers.countdown(3000)

		# timer.onUpdate = (timeLeft) ->
		# 	console.log "time left: " + timeLeft

		# timer.onOver = ->
		# 	console.log "countdown over"

		# timer.start()

		# setTimeout ->
		# 	console.log "timer pause"
		# 	timer.pause()

		# 	setTimeout ->
		# 		console.log "timer resume"
		# 		timer.resume()

		# 		setTimeout ->
		# 			console.log "timer stop"
		# 			timer.stop()

		# 			timer.start()

		# 		, 320

		# 	, 500

		# , 788

class exports.GameController extends Controller
	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image, .item .second-image": "onClickItem"
		"pause document"                               : "onDevicePause"
		"resume document"                              : "onDeviceResume"

	indicatorsDimensions:
		found: {width: 64, height: 64}
		error: {width: 36, height: 36}
		clue : {width: 64, height: 64}

	differenceDimensions: {width: 64, height: 64}
	errorDimensions     : {width: 36, height: 36}
	toleranceAccuracy   : 20
	loaded              : false
	disabledClicks      : true
	selectedItemIDs     : null
	engine              : null

	initialize: ->
		self=@

		# create the view
		$("body").html self.view.render(
			score: 0
		).el

		# initiate events
		self.delegateEvents()

		self

	onDestroy: ->
		console.log "destroying game"
		self=@
		self.view.destroy() # destroy the view
		self.save()
		self.engine.destroy()
		self.engine          = null
		self.selectedItemIDs = null
		self.reset()
		self

	onDeviceResume: ->
		console.log "onDeviceResume"

	onDevicePause: ->
		console.log "onDevicePause"
		@engine.pause()
		@save()
		app.router.setRoute(app.router.getOptionsRoute())

	toJSON: ->
		json =
			engine          : @engine.toJSON()
			selectedItemIDs : @selectedItemIDs

	fromJSON: (json) ->
		self=@
		self.selectedItemIDs  = json.selectedItemIDs
		# load engine from last game lastGame
		self.initializeEngine(json.engine)
		self.loaded = true

	save: ->
		self=@
		console.log "saving game"
		# save the engine data to localstorage
		if self.engine.isGameOver() || self.getNextItemIndex() == -1 # if gameover or no more items => remove old data
			localStorage.removeItem('game_' + self.engine.mode)
		else # save
			localStorage.setItem('game_' + self.engine.mode, JSON.stringify(self.toJSON()))

	load: (callback) ->
		self=@

		if not self.loaded and (not itemsList? or itemsList.length == 0)
			ItemModel.fetchSelectedIdentities (itemIdentities) ->
				self.selectedItemIDs  = itemIdentities
				self.loaded           = true
				callback() if callback?
		else if callback?
			callback()
		self

	# start a new game
	start: ->
		self=@
		self.load ->
			self.initializeEngine()
			app.router.setRoute app.router.getItemRoute self.engine.mode, self.engine.getCurrentItemIndex()

	reset: ->
		self=@
		self.view.reset() # reset visuals
		self.disabledClicks = true # disable clicks
		self

	# play a game
	play: (itemIndex, resumedGame) ->
		self=@

		if !(itemIdentity = self.selectedItemIDs[self.engine.getCurrentItemIndex()])?
			alert "error, no item at " + self.engine.getCurrentItemIndex()
			return false

		self.initializeEngine() if not self.engine?

		#self.mode = mode
		#self.engine.setCurrentItemIndex(parseInt(itemIndex))

		self.reset()

		self.view.topbar.disableButtons() # add disabled style on links
		self.view.item.showLoading()  # show loading

		# load the item
		ItemModel.fetchFullItemForIdentity itemIdentity, (item) ->
			# prealoding the images
			new app.helpers.preloader().load (images) ->
				# update the view
				self.view.update(
					first_image : images[0]
					second_image: images[1]
					next        : "#" + self.getNextItemRoute() 	# update the next link
				)
				self.view.item.hideLoading() # hide the loading indicator
				self.view.topbar.enableButtons() # enable links

				if resumedGame
					self.engine.resume()
				else
					self.engine.newItem(item.differencesArray)

				self.view.topbar.initializeDifferenceCounter(self.engine.differences) # initialize difference indicator
				self.showDifferenceIndicators(self.engine.differences)

				self.disabledClicks = false # enable clicks
			, (error) ->
				alert error
				# load next item
				self.loadNextItem()

			, item.first_image.getSrc(), item.second_image.getSrc()

	# resume a game
	resume: (mode) ->
		self=@

		console.log "resume"

		# get last game from local storage
		lastGame = JSON.parse localStorage.getItem('game_' + mode)

		if lastGame?
			self.fromJSON lastGame
			self.play(self.engine.getCurrentItemIndex(), true)

		else self.start()

	showDifferenceIndicators: (differences) ->
		self=@

		for difference in differences
			if difference.isFound? and difference.isFound
				indicatorType = "found"
			else if difference.isClued? and difference.isClued
				indicatorType = "clue"
			else continue

			self.activateDifferenceIndicator indicatorType, difference

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
		self=@

		nextIndex = self.getNextItemIndex()
		# no more item
		if nextIndex == -1
			# else load the end game
		# change the route
		else
			app.router.setRoute self.getNextItemRoute()
			self.engine.setCurrentItemIndex(nextIndex)

	onClickLink: (event) ->
		self=@

		if self.disabledClicks
			event.preventDefault()
			return false

		if $(event.target).hasClass("action-showClue")
			self.engine.useClue()
			return false

		super

	# when the user click on the first image or the second
	onClickItem: (event) ->
		self=@

		if self.disabledClicks
			event.preventDefault()
			return false

		position=
			x: event.pageX
			y: event.pageY

		# make the position relative to the item
		relativePosition = app.helpers.positioner.getRelativePosition event.currentTarget, position

		# make the position adapt to the retina
		retinaPosition = app.helpers.retina.positionToRetina(relativePosition)
		differenceFound = false

		# create a circle from the position and the given tolerance accuracy
		circle =
			relativePosition: relativePosition
			center          : retinaPosition
			radius          : self.toleranceAccuracy

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
		self=@

		if type is "error"
			errorBounds = app.helpers.polygoner.rectangleFromPoint difference, self.indicatorsDimensions.error
			self.view.item.showIndicator "error", errorBounds
			return self

		if not target?
			target = self.view.item.elements.firstImage

		# create the rectangle that wrap the polygon
		rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.differencePointsArray
		rectangle = app.helpers.retina.rectangleRetinaToNonRetina(rectangleRetina)

		# find the center point of the rectangle
		rectangleCenter = app.helpers.polygoner.getRectangleCenter rectangle

		# create the difference
		differenceRectangle = app.helpers.polygoner.rectangleFromPoint rectangleCenter, self.indicatorsDimensions[type]

		self.view.item.showIndicator type, differenceRectangle # display the difference position

		self
