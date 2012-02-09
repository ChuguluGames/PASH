class exports.LogHelper
	# dependencies: DeviceHelper

	@verbose = {}

	@isVerbose = (tag) ->
		@verbose[tag]? && @verbose[tag]

	@argumentsToArray = (args) ->
		Array.prototype.slice.call(args)

	@printObjects = (array) ->
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

	@log = (type, args) ->
		args = @argumentsToArray(args)

		tag = args.pop()

		# add the tag before the message
		args.unshift "[" + tag + "] "

		# can log
		if args? && args.length >= 1 && @isVerbose tag
			type = "log" if (typeof console[type] == "undefined" or console[type] == null)
			# android version
			if DeviceHelper.isMobile()
				# goto print the object of the mother
				args = @printObjects args

				console[type](args.join(""))
			else
				console[type].apply(window.console, args)

		true

	@error = ->
		@log "error", arguments

	@warn = ->
		@log "warn", arguments

	@info = ->
		@log "info", arguments