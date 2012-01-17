class exports.PreloadHelper
	verbose: 	true
	tag: 			"PreloadHelper"
	callback: null
	args: 		null

	constructor: ->
		self=@
		self

	log: (message) ->
	  console.log "[" + @tag + "] " , message if message? && @verbose

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
		img = new Image()

		$("<img />").load(->
			self.log "preload: \"" + @src + "\""
			self.loadAll() # load the next one

		# bind a possible 404 error
		).error(->
			self.log "unable to load: \"" + src + "\""

		).attr("src", path)