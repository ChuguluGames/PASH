class exports.PreloadHelper
	tag            : "PreloadHelper"
	timeout        : 1000
	timeoutTimer   : null
	callbackSuccess: null
	callbackError  : null
	images         : null
	image          : null
	startLoadingAt : null

	constructor: ->
		self=@
		self

	load: ->
		if not arguments? || arguments.length <= 1
			return

		@images          = Array.prototype.slice.call(arguments) # convert the args to a real array
		@callbackSuccess = @images.shift() # save the callback
		@callbackError   = @images.shift() # save the callback

		@loadAll() # start the preloading

	loadAll: ->
		if @images.length == 0
			@callbackSuccess()
		else

			@loadOne @images.shift()

	loadOne: (path) ->
		self=@

		self.startTimeoutChecker()

		self.image = $("<img />").load(->

			self.stopTimeoutChecker()
			app.helpers.log.info "preload: \"" + @src + "\"", self.tag
			self.loadAll() # load the next one

		# bind a possible 404 error
		).error(->
			self.stopTimeoutChecker()
			errorMessage = "Unable to load: \"" + @src + "\""
			app.helpers.log.info errorMessage, self.tag
			self.callbackError(errorMessage) # throw error

		).attr("src", path)

	startTimeoutChecker: ->
		self=@
		self.startLoadingAt = new Date().getTime()
		console.log "start timer"
		self.timeoutTimer = setInterval ->
			self.checkTimeout()
		, 10

	stopTimeoutChecker: ->
		self=@
		self.startLoadingAt = null
		console.log "stop timer"
		clearInterval self.timeoutTimer if self.timeoutTimer?

	checkTimeout: ->
		self=@
		if new Date().getTime() - self.startLoadingAt > self.timeout
			self.stopTimeoutChecker() # stop timer
			path = self.image.attr("src")
			self.image.remove() # remove the image
			self.callbackError("Timeout during loading " + path) # throw error
