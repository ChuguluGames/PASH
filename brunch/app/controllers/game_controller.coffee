class exports.GameController extends Controller
	events:
		"click .item .first-image, .item .second-image": "onClickItem"

	modes: ["practice", "survival", "challenge"]

	items: 				[]
	item: 				null
	itemCurrent: 	false
	itemNext: 		false
	mode: 				null
	score: 				0

	loadItems: ->
		self=@

		self.items=[]
		# self.items = ItemModel.fetchSelected()

	loadItem: (itemCurrent, mode) ->
		self=@

		self.loadItems()

		itemCurrent = 0 if not itemCurrent?
		mode = self.modes[0] if not mode?

		# return if not self.validateItemID itemCurrent
		# return if not self.validateMode mode

		self.mode = mode
		self.itemCurrent = itemCurrent

		# self.item = self.items[itemCurrent]

		self.findNextItem()

		{itemData} = require("item")
		{differencesData} = require("item")
		{differencesPointsData} = require("item")

		item = new ItemModel(itemData)
		l = differencesData.length
		i = 0

		while i < l
			difference = differencesData[i]
			differenceModel = new DifferenceModel(difference)
			differencePointsData = differencesPointsData[i]

			ll = differencePointsData.length
			ii = 0
			while ii < ll
				differencePoint = differencePointsData[ii]
				differencePointModel = new DifferencePointModel(differencePoint)
				differenceModel.difference_points.add(differencePointModel)
				ii++

			item.differences.add(differenceModel)
			i++

		self.item = item

		# download image
		# access
		# remove

		# preload images
		new app.helpers.preloader().load ->
			self.view.addItemImages(self.item)
			self.view.hideLoading()
		, self.item.first_image_url, self.item.second_image_url

		# render the view
		$("body").html self.view.render(
			item: 			self.item
			next: 			self.nextItem
			mode: 			self.mode
			score: 			self.score
		).el

	validateItemID: (itemCurrent) ->
		self=@
		if not app.helpers.formater.isInt itemCurrent
			console.error "Invalid itemID format"
			return false

		else if not self.items[itemCurrent]?
			console.error "no item at index " + itemCurrent
			return false

		true

	validateMode: (mode) ->
		self=@

		# can't find the mode in the config array
		if $.inArray(mode, self.modes) == -1
			console.error "unknown mode: " + mode
			return false

		true

	findNextItem: ->
		self=@
		if self.items.length >= self.itemCurrent + 1
			self.itemNext = self.itemCurrent + 1
		else
			# mode practice is infinite
			if self.mode == "practice"
				self.itemNext = 0
			# can't go further
			else self.itemNext = false

	# when the user click on the first image or the second
	onClickItem: (event) ->
		self=@

		position=
			x: event.pageX
			y: event.pageY

		# make the position relative to the item
		relativePosition = app.helpers.positioner.getRelativePosition event.currentTarget, position
		retinaPosition = if app.client.isRetina() then relativePosition else app.helpers.retina.positionToRetina(relativePosition)
		differenceFound = false

		# for each difference of the item
		for difference in self.item.differences
			do (difference) ->

				# touch in the difference polygon.difference_points
				inPolygon = app.helpers.polygoner.isPointInPolygon retinaPosition, difference.difference_points
				if inPolygon
					if not difference.isFound? || not difference.isFound
						app.log.info "found", "Application"
						# create the rectangle that wrap the polygon
						rectangleRetina = app.helpers.polygoner.polygonToRectangle difference.difference_points
						# get the rectangle for the resolution
						rectangle = app.helpers.retina.rectangleRetinaToClientResolution(rectangleRetina)
						# display the difference position
						console.log rectangleRetina
						self.view.showDifference(rectangle)
						difference.isFound = true
					differenceFound = true

		# still there, let's show a missed one
		if not differenceFound
			errorBounds = app.helpers.polygoner.rectangleFromPointAndTarget relativePosition, event.currentTarget, {width: 20, height: 20}
			self.view.showError errorBounds