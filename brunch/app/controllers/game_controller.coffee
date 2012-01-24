class exports.GameController extends Controller
	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image, .item .second-image": "onClickItem"

	modes: ["practice", "survival", "challenge"]

	loaded                : false
	rendered              : false

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

		console.log "resume game"

		self.render()

		# self.view.reset() 			# reset visuals
		self.view.showLoading() # show item loading
			.initializeDifferencesFoundIndicator(self.item.differencesArray, self.differencesFoundNumber)

		# show the difference already found
		for difference in self.item.differencesArray
			do (difference) ->
				if difference.isFound? and difference.isFound
					# create the rectangle that wrap the polygon
					rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.differencePointsArray

					# get the rectangle for the resolution
					rectangle = app.helpers.retina.rectangleRetinaToNonRetina(rectangleRetina)

					# display the difference position
					self.view.showDifference(rectangle)

		self.onItemFetched() 		# item should be already fetched

	# load a new item
	loadItem: ->
		self=@

		self.getArguments.apply(self, arguments)

		self.view.reset().showLoading() # reset visuals and show loading

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

		self.view.initializeDifferencesFoundIndicator(self.item.differencesArray, self.differencesFoundNumber)

		new app.helpers.preloader().load ->

			# update the view
			self.view.update(
				item: self.item 									# update the item images
				next: "#/" + self.itemNextRoute 	# update the next link
			).hideLoading() # hide the loading indicator

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

		self.itemNextRoute = "game/" + self.itemNext + "/mode/" + self.mode

		console.log "next route " + self.itemNextRoute

	# when the user click on the first image or the second
	onClickItem: (event) ->
		self=@

		position=
			x: event.pageX
			y: event.pageY

		# make the position relative to the item
		relativePosition = app.helpers.positioner.getRelativePosition event.currentTarget, position

		# make the position adapt to the retina
		retinaPosition = app.helpers.retina.positionToRetina(relativePosition)
		differenceFound = false

		# for each difference of the item
		for difference in self.item.differencesArray
			console.log difference

			# touch in the difference polygon.difference_points
			if app.helpers.polygoner.isPointInPolygon(retinaPosition, difference.differencePointsArray)
				differenceFound = true
				# activate it only if not already found
				self.activateDifference difference if not difference.isFound? || not difference.isFound
				return true

		# still there, let's show a missed one
		errorBounds = app.helpers.polygoner.rectangleFromPointAndTarget relativePosition, event.currentTarget, {width: 20, height: 20}
		self.view.showError errorBounds
		return false

	activateDifference: (difference) ->
		self=@

		# create the rectangle that wrap the polygon
		rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.differencePointsArray

		# get the rectangle for the resolution
		rectangle = app.helpers.retina.rectangleRetinaToNonRetina(rectangleRetina)

		difference.isFound = true
		self.differencesFoundNumber++

		# display the difference position
		self.view.showDifference(rectangle)
			.updateDifferencesFoundIndicator(self.differencesFoundNumber)

		# found each differences, load the next item
		if self.differencesFoundNumber == self.item.differencesArray.length
			setTimeout (-> self.loadNextItem()), 1000 # temporize the loading of the next item