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

		return if not self.validateItemID itemCurrent
		return if not self.validateMode mode

		self.mode = mode
		self.itemCurrent = itemCurrent

		# self.item = self.items[itemCurrent]

		self.findNextItem()

		# preload images and bubble to the view
		# app.helpers.preloader.load ->
		# 	self.view.hideLoading()
		# , self.item.first_image.image, self.item.second_image.image

		# render the view
		$("body").html self.view.render(
			item: 			self.item
			next: 			self.nextItem
			mode: 			self.mode
			score: 			self.score
		).el

		self.view.hideLoading()

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

		# for each difference of the item
		for difference in self.item.differences
		  do (difference) ->
				# difference already been found
				if difference.haveBeenFound
					return true

				# touch in the difference polygon
				if app.helper.positioner.pointInPolygon relativePosition difference
					# in polygon
					console.log "in polygon"
					return true