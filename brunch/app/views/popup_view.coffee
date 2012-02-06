class exports.PopupView extends View
	template: null

	initialize: (attributes) ->
		settings =
			name         : "default"
			onShow       : null
			onClose      : null
			activateClose: false
			title        : true
			content      : true
			pop          : true
			fade         : false
			animated     : app.helpers.device.canPerformAnimation()
			buttons      : {}

		# override defaults
		@settings = $.extend settings, attributes.options

		@settings.activateClose = true if @settings.onClose?

		@className = "popup"
		@template = require "templates/popup"
		@make().render()

	render: ->
		$(@el).html(app.helpers.template.generate(@template, @settings)).appendTo($("body"))

		# cache some elements
		@elements =
			overlay: $(".overlay", @el)
			background: $(".background", @el)

		# center the popup
		@center()

		# center the buttons
		@centerButtons()

		# close event
		if @settings.activateClose
			@addHandlerToButton $(".close.button a", @el), @settings.onClose
			$(".close.button a", @el).on "click", => @settings.onClose()

		# buttons custom events
		for name, handler of @settings.buttons
			@addHandlerToButton $("." + name + ".button a", @el), handler

		$(".close.button a", @el).on "click", => @close()

	addHandlerToButton: (button, handler) ->
		button.on "click", handler

	close: ->
		@hide()
		false

	destroy: ->
		$(@el).remove()

	show: ->
		callbackOnShow = =>
			@settings.onShow() if @settings.onShow?

		@showOverlay =>
			if @settings.pop and @settings.animated
				@elements.background.popIn 400, callbackOnShow
			else if @settings.fade and @settings.animated
				@elements.background.fadeIn 400, callbackOnShow
			else
				@elements.background.show()
				callbackOnShow()

	hide: ->
		callbackOnHide = =>
			@hideOverlay => @destroy()
		if @settings.pop and @settings.animated
			@elements.background.popOut 400, callbackOnHide

		else if @settings.fade and @settings.animated
			@elements.background.fadeOut 400, callbackOnHide

		else
			@elements.background.hide()
			callbackOnHide()

	showOverlay: (callback) ->
		if @settings.animated
			@elements.overlay.fadeTo 200, .5, callback
		else
			@elements.overlay.css("opacity", .5)
			callback()

	hideOverlay: (callback) ->
		if @settings.animated
			@elements.overlay.fadeTo 200, 0, callback
		else
			@elements.overlay.hide()
			callback()

	center: ->
		windowSize = app.helpers.device.getWindowSize()

		@elements.background.css
			left: (windowSize.width / 2 - @elements.background.width() / 2) + "px"
			top: (windowSize.height / 2 - @elements.background.height() / 2) + "px"

	centerButtons: ->
		center = $(".footer .center", @el)
		width = 0
		center.find(".button").each ->
			width += $(@).outerWidth(true)

		center.width(width)
