class exports.GameController extends Controller
	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image, .item .second-image": "onClickItem"

	differenceDimensions  : {width: 64, height: 64}
	errorDimensions       : {width: 36, height: 36}
	toleranceAccuracy     : 20
	modes                 : ["practice", "survival", "challenge"]

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
		# save the engine data to localstorage
		# localStorage.setItem('game_' + self.mode, self.engine.toJSON)

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

		self.mode = mode
		self.itemCurrent = parseInt(itemIndex)

		console.log self.view
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

				# order each differences polygon points
				for difference in self.item.differencesArray
					app.helpers.polygoner.orderPoints(difference.differencePointsArray)

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
						.initializeDifferencesFoundIndicator(self.item.differencesArray, self.differencesFoundNumber) # initialize difference indicator

					self.disabledClicks = false # enable clicks

				, (error) ->
					alert error
					# load next item
					self.loadNextItem()

				, self.item.first_image.getSrc(), self.item.second_image.getSrc()

	# resume a game
	resume: (mode) ->
		self=@

		# get last game from local storage
		lastGame = localStorage.getItem('game_' + mode)

		# load engine from last game lastGame

		self.load ->

			# find the item index
			for index, item in self.items
				if item.id is lastGame.itemCurrentID
					self.play(mode, index)
					self.showDifferencesAlreadyFound(item.differencesArray) if lastGame.differencesFoundNumber > 0
					break

			self.play(mode, 0) # not found, start from scratch

		, lastGame.items, true

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
		if self.itemCurrent + 1 < self.items.length
			self.itemNext = self.itemCurrent + 1
		else if self.mode is "practice"
			self.itemNext = 0
		else self.itemNext = false

		# get the route
		self.itemNextRoute = if self.itemNext isnt false then app.router.getItemRoute(self.mode, self.itemNext) else false
		self.itemNext

	getPreviousItem: ->
		self=@
		# get index
		if self.itemCurrent > 0
			self.itemPrevious = self.itemCurrent - 1
		else if self.mode is "practice"
			self.itemPrevious = self.items.length - 1
		else self.itemPrevious = false
		# get the route
		self.itemPreviousRoute = if self.itemPrevious isnt false then app.router.getItemRoute(self.mode, self.itemPrevious) else false
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

		GameController.__super__.onClickLink.call(self, event) # call parent

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
			center: retinaPosition
			radius: self.toleranceAccuracy

		# for each difference of the item
		for difference in self.item.differencesArray

			# touch in the difference polygon.difference_points
			if app.helpers.collision.circleCollisionToPolygon(circle, difference.differencePointsArray)
				differenceFound = true

				# not already found
				if not difference.isFound? or not difference.isFound
					# activate it only if not already found
					self.activateDifference difference, event.currentTarget

					difference.isFound = true
					self.differencesFoundNumber++
					self.view.updateDifferencesFoundIndicator(self.differencesFoundNumber) # update the difference indicator

					# found all differences, load the next item
					if self.differencesFoundNumber is self.item.differencesArray.length
						setTimeout (-> self.loadNextItem()), 1000 # temporize the loading of the next item
						return true

				# break to let the user find one difference by one
				# return true

		# show an error if no difference were found
		if not differenceFound
			errorBounds = app.helpers.polygoner.rectangleFromPoint relativePosition, self.errorDimensions
			self.view.showError errorBounds

		return false

	activateDifference: (difference, target) ->
		self=@

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
