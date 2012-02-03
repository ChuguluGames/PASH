
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

	differenceDimensions  : {width: 64, height: 64}
	errorDimensions       : {width: 36, height: 36}
	toleranceAccuracy     : 20
	modes                 : ["zen", "survival", "challenge"]

	loaded                : false
	disabledClicks        : true

	items                 : []
	item                  : null
	itemCurrent           : 0
	itemNext              : false
	itemNextRoute         : false
	itemPrevious          : false
	itemPreviousRoute     : false
	mode                  : null
	score                 : 0
	differencesFoundNumber: 0
	engine 								: null

	initialize: ->
		self=@

		# create the view
		$("body").html self.view.render(
			score: self.score
		).el

		# initiate events
		self.delegateEvents()

		self

	onDestroy: ->
		self=@
		self.view.destroy() # destroy the view
		self.save()
		self.reset()
		self

	save: ->
		self=@

		console.log "saving game"

		# save the engine data to localstorage
		localStorage.setItem('game_' + self.mode, self.engine.toJSON())

	load: (callback, itemsList, forceFetch) ->
		self=@

		if not self.loaded or (forceFetch? and forceFetch)
			if not itemsList? or itemsList.length == 0
				ItemModel.fetchSelected (items) ->
					self.items = items
					self.loaded = true
					callback()

			else
				ItemModel.fetchFromList itemsList, (items) ->
					self.items = items
					self.loaded = true
					callback()

		else callback()
		self

	# start a new game
	start: (mode) ->
		self=@
		self.initializeEngine()
		console.log(self.engine)
		app.router.setRoute app.router.getItemRoute mode, 0

	reset: ->
		self=@

		self.view.reset() # reset visuals
		self.disabledClicks = true # disable clicks
		self.differencesFoundNumber = 0
		self

	# play a game
	play: (mode, itemIndex) ->
		self=@

		self.initializeEngine(mode) if not self.engine?

		self.mode = mode
		self.itemCurrent = parseInt(itemIndex)

		self.reset()

		self.view.showLoading().disableLinks()  # and show loading and add disabled style on links

		self.load ->
			if self.items[self.itemCurrent]?
				self.item = self.items[self.itemCurrent]
			else
				alert "error, no item at " + self.itemCurrent
				return false

			# get prev/next item
			self.getPreviousAndNextItems()

			# load the item
			self.item.fetchAll ->

				self.engine.itemStarted(self.item.differencesArray)
				# prealoding the images
				new app.helpers.preloader().load (images) ->
					# update the view
					self.view.update(
						first_image : images[0]
						second_image: images[1]
						next        : "#" + self.itemNextRoute 	# update the next link
					)
						.hideLoading() # hide the loading indicator
						.enableLinks() # enable links
						.initializeDifferencesFoundIndicator(self.item.differencesArray, self.engine.differenceCount) # initialize difference indicator

					self.disabledClicks = false # enable clicks

				, (error) ->
					alert error
					# load next item
					self.loadNextItem()

				, self.item.first_image.getSrc(), self.item.second_image.getSrc()

	# resume a game
	resume: (mode) ->
		self=@

		console.log "resume"

		# get last game from local storage
		lastGame = localStorage.getItem('game_' + mode)

		if lastGame?
			# load engine from last game lastGame
			self.initializeEngine(lastGame)

			# load the items
			self.load ->

				# find the item index
				for index, item in self.items
					if item.id is lastGame.itemCurrentID
						self.play(mode, index)
						self.showDifferencesAlreadyFound(item.differencesArray) if lastGame.differencesFoundNumber > 0
						break

				self.play(mode, 0) # not found, start from scratch

			, lastGame.items, true

		else self.start(mode)

	showDifferencesAlreadyFound: (differences) ->
		self=@

		for difference in differences
			do (difference) ->
				self.activateDifference(difference) if difference.isFound? and difference.isFound

	validateItemID: (itemCurrent) ->
		self=@
		if not app.helpers.formater.isInt itemCurrent
			console.log "Invalid itemID format"
			return false

		true

	validateMode: (mode) ->
		self=@

		# can't find the mode in the config array
		if $.inArray(mode, self.modes) is -1
			app.helpers.log.error "unknown mode: " + mode, self.tag
			return false

		true

	getPreviousAndNextItems: ->
		self=@
		self.getNextItem()
		self.getPreviousItem()

	getNextItem: ->
		self=@
		# get index
		self.itemNext = if self.itemCurrent + 1 < self.items.length then self.itemCurrent + 1 else -1

		self.itemNextRoute = if self.itemNext isnt -1 then app.router.getItemRoute(self.mode, self.itemNext) else null
		self.itemNext

	getPreviousItem: ->
		self=@
		# get index
		self.itemPrevious = if self.itemCurrent > 0 then self.itemCurrent - 1 else self.itemPrevious = -1
		# get the route
		self.itemPreviousRoute = if self.itemPrevious isnt -1 then app.router.getItemRoute(self.mode, self.itemPrevious) else null
		self.itemPrevious

	loadNextItem: ->
		self=@

		# no more item
		if self.itemNext is no and self.getNextItem() is no # check again just in case
			# else load the end game
		# change the route
		else app.router.setRoute self.itemNextRoute

	onClickLink: (event) ->
		self=@

		if self.disabledClicks
			event.preventDefault()
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

		# show an error if no difference were found
		# if not differenceFound

		return false

	## delegate
	## difference
	didFindDifference: (difference, differenceCount) ->
		@activateDifference difference
		@view.updateDifferencesFoundIndicator(differenceCount) # update the difference indicator

	didNotFindDifference: (spotCircle) ->
		self=@
		errorBounds = app.helpers.polygoner.rectangleFromPoint spotCircle.relativePosition, self.errorDimensions
		self.view.showError errorBounds

	## game over
	didFinishItem: ->
		setTimeout =>
			@loadNextItem()
		, 1000 # temporize the loading of the next item
	## delegate

	activateDifference: (difference, target) ->
		self=@

		console.log difference

		if not target?
			target = self.view.elements.firstImage

		# create the rectangle that wrap the polygon
		rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.differencePointsArray
		rectangle = app.helpers.retina.rectangleRetinaToNonRetina(rectangleRetina)

		# find the center point of the rectangle
		rectangleCenter = app.helpers.polygoner.getRectangleCenter rectangle

		# create the difference
		differenceRectangle = app.helpers.polygoner.rectangleFromPoint rectangleCenter, self.differenceDimensions

		self.view.showDifference(differenceRectangle) # display the difference position
