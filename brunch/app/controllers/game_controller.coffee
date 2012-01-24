class exports.GameController extends Controller
	events:
		"click a"                                      : "onClickLink"
		"click .item .first-image, .item .second-image": "onClickItem"

	modes: ["practice", "survival", "challenge"]

	loaded          : false
	rendered        : false

	items           : []
	item            : null
	itemCurrent     : false
	itemNext        : false
	itemNextRoute   : null
	mode            : null
	score           : 0
	differencesFound: 0

	initialize: ->
		self=@

		self.render().load ->
			console.log "game loaded"
			self.loaded = true

		self

	render: ->
		self=@

		# render the view
		$("body").html self.view.render(
			score: self.score
		).el

		# initiate events
		self.delegateEvents()

		self.rendered = true

		self

	load: (callback) ->
		self=@

		console.log "loading game"

		return callback() if self.items.length > 0

		ItemModel.fetchSelected (items) ->
			self.items = items
			callback()

		self

	resetItem: ->
		self=@
		self.item = null
		self.differencesFound = 0

	loadItem: (itemCurrent, mode) ->
		self=@

		self.view.reset() # reset visuals
		self.view.showLoading() # show item loading
		self.resetItem() # reset item

		onLoaded = ->
			# render the game if not yet rendered
			self.render() if not self.rendered

			console.log "loading item"
			itemCurrent = 0 if not itemCurrent?
			mode = self.modes[0] if not mode?

			self.mode = mode
			self.itemCurrent = parseInt(itemCurrent)
			self.findNextItem()

			self.item = self.items[self.itemCurrent]

			# get the data of the item
			self.item.fetchAll ->
				console.log "item fetched"
				# return self.loadNextItem() if not self.item.differencesArray.length? || self.item.differencesArray.length == 0

				# preload images
				new app.helpers.preloader().load ->

					# update the view
					self.view.update(
						item: self.item
						next: "#/" + self.itemNextRoute
					)

					self.view.hideLoading() # hide the loading indicator
				, self.item.first_image.getSrc(), self.item.second_image.getSrc()


		# wait until the game is loaded to load the item
		if not self.loaded then self.on("change:loaded", onLoaded) else onLoaded()

		# return if not self.validateItemID itemCurrent
		# return if not self.validateMode mode

		# self.item = self.items[itemCurrent]

		# self.findNextItem()

		# {itemData} = require("item")
		# {differencesData} = require("item")
		# {differencesPointsData} = require("item")

		# item = new ItemModel(itemData)
		# l = differencesData.length
		# i = 0

		# while i < l
		# 	difference = differencesData[i]
		# 	differenceModel = new DifferenceModel(difference)
		# 	differencePointsData = differencesPointsData[i]

		# 	ll = differencePointsData.length
		# 	ii = 0
		# 	while ii < ll
		# 		differencePoint = differencePointsData[ii]
		# 		differencePointModel = new DifferencePointModel(differencePoint)
		# 		differenceModel.difference_points.add(differencePointModel)
		# 		ii++

		# 	item.differences.add(differenceModel)
		# 	i++

		# self.item = item

		# download image
		# access
		# remove

	loadNextItem: ->
		self=@

		# no more item
		if !self.itemNext

		# change the route
		else
			app.router.setRoute self.itemNextRoute

	validateItemID: (itemCurrent) ->
		self=@
		if not app.helpers.formater.isInt itemCurrent
			app.helpers.log.error "Invalid itemID format", self.tag
			return false

		else if not self.items[itemCurrent]?
			app.helpers.log.error "no item at index " + itemCurrent, self.tag
			return false

		true

	validateMode: (mode) ->
		self=@

		# can't find the mode in the config array
		if $.inArray(mode, self.modes) == -1
			app.helpers.log.error "unknown mode: " + mode, self.tag
			return false

		true

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
			do (difference) ->
				console.log difference

				inPolygon = app.helpers.polygoner.isPointInPolygon retinaPosition, difference.differencePointsArray
				# touch in the difference polygon.difference_points

				if inPolygon
					if not typeof difference.isFound == "undefined" || not difference.isFound
						# create the rectangle that wrap the polygon
						rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.differencePointsArray

						# get the rectangle for the resolution
						rectangle = app.helpers.retina.rectangleRetinaToNonRetina(rectangleRetina)

						# display the difference position
						self.view.showDifference(rectangle)

						difference.isFound = true
						self.differencesFound++
					differenceFound = true

					self.view.showDifferencesFound(self.differencesFound)

					# found each differences, load the next item
					self.loadNextItem() if self.differencesFound == self.item.differencesArray.length

		# still there, let's show a missed one
		if not differenceFound
			errorBounds = app.helpers.polygoner.rectangleFromPointAndTarget relativePosition, event.currentTarget, {width: 20, height: 20}
			self.view.showError errorBounds