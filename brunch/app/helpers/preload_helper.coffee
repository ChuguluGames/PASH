class exports.PreloadHelper
	tag: 			"PreloadHelper"
	callback: null
	args: 		null

	constructor: ->
		self=@
		self

	load: ->
		if not arguments? || arguments.length <= 1
			return

		@args = Array.prototype.slice.call(arguments) # convert the args to a real array
		@callback = @args.shift() # save the callback

		@loadAll() # start the preloading

	loadAll: ->
		if @args.length == 0
			@callback()
		else

			@loadOne @args.shift()

	loadOne: (path) ->
		self=@

		$("<img />").load(->
			app.helpers.log.info "preload: \"" + @src + "\"", self.tag
			self.loadAll() # load the next one

		# bind a possible 404 error
		).error(->
			app.helpers.log.info "unable to load: \"" + @src + "\"", self.tag

		).attr("src", path)