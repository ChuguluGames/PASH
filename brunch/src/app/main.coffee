window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

MainRouter = require('routers/main_router').MainRouter
HomeView = require('views/home_view').HomeView

app.onDeviceReady = ->
	$(document).ready ->
		console.log "onDeviceReady"
		app.initialize()

app.initialize = ->
  app.routers.main = new MainRouter()
  app.views.home = new HomeView()
  Backbone.history.start()
  app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''

$(window).load ->
	# device ready already fired
	if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
		console.log "device ready already fired"
		app.initialize()
	else
		console.log "waiting for device response"
		document.addEventListener "deviceready", ->
			app.onDeviceReady()
		, false