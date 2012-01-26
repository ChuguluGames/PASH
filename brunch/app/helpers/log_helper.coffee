class exports.LogHelper
	self=@

	self.verbose = {}

	self.isVerbose = (tag) ->
		self.verbose[tag]? && self.verbose[tag]

	self.argumentsToArray = (args) ->
		Array.prototype.slice.call(args)

	self.printObjects = (array) ->
		newArray = []
		for item in array
			do (item) ->
				if typeof item == "object"
					itemString = "{"
					i = 0
					for prop, key of item
						do (prop, key) ->
							itemString += ", " if i > 0
							value = item[prop]
							itemString += prop + ": "
							itemString += value
							i++

					item = itemString + "}"

				newArray.push item
		newArray

	self.log = (type, args) ->
		args = self.argumentsToArray(args)

		tag = args.pop()

		# add the tag before the message
		args.unshift "[" + tag + "] "

		# can log
		if args? && args.length >= 1 && self.isVerbose tag
			type = "log" if (typeof console[type] == "undefined" or console[type] == null)
			# android version
			if app.helpers.device.isMobile()
				# goto print the object of the mother
				args = self.printObjects args

				console[type](args.join(""))
			else
				console[type].apply(window.console, args)

		true

	self.error = ->
		self.log "error", arguments

	self.warn = ->
		self.log "warn", arguments

	self.info = ->
		self.log "info", arguments