window.app = {}

# helpers
{DBHelper}            = require 'helpers/db_helper'
{DownloadHelper}      = require 'helpers/download_helper'
{ImageDownloadHelper} = require 'helpers/image_download_helper'
{FormatHelper}        = require 'helpers/format_helper'
{PositionHelper}      = require 'helpers/position_helper'

# router
{MainRouter} 						= require 'routers/main_router'

# controllers
{HomeController} 				= require 'controllers/home_controller'
{GameController} 				= require 'controllers/game_controller'

# views
{HomeView}   						= require 'views/home_view'
{GameView}   						= require 'views/game_view'

# models
{PlayerModel}          	= require 'models/player_model'
{TagModel}             	= require 'models/tag_model'
{PackModel}           	= require 'models/pack_model'
{ItemModel}            	= require 'models/item_model'
{DifferenceModel}      	= require 'models/difference_model'
{DifferencePointModel} 	= require 'models/difference_point_model'
{ImageModel}           	= require 'models/image_model'

# relationships (has to be defined after models because of the definition order / dependencies in many-to-many cases)
PlayerModel.hasMany('packs', PackModel, 'players')

TagModel.hasMany('packs', PackModel, 'tags')

PackModel.hasMany('tags', TagModel, 'packs')
PackModel.hasMany('players', PlayerModel, 'packs')
PackModel.hasMany('items', ItemModel, 'pack')
PackModel.hasOne('preview_image', ImageModel, null)
PackModel.hasOne('cover_image', ImageModel, null)

ItemModel.hasMany('differences', DifferenceModel, 'item')
ItemModel.hasOne('pack', PackModel, 'items')
ItemModel.hasOne('first_image', ImageModel, null)
ItemModel.hasOne('second_image', ImageModel, null)

DifferenceModel.hasMany('difference_points', DifferencePointModel, 'difference')

class exports.Application
	verbose:
		DBHelper           : true
		DownloadHelper     : true
		FormatHelper       : true
		PositionHelper     : true
		ImageDownloadHelper: true
	router: 			null
	helpers: 			{}
	models: 			{}
	controllers: 	{}
	views: 				{}

	constructor: ->
		@waitForDeviceReadyEvent()

	waitForDeviceReadyEvent: ->
		self=@
		$(window).load ->
			# device ready already fired
			if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
				console.log "device ready already fired"
				self.initialize()
			else
				console.log "waiting for device response"
				document.addEventListener "deviceready", ->
					self.onDeviceReady()
				, false

	onDeviceReady: ->
		self=@
		$ =>
			self.initialize()

	initialize: ->
		self=@

		# helpers
		self.helpers.db                       = DBHelper
		self.helpers.db.verbose               = self.verbose.DBHelper
		self.helpers.db.createProductionDatabase()
		self.helpers.downloader               = DownloadHelper
		self.helpers.downloader.verbose       = self.verbose.DownloadHelper
		self.helpers.image_downloader         = ImageDownloadHelper
		self.helpers.image_downloader.verbose = self.verbose.ImageDownloadHelper
		self.helpers.positioner               = PositionHelper
		self.helpers.positioner.verbose       = self.verbose.PositionHelper
		self.helpers.formater                 = FormatHelper
		self.helpers.formater.verbose         = self.verbose.FormatHelper

		# views
		self.views.home 				= new HomeView()
		self.views.game 				= new GameView()

		# controllers
		self.controllers.home 	= new HomeController(view: self.views.home)
		self.controllers.game 	= new GameController(view: self.views.game)

		# router
		self.router 						= MainRouter.init()

window.app = new exports.Application()