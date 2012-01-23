window.env = 'test'

window.onDatabaseReady = ->
	mocha.run()

require 'initialize_common'