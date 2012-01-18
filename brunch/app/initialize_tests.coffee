window.env =
	database 				: 'Test'
	onDatabaseReady	: ->
		mocha.run()

require 'initialize_common'