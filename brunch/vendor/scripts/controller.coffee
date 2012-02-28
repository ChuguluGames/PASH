root = exports ? this

class root.Controller extends root.Observable

	eventSplitter: /^(\S+)\s*(.*)$/
	events:
		"click a": "onClickLink"
	handlersEvents: []

	constructor: (attributes) ->
		super # call observable constructor

		# reset shared properties
		@handlersEvents = []

		@[property] = attributes[property] for property of attributes

		@createHandlersEvents()

	initialize: ->

	destroy: ->
		@delegateEvents 'off'
		@onDestroy()

	activate: ->
		@onActivate()

	onDestroy: ->
	onActivate: ->

	createHandlersEvents: ->
		for key, methodName of @events
			do (key, methodName) =>
				method = @[methodName]
				match = key.match(@eventSplitter)

				@handlersEvents.push
					eventName: match[1]
					selector : match[2]
					handler  : (event) => method.call @, event

	delegateEvents: (action = "on") ->
		for event in @handlersEvents
			@delegateEvent(event.selector, @view.el, event.eventName, event.handler, action)

	delegateEvent: (selector, el, eventName, handler, action) ->
		console.log selector + " " + eventName + " " + action
		if not selector?
			$el = $(el)
		else if selector is "document" or selector is "window"
			$el = $(document)
		else
			$el = $(selector, el)

		$el[action](eventName, handler)

	# TODO: move this elsewhere (maybe create a appcontroller class)
	onClickLink: (event) ->
		event.preventDefault()

		route = $(event.delegateTarget).attr("href")

		if route.substr(0, 1) is '#' and route.length > 1
			app.router.setRoute route.substr(2) # get ride of #/
		else if route isnt "" and route isnt '#'
			window.location.href = route

		false
