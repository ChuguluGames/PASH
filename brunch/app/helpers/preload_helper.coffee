class exports.PreloadHelper
	verbose: 	false
	tag: 			"PreloadHelper"
	callback: null

	constructor: ->
		self=@

	log: (message) ->
	  console.log "[" + @tag + "] " , message if message? && @verbose

	load: ->
		if not arguments? || not typeof arguments == "Array" || arguments.length <= 1
			return

		# save the callback
		@callback = arguments.shift()

		# start the preloading
		@startLoading arguments

	loadAll: ->
		if arguments.length == 0
			@callback()
		else
			@loadOne arguments.shift()

	loadOne: (path) ->
		self=@
		img = new Image()

		$(img).on("load", ->
			self.log @src + " has been loaded"
			self.loadAll() # load the next one

		).on("error", ->
			self.log @src + " has not been loaded"

		).attr("src", path)