class exports.PreloadHelper
	tag            : "PreloadHelper"
	callbackSuccess: null
	callbackError  : null
	images         : null

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

		$("<img />").load(->
			app.helpers.log.info "preload: \"" + @src + "\"", self.tag
			self.loadAll() # load the next one

		# bind a possible 404 error
		).error(->
			errorMessage = "Unable to load: \"" + @src + "\""
			app.helpers.log.info errorMessage, self.tag
			# throw error
			self.callbackError(errorMessage)
		).attr("src", path)