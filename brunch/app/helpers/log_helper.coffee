helper = {}

helper.verbose = {}

helper.isVerbose = (tag) ->
	@verbose[tag]? && @verbose[tag]

helper.argumentsToArray = (args) ->
	Array.prototype.slice.call(args)

helper.log = (type, args) ->
	args = @argumentsToArray(args)
	tag = args.pop()

	# add the tag before the message
	args.unshift "[" + tag + "] "

	# can log
	if args? && args.length > 1 && @isVerbose tag
		# android version
		if navigator.userAgent.indexOf("Android") > -1
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

exports.LogHelper = helper