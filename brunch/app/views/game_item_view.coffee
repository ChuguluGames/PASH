class exports.GameItemView extends View
	# -- static --
	@indicatorAnimationCreated = false

	@createIndicatorAnimation = ->
		if not @indicatorAnimationCreated
			styleSheet = document.styleSheets[0]
			styleSheet.insertRule("@-webkit-keyframes indicator_popout {
				from {
				} to {
					opacity: 1;
					-webkit-transform: scale(" + DynamicScreenHelper.itemScale + ");
				}
			}", styleSheet.cssRules.length)
			@indicatorAnimationCreated = true
	# -- static --

	template : require "templates/game_item"
	className: "item-wrapper"
	elements : {}

	errorElementHideAfter: 500

	render: ->
		self=@

		$(self.el).html app.helpers.template.generate self.template, {padding: DynamicScreenHelper.itemPadding}
		self.initializeElements()
		app.helpers.android_loading.setLoading(self.elements.loading) if app.helpers.device.isAndroid()
		self

	initializeElements: ->
		self=@
		self.elements.item        = $(".item", self.el)
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

		$indicators = self.createIndicatorElement type, rectangle

		finalCSSProperties =
			opacity: 1
			"-webkit-transform": "scale(" + DynamicScreenHelper.itemScale + ")"

		if DeviceHelper.canPerformAnimation()
			GameItemView.createIndicatorAnimation()

			$indicators.first().on 'webkitAnimationEnd', ->
				# keep the opacity and the transform
				$indicators.css(finalCSSProperties).removeClass 'indicator_popout'

			$indicators.addClass('indicator_popout')
		else
			$indicators.css finalCSSProperties

		self

	showIndicatorError: (rectangle) ->
		self=@

		$indicators = self.createIndicatorElement "error", rectangle

		timeoutCallback = ->
			$indicators.remove()
			# $indicators.css({left: "100%"}) # put the left the errors
			# # remove them after a little while... IOS 4.2<= bug
			# setTimeout(->
			# 	$indicators.remove()
			# , 10)

		if DeviceHelper.canPerformAnimation()
			$indicators.css
				"-webkit-transform": "scale(" + DynamicScreenHelper.itemScale + ")"

			setTimeout(->
				$indicators.first().on 'webkitAnimationEnd', timeoutCallback
				$indicators.addClass("indicator_error_fadeout")
			, self.errorElementHideAfter)
		else
			setTimeout(timeoutCallback, self.errorElementHideAfter)

		self

	createIndicatorElement: (type, rectangle) ->
		self=@
		containerClass = type + "s"

		differenceElement = $("<div />").css(
			left  : rectangle.position.x + "px"
			top   : rectangle.position.y + "px"
			width : rectangle.dimensions.width + "px"
			height: rectangle.dimensions.height + "px"
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

