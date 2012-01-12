<<<<<<< Updated upstream
window.app		= {}
app.routers 	= {}
app.models		= {}
=======
window.app = {}
app.helpers = {}
app.routers = {}
app.models = {}
>>>>>>> Stashed changes
app.collections = {}
app.views		= {}

<<<<<<< Updated upstream
# routers
MainRouter 				= require('routers/main_router').MainRouter

# views
HomeView 				= require('views/home_view').HomeView

# models
PackModel 				= require('models/pack_model').PackModel
TagModel 				= require('models/tag_model').TagModel
DifferenceModel 		= require('models/difference_model').DifferenceModel
DifferencePointModel 	= require('models/difference_point_model').DifferencePointModel

# collections
PacksCollection 			= require('collections/packs_collection').PacksCollection
ItemsCollection 			= require('collections/items_collection').ItemsCollection
TagsCollection 				= require('collections/tags_collection').TagsCollection
DifferencesCollection 		= require('collections/differences_collection').DifferencesCollection
DifferencePointsCollection 	= require('collections/difference_points_collection').DifferencePointsCollection
=======
ImageModel = require('models/image_model').ImageModel
DownloadHelper = require('helpers/download_helper').DownloadHelper
MainRouter = require('routers/main_router').MainRouter
HomeView = require('views/home_view').HomeView
>>>>>>> Stashed changes

app.onDeviceReady = ->
	$(document).ready ->
		console.log "onDeviceReady"
		app.initialize()

app.initialize = ->
<<<<<<< Updated upstream
  app.routers.main = new MainRouter()
  app.views.home = new HomeView()

  app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''
  Backbone.history.start()
=======

	app.models.image = new ImageModel()
	app.helpers.downloader = new DownloadHelper()
	app.routers.main = new MainRouter()
	app.views.home = new HomeView()
	Backbone.history.start()
	app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''
>>>>>>> Stashed changes

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