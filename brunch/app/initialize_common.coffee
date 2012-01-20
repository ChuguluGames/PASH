window.app = {}

modules = [
  # helpers
  'client_helper'
  'log_helper'
  'db_helper'
  'download_helper'
  'image_download_helper'
  'format_helper'
  'position_helper'
  'polygon_helper'
  'preload_helper'
  'retina_helper'

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
#   console.log module_path + " " + module_class
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
    Application        : true
    MainRouter         : true
    ClientHelper       : true
    DbHelper           : true
    DownloadHelper     : true
    FormatHelper       : true
    PositionHelper     : true
    ImageDownloadHelper: true
    PreloadHelper      : true
    PolygonHelper      : true
    RetinaHelper       : true

  tag   :          "Application"
  log   :          LogHelper
  client:          new ClientHelper()

  router:       null
  helpers:      {}
  models:       {}
  controllers:  {}
  views:        {}

  constructor: ->
    self=@
    self.log.verbose = self.verbose
    self.waitForDeviceReadyEvent()

  waitForDeviceReadyEvent: ->
    self=@
    $(window).load ->
      # device ready already fired
      if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
        self.log.info "device ready already fired", self.tag
        self.initialize()
      else
        self.log.info "waiting for device response", self.tag
        document.addEventListener "deviceready", ->
          self.onDeviceReady()
        , false

  onDeviceReady: ->
    self=@
    self.log.info "on device ready", self.tag
    $ =>
      self.log.info "on dom ready", self.tag
      self.initialize()

  onDatabaseReady: ->
    if window.env.onDatabaseReady?
      return window.env.onDatabaseReady()

    self=@

    self.log.info "on database ready", self.tag

    # router
    self.router           = MainRouter.init('/home')

  initialize: ->
    self=@

    # helpers
    self.helpers.db               = DbHelper
    self.helpers.downloader       = DownloadHelper
    self.helpers.image_downloader = ImageDownloadHelper
    self.helpers.positioner       = PositionHelper
    self.helpers.formater         = FormatHelper
    self.helpers.preloader        = PreloadHelper
    self.helpers.polygoner        = PolygonHelper
    self.helpers.retina           = RetinaHelper

    # activate the fast clicks if needed
    activateFastClicks() if self.client.isMobile()

    # wait for database
    self.helpers.db['create' + window.env.database + 'Database'] -> self.onDatabaseReady()

window.app = new exports.Application()
