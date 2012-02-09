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
		$(@el).html TemplateHelper.generate @template, {padding: DynamicScreenHelper.itemPadding}
		@initializeElements()
		AndroidLoadingHelper.setLoading(@elements.loading) if DeviceHelper.isAndroid()
		@

	initializeElements: ->
		@elements.item        = $(".item", @el)
		@elements.firstImage  = $(".first-image", @el)
		@elements.secondImage = $(".second-image", @el)
		@elements.loading     = $(".item-loading", @el)

	update: (data) ->
		$(".img", @elements.firstImage).html(data.first_image)
		$(".img", @elements.secondImage).html(data.second_image)
		@

	reset: ->
		@elements.firstImage.find(".img, .founds, .errors, .clues").empty()
		@elements.secondImage.find(".img, .founds, .errors, .clues").empty()

	showIndicator: (type, rectangle) ->
		return @showIndicatorError(rectangle) if type is "error"

		$indicators = @createIndicatorElement type, rectangle

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
		@

	showIndicatorError: (rectangle) ->
		$indicators = @createIndicatorElement "error", rectangle

		timeoutCallback = ->
			$indicators.remove()

		if DeviceHelper.canPerformAnimation()
			$indicators.css
				"-webkit-transform": "scale(" + DynamicScreenHelper.itemScale + ")"

			setTimeout(=>
				$indicators.first().on 'webkitAnimationEnd', timeoutCallback
				$indicators.addClass("indicator_error_fadeout")
			, @errorElementHideAfter)
		else
			setTimeout(timeoutCallback, @errorElementHideAfter)
		@

	createIndicatorElement: (type, rectangle) ->
		containerClass = type + "s"

		differenceElement = $("<div />").css(
			left  : rectangle.position.x + "px"
			top   : rectangle.position.y + "px"
			width : rectangle.dimensions.width + "px"
			height: rectangle.dimensions.height + "px"
		).appendTo($("." + containerClass, @elements.firstImage))

		differenceElementClone = differenceElement.clone().appendTo($("." + containerClass, @elements.secondImage))

		differenceElement.add(differenceElementClone)

	hideLoading: ->
		AndroidLoadingHelper.stop() if DeviceHelper.isAndroid()
		@elements.loading.hide()
		@elements.item.show()
		@

	showLoading: ->

		AndroidLoadingHelper.start() if DeviceHelper.isAndroid()
		@elements.loading.show()
		@elements.item.hide()
		@

