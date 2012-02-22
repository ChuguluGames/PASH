root = exports ? this

class root.Observable
	subscribers: {}
	watchers   : {}

	constructor: ->
		@subscribers = {}
		@watchers = {}

	on: (eventType, handler) ->
		prop = eventType.split(":")[1]
		if not @watchers[prop]?
			@watch(prop, @trigger)

		if not this.subscribers[eventType]?
			@subscribers[eventType] = []

		@subscribers[eventType].push(handler)

	off: (eventType, handler) ->
		subscribers = @subscribers[eventType]
		for key, subscriber in subscribers
			if (handler? and subscriber is handler) or not handler?
				@subscribers[eventType].splice(key, 1)

	trigger: (eventType) ->
		return if not @subscribers[eventType]? # no subscribers

		args = Array.prototype.slice.call(arguments) # convert the arguments list into an array
		args.shift() # remove the event type from the array

		# tell about the event for each subscriber
		subscribers = @subscribers[eventType].slice(0)
		for subscriber in subscribers
			subscriber.apply(@, args)

	watch: (prop, handler) ->
		oldVal 	= @[prop];

		@watchers[prop] = true

		@__defineSetter__(prop, (newVal) ->
			@["_" + prop] = newVal
			handler.call(@, "change:" + prop, prop, oldVal, newVal)
		)

		@__defineGetter__(prop, ->
			return @["_" + prop]
		)