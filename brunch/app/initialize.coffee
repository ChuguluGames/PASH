window.app = {}

modules = [
	# helpers
	'db_helper'
	'download_helper'
	'image_download_helper'
	'format_helper'
	'position_helper'

	# router
	'main_router'

	# controllers
	'home_controller'
	'game_controller'

	# views
	'home_view'
	'game_view'

	# models
	'player_model'
	'tag_model'
	'pack_model'
	'item_model'
	'difference_model'
	'difference_point_model'
	'image_model'
]

# executes window.SomeType = require('types/some_type').SomeType for each class
for path in modules
	do (path) ->
		module_type = path.split('_').pop()
		module_path = module_type + 's/' + path
		module_class = path.replace(/(?:^|\s|_|\-)+\w/g, (match) -> match.toUpperCase()).replace(/_+/g, '')
		console.log module_path + " " + module_class
		window[module_class] = require(module_path)[module_class]

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
		self.helpers.db                       = DbHelper
		self.helpers.db.verbose               = self.verbose.DbHelper
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