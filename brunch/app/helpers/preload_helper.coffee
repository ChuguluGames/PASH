class exports.PreloadHelper
	# dependencies: LogHelper, CountdownHelper

	# -- static --
	@tag     = "PreloadHelper"
	@timeout = 4000
	# -- static --

	timeoutTimer   : null
	callbackSuccess: null
	callbackError  : null
	images         : null

	startLoadingAt : null

	image          : null
	imagesCache    : null

	constructor: ->
		@imagesCache  = []
		@currentImage = null
		@

	load: ->
		if not arguments? || arguments.length <= 1
			return

		@images          = Array.prototype.slice.call(arguments) # convert the args to a real array
		@callbackSuccess = @images.shift() # save the callback
		@callbackError   = @images.shift() # save the callback

		@loadAll() # start the preloading

	loadAll: ->
		if @images.length == 0
			@callbackSuccess.call(@, @imagesCache)

		else
			@loadOne @images.shift()

	loadOne: (path) ->
		@startTimeoutChecker()

		image = document.createElement('img')
		@imagesCache.push(image)
		@currentImage = image

		self=@

		$(image).load(->
			LogHelper.info "loaded in " + (CountdownHelper.now() - self.startLoadingAt), self.tag
			self.stopTimeoutChecker()
			LogHelper.info "preload: \"" + @src + "\"", PreloadHelper.tag
			self.loadAll() # load the next one

		# bind a possible 404 error
		).error(->
			self.stopTimeoutChecker()
			errorMessage = "Unable to load: \"" + @src + "\""
			LogHelper.info errorMessage, PreloadHelper.tag
			self.callbackError(errorMessage) # throw error

		).attr("src", path)

	startTimeoutChecker: ->
		@startLoadingAt = CountdownHelper.now()
		console.log "start timer"
		@timeoutTimer = setInterval =>
			@checkTimeout()
		, 10

	stopTimeoutChecker: ->
		@startLoadingAt = null
		console.log "stop timer"
		clearInterval @timeoutTimer if @timeoutTimer?

	checkTimeout: ->
		if CountdownHelper.now() - @startLoadingAt > PreloadHelper.timeout
			@stopTimeoutChecker() # stop timer
			path = $(@currentImage).attr("src")
			$(@currentImage).remove() # remove the image
			@callbackError("Timeout during loading " + path) # throw error

	cleanCache: ->
		$(image).remove() for image in @imagesCache
		@imagesCache = null
		$(@currentImage).remove()
		@currentImage = null
