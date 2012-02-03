class exports.GameItemView extends View
	template : require "templates/game_item"
	className: "item-wrapper"
	elements : {}

	differenceElement:
		initialRatio  : 7
		effectDuration: 500

	errorElement:
		hideAfter: 500
		hideIn   : 500

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		app.helpers.android_loading.setLoading(self.elements.loading) if app.helpers.device.isAndroid()

		self.initializeElements()

		self

	initializeElements: ->
		self=@
		self.elements.item  = $(".item", self.el)
		self.elements.firstImage  = $(".first-image", self.el)
		self.elements.secondImage = $(".second-image", self.el)
		self.elements.loading     = $(".item-loading", self.el)

	update: (data) ->
		self=@
		$(".img", self.elements.firstImage).html(data.first_image)
		$(".img", self.elements.secondImage).html(data.second_image)
		self

	reset: ->
		self=@
		self.elements.firstImage.find(".img, .founds, .errors, .clues").empty()
		self.elements.secondImage.find(".img, .founds, .errors, .clues").empty()

	showIndicator: (type, rectangle) ->
		self=@

		return self.showIndicatorError(rectangle) if type is "error"

		initialRectangle = {}
		initialRectangle.width = rectangle.dimensions.width * self.differenceElement.initialRatio
		initialRectangle.height = rectangle.dimensions.height * self.differenceElement.initialRatio
		initialRectangle.left = rectangle.position.x + rectangle.dimensions.width / 2 - initialRectangle.width / 2
		initialRectangle.top = rectangle.position.y + rectangle.dimensions.height / 2 - initialRectangle.height / 2

		indicators = self.createIndicatorElement type, initialRectangle

		indicators.animate {
			opacity: 1
			left   : rectangle.position.x + "px"
			top    : rectangle.position.y + "px"
			width  : rectangle.dimensions.width + "px"
			height : rectangle.dimensions.height + "px"
		}, {
			duration: self.differenceElement.effectDuration
		}

		self

	showIndicatorError: (rectangle) ->
		self=@

		indicators = self.createIndicatorElement "error",
			left  : rectangle.position.x
			top   : rectangle.position.y
			width : rectangle.dimensions.width
			height: rectangle.dimensions.height

		setTimeout(->
			indicators.animate {
				opacity: "0"
			}, {
				duration: self.errorElement.hideIn
				complete: ->
					# put the left the errors
					indicators.css({left: -rectangle.dimensions.width + "px"})
					# remove them after a little while...
					setTimeout(->
						indicators.remove()
					, 10)
			}
		, self.errorElement.hideAfter)

		self

	createIndicatorElement: (type, rectangle) ->
		self=@
		containerClass = type + "s"

		differenceElement = $("<div />").css(
			left  : rectangle.left + "px"
			top   : rectangle.top + "px"
			width : rectangle.width + "px"
			height: rectangle.height + "px"
			"-webkit-transition": "opacity 5000ms ease"
		).appendTo($("." + containerClass, self.elements.firstImage))
		differenceElementClone = differenceElement.clone().appendTo($("." + containerClass, self.elements.secondImage))

		differenceElement.add(differenceElementClone)

	removeDifferencesAndErrorsElements: ->
		self=@
		# self.elements.firstImage.find(".found, .error").remove()
		# self.elements.secondImage.find(".found, .error").remove()

	hideLoading: ->
		self=@
		app.helpers.android_loading.stop() if app.helpers.device.isAndroid()
		self.elements.loading.hide()
		self.elements.item.show()
		self

	showLoading: ->
		self=@
		app.helpers.android_loading.start() if app.helpers.device.isAndroid()
		self.elements.loading.show()
		self.elements.item.hide()
		self

