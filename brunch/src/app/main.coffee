window.app  = {}
app.routers = {}
app.models  = {}
app.helpers = {}
app.views   = {}

# helpers
DBHelper       = require('helpers/db_helper').DBHelper
#DownloadHelper = require('helpers/download_helper').DownloadHelper

# routers
MainRouter = require('routers/main_router').MainRouter

# views
HomeView   = require('views/home_view').HomeView

# models
window.PlayerModel          = require('models/player_model').PlayerModel
window.TagModel             = require('models/tag_model').TagModel
window.PackModel            = require('models/pack_model').PackModel
window.ItemModel            = require('models/item_model').ItemModel
window.DifferenceModel      = require('models/difference_model').DifferenceModel
window.DifferencePointModel = require('models/difference_point_model').DifferencePointModel
window.ImageModel           = require('models/image_model').ImageModel

# relationships (has to be defined after models because of the definition order / dependencies in many-to-many cases)
PlayerModel.hasMany('packs', PackModel, 'players')

TagModel.hasMany('packs', PackModel, 'tags')

PackModel.hasMany('tags', TagModel, 'packs')
PackModel.hasMany('players', PlayerModel, 'packs')
PackModel.hasOne('preview_image', ImageModel, null)
PackModel.hasOne('cover_image', ImageModel, null)

ItemModel.hasMany('differences', DifferenceModel, 'item')
ItemModel.hasOne('first_image', ImageModel, null)
ItemModel.hasOne('second_image', ImageModel, null)

DifferenceModel.hasMany('difference_points', DifferencePointModel, 'difference')

# backbone / phonegap init
app.onDeviceReady = ->
	$(document).ready ->
		console.log "onDeviceReady"
		app.initialize()

app.initialize = ->
  app.routers.main       = new MainRouter()
  app.views.home         = new HomeView()
  app.helpers.db         = DBHelper
  app.helpers.db.verbous = true
  app.helpers.db.createProductionDatabase()

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