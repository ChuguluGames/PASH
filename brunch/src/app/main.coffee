window.app		= {}
app.routers 	= {}
app.models		= {}
app.collections = {}
app.views		= {}

# routers
MainRouter 				= require('routers/main_router').MainRouter

# views
HomeView 				= require('views/home_view').HomeView

# models
PackModel 				= require('models/pack_model').PackModel
ItemModel 				= require('models/item_model').ItemModel
TagModel 				= require('models/tag_model').TagModel
DifferenceModel 		= require('models/difference_model').DifferenceModel
DifferencePointModel 	= require('models/difference_point_model').DifferencePointModel

# collections
PacksCollection 			= require('collections/packs_collection').PacksCollection
ItemsCollection 			= require('collections/items_collection').ItemsCollection
TagsCollection 				= require('collections/tags_collection').TagsCollection
DifferencesCollection 		= require('collections/differences_collection').DifferencesCollection
DifferencePointsCollection 	= require('collections/difference_points_collection').DifferencePointsCollection

app.onDeviceReady = ->
	$(document).ready ->
		console.log "onDeviceReady"
		app.initialize()

app.initialize = ->
  app.routers.main = new MainRouter()
  app.views.home = new HomeView()
  
  app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''
  Backbone.history.start()

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