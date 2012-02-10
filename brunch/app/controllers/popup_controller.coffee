class exports.PopupController extends Controller
	default:
		name         : "default"
		title        : true
		content      : true
		pop          : true
		fade         : false
		animated     : true
		container    : null
		autoOpen     : true
		destroyOnClose: true
		events: {
			onOpen  : null
			onClose : null
		}
		buttons      : {
			back   : false
			start  : false
			resume : false
			restart: false
		}

	settings: {}

	constructor: (attributes) ->
		super attributes
		@view     = new PopupView()
		@settings = {}

	configure: (options) ->
		# override defaults
		@settings = $.extend @default, options

		# check locale
		strings = LocaleHelper.getStrings()
		if not strings.popups[@settings.name]?
			@settings.title   = false if @settings.title is true
			@settings.content = false if @settings.content is true

		@settings.animated = DeviceHelper.canPerformAnimation()

		@view.configure(@settings)

	create: ->
		@view.render()
		@delegateEvents()
		@open() if @settings.autoOpen

	# @override
	delegateEvents: ->
		for name, activated of @settings.buttons
			if activated
				handler = @settings.events[("on_" + name).toCamelCase()]
				@delegateEvent($("." + name + ".button a", @el), handler) if handler?

	# @override
	delegateEvent: (button, handler) ->
		button.on "click", (event) =>
			event.preventDefault()
			handler.apply(@)
			false

	open: (callback = null) ->
		@view.show(callback)

	close: (callback = null) ->
		@view.hide(callback)

	destroy: ->
		@view.remove()