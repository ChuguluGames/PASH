helper = {}

helper.verbose = {}

helper.isVerbose = (tag) ->
	@verbose[tag]? && @verbose[tag]

helper.argumentsToArray = (args) ->
	Array.prototype.slice.call(args)

helper.printObjects = (array) ->
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

helper.log = (type, args) ->
	caller = @getCallerInfo()
	args = @argumentsToArray(args)
	tag = args.pop()
	tagAndLine = tag + ":"+ caller.line + ""

	# add the tag before the message
	args.unshift "[" + tagAndLine + "] "

	# can log
	if args? && args.length > 1 && @isVerbose tag
		# android version
		if app.client.isAndroid()
			# goto print the object of the mother
			args = @printObjects args
			console[type](args.join(""))
		else
			console[type].apply(window.console, args)

	true

helper.error = ->
	@log "error", arguments

helper.warn = ->
	@log "warn", arguments

helper.info = ->
	@log "info", arguments

helper.getCallerInfo = ->
	p = new printStackTrace.implementation()
	data = p.run()[5] # go back to the caller source
	regex = /.*\.js:([0-9]+):?([0-9]+)?/
	match = data.match(regex)

	match = [null, 0, 0,] if not match?

	return {
		line     : match[1]
		character: match[2]
	}

exports.LogHelper = helper