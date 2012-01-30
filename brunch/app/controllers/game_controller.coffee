class exports.GameController extends Controller
	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image, .item .second-image": "onClickItem"

	differenceDimensions: {width: 64, height: 64}
	errorDimensions: {width: 36, height: 36}

	toleranceAccuracy: 20

	modes: ["practice", "survival", "challenge"]

	loaded                : false
	rendered              : false
	disabledClicks        : true

	items                 : []
	item                  : null
	itemCurrent           : 0
	itemNext              : 0
	itemNextRoute         : null
	mode                  : null
	score                 : 0
	differencesFoundNumber: 0

	start: ->
		self=@

		console.log "new game"
		self.getArguments.apply(self, arguments)

		self.on("change:loaded", self.onGameLoaded)
		self.render().load()

	render: ->
		self=@

		console.log "render"

		# render the view
		$("body").html self.view.render(
			score: self.score
		).el

		self.view.showLoading().disableLinks() # disable link until item is loaded

		# initiate events
		self.delegateEvents()

		self.rendered = true

		self

	load: ->
		self=@

		console.log "load"

		ItemModel.fetchSelected (items) ->
			console.log items.length
			self.items = items

			self.loaded = true

		self

	getArguments: (itemCurrent, mode) ->
		self=@
		console.log "getArguments"
		self.itemCurrent = if not itemCurrent? or not self.validateItemID(itemCurrent) then 0 else parseInt(itemCurrent)
		console.log "tested id"
		self.mode = if not mode? or not self.validateMode(mode) then self.modes[0] else mode
		console.log "tested mode"

	# resume game
	resume: ->
		self=@

		# can also be a previous from game, so let's check it!
		if self.rendered and self.itemCurrent > 0
			self.itemCurrent = self.getPreviousItem()
			self.loadItem()
			return

		console.log "resume game"

		self.render()

		# self.view.reset() 			# reset visuals
		self.view.showLoading() # show item loading
			.initializeDifferencesFoundIndicator(self.item.differencesArray, self.differencesFoundNumber)

		# show the difference already found
		for difference in self.item.differencesArray
			do (difference) ->
				self.activateDifference(difference) if difference.isFound? and difference.isFound

		self.onItemFetched() 		# item should be already fetched

	# load a new item
	loadItem: ->
		self=@

		console.log self.rendered
		self.render() if not self.rendered

		console.log "loadItem"

		self.getArguments.apply(self, arguments)

		self.view.reset() # reset visuals
			.showLoading()  # and show loading
			.disableLinks()
		self.disabledClicks = true # disable clicks

		# reset item differences
		if self.item?
			for difference in self.item.differencesArray
				difference.isFound = false
		# reset item
		self.item = null
		self.differencesFoundNumber = 0

		# wait until the game is loaded to load the item
		if not self.loaded then self.on("change:loaded", self.onGameLoaded) else self.onGameLoaded()

	validateItemID: (itemCurrent) ->
		self=@
		if not app.helpers.formater.isInt itemCurrent
			console.log "Invalid itemID format"
			return false

		true

	validateMode: (mode) ->
		self=@

		# can't find the mode in the config array
		if $.inArray(mode, self.modes) == -1
			app.helpers.log.error "unknown mode: " + mode, self.tag
			return false

		true

	onGameLoaded: ->
		self=@

		console.log self.itemCurrent

		if self.items[self.itemCurrent]?
			self.item = self.items[self.itemCurrent]
		else
			alert "error, no item at " + self.itemCurrent
			return false

		self.findNextItem()
		self.item.fetchAll -> self.onItemFetched() # get the data of the item

	onItemFetched: ->
		self=@

		# order each differences polygon points
		for difference in self.item.differencesArray
			app.helpers.polygoner.orderPoints(difference.differencePointsArray)

		new app.helpers.preloader().load ->

			# update the view
			self.view.update(
				item: self.item 									# update the item images
				next: "#/" + self.itemNextRoute 	# update the next link
			)
				.hideLoading() # hide the loading indicator
				.enableLinks() # enable links
				.initializeDifferencesFoundIndicator(self.item.differencesArray, self.differencesFoundNumber) # initialize difference indicator

			self.disabledClicks = false # enable clicks

		, (error) ->
			alert error
			# load next item
			self.loadNextItem()

		, self.item.first_image.getSrc(), self.item.second_image.getSrc() # preload the item images

	loadNextItem: ->
		self=@

		# no more item
		if !self.itemNext
			# if practice mode, load the first one
			# else load the end game
		# change the route
		else
			app.router.setRoute self.itemNextRoute

	findNextItem: ->
		self=@
		if self.itemCurrent + 1 < self.items.length
			self.itemNext = self.itemCurrent + 1
		else
			# mode practice is infinite
			if self.mode == "practice"
				self.itemNext = 0
			# can't go further
			else self.itemNext = false

		self.itemNextRoute = app.router.routeForItem self.itemNext, self.mode

		console.log "next route " + self.itemNextRoute

	getPreviousItem: ->
		self=@
		if self.itemCurrent > 0
			return self.itemCurrent - 1
		else return 0

	onClickLink: (event) ->
		self=@

		return event.preventDefault() if self.disabledClicks
		# call parent
		GameController.__super__.onClickLink.call(self, event)

	# when the user click on the first image or the second
	onClickItem: (event) ->
		self=@

		return event.preventDefault() if self.disabledClicks

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
				if not difference.isFound? || not difference.isFound
					# activate it only if not already found
					self.activateDifference difference, event.currentTarget

					difference.isFound = true
					self.differencesFoundNumber++
					self.view.updateDifferencesFoundIndicator(self.differencesFoundNumber) # update the difference indicator

					# found all differences, load the next item
					if self.differencesFoundNumber == self.item.differencesArray.length
						setTimeout (-> self.loadNextItem()), 1000 # temporize the loading of the next item
						return true

				# break to let the user find one difference by one
				# return true

		# show an error if no difference were found
		if not differenceFound
			errorBounds = app.helpers.polygoner.rectangleFromPointAndTarget relativePosition, event.currentTarget, self.errorDimensions
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
		differenceRectangle = app.helpers.polygoner.rectangleFromPointAndTarget rectangleCenter, target, self.differenceDimensions

		self.view.showDifference(differenceRectangle) # display the difference position
