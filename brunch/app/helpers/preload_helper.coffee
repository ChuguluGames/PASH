class exports.PreloadHelper
	tag            : "PreloadHelper"
	timeout        : 40000
	timeoutTimer   : null
	callbackSuccess: null
	callbackError  : null
	images         : null

	startLoadingAt : null

	image          : null
	imagesCache    : null

	constructor: ->
		self=@
		self.imagesCache = []
		self.currentImage = null
		self

	load: ->
		if not arguments? || arguments.length <= 1
			return

		@images          = Array.prototype.slice.call(arguments) # convert the args to a real array
		@callbackSuccess = @images.shift() # save the callback
		@callbackError   = @images.shift() # save the callback

		@loadAll() # start the preloading

	loadAll: ->
		self=@
		if self.images.length == 0
			self.callbackSuccess.call(self, self.imagesCache)

		else
			self.loadOne self.images.shift()

	loadOne: (path) ->
		self=@

		self.startTimeoutChecker()

		image = document.createElement('img')
		self.imagesCache.push(image)
		self.currentImage = image

		$(image).load(->
			app.helpers.log.info "loaded in " + (new Date().getTime() - self.startLoadingAt), self.tag
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
			path = $(self.currentImage).attr("src")
			$(self.currentImage).remove() # remove the image
			self.callbackError("Timeout during loading " + path) # throw error

	cleanCache: ->
		self=@

		$(image).remove() for image in self.imagesCache
		self.imagesCache = null
		$(self.currentImage).remove()
		self.currentImage = null
