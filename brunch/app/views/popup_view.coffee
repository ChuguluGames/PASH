class exports.PopupView extends View
	attributes:
		class: "popup"
	template : require "templates/popup"

	settings: {}

	constructor: (attributes) ->
		super attributes
		@settings = {}

	configure: (@settings) ->

	render: () ->
		$(@el).html(TemplateHelper.generate(@template, @settings))
		$(@el).appendTo(@settings.container) if @settings.container?

		# cache some elements
		@elements =
			overlay   : $(".overlay", @el)
			background: $(".background", @el)

		# center the popup
		@center()

	show: (callback = null) ->
		callbackOnShow = =>
			@settings.events.onOpen.apply(@) if @settings.events.onOpen?
			callback() if callback?

		@showOverlay =>
			if @settings.pop and @settings.animated
				@elements.background.popIn 400, callbackOnShow
			else if @settings.fade and @settings.animated
				@elements.background.fadeIn 400, callbackOnShow
			else
				@elements.background.show()
				callbackOnShow()

	hide: (callback = null) ->
		callbackOnHide = =>
			@hideOverlay =>
				@destroy() if @settings.destroyOnClose
				@settings.events.onClose.apply(@) if @settings.events.onClose?
				callback() if callback?

		if @settings.pop and @settings.animated
			@elements.background.popOut 400, callbackOnHide

		else if @settings.fade and @settings.animated
			@elements.background.fadeOut 400, callbackOnHide

		else
			@elements.background.hide()
			callbackOnHide()
		false

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
		windowSize = DeviceHelper.getWindowSize()

		@elements.background.css
			left: (windowSize.width / 2 - @elements.background.width() / 2) + "px"
			top: (windowSize.height / 2 - @elements.background.height() / 2) + "px"

	destroy: ->
		$(@el).remove()
