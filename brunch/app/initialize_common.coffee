window.app = {}

modules = {
  helpers: [
    'android_loading'
    'config'
    'countdown'
    'locale'
    'device'
    'log'
    'db'
    'file_system'
    'download'
    'image_download'
    'format'
    'position'
    'polygon'
    'preload'
    'retina'
    'model_download'
    'event'
    'collision'
    'seed'
    'template'
  ]
  routers: [
    'main'
  ]
  controllers: [
    'home'
    'game'
    'options'
  ]
  views: [
    'home'
    'game'
    'options'
  ]
  models: [
    'player'
    'tag'
    'pack'
    'item'
    'difference'
    'difference_point'
    'image'
  ]
}

# executes window.SomeType = require('types/some_type').SomeType for each class
for type, list of modules
  typePath = type + "/"
  typeOdd = type.slice(0, -1)
  for name in list
    moduleFileName = name + "_" + typeOdd
    modulePath = typePath + moduleFileName
    moduleClass = moduleFileName.replace(/(?:^|\s|_|\-)+\w/g, (match) -> match.toUpperCase()).replace(/_+/g, '')
    window[moduleClass] = require(modulePath)[moduleClass]

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
    DeviceHelper       : true
    DbHelper           : false
    DownloadHelper     : true
    FormatHelper       : true
    PositionHelper     : true
    ImageDownloadHelper: true
    PreloadHelper      : true
    PolygonHelper      : true
    RetinaHelper       : true
    EventHelper        : true

  tag        : "Application"
  config     : require('config/config').config
  router     : MainRouter
  helpers    : {}
  models     : {}
  controllers: {}
  views      : {}

  constructor: ->
    self=@

    self.helpers.device      = DeviceHelper
    self.helpers.log         = LogHelper
    self.helpers.log.verbose = self.verbose

    self.waitForDeviceReadyEvent()

  waitForDeviceReadyEvent: ->
    self=@
    $(window).load ->
      # device ready already fired
      if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
        self.helpers.log.info "device ready already fired", self.tag
        self.initialize()
      else
        self.helpers.log.info "waiting for device response", self.tag
        document.addEventListener "deviceready", ->
          self.onDeviceReady()
        , false

  onDeviceReady: ->
    self=@
    self.helpers.log.info "on device ready", self.tag
    $ =>
      self.helpers.log.info "on dom ready", self.tag
      self.initialize()

  onDatabaseReady: ->
    if window.onDatabaseReady?
      return window.onDatabaseReady()
    self=@

    self.helpers.log.info "on database ready", self.tag

    self.helpers.fs.init ->
      self.helpers.seeder.seed ->
        # temp workaround for dismissing splash once the home is loaded
        if navigator? and navigator.splashscreen?
          MainRouter.onFirstRoute = ->
            setTimeout ->
              navigator.splashscreen.hide()
            , 2000
        # router
        self.router.init()
        # fix for .init("/home") ("#/home" fired twice)\
        self.router.setRoute(self.router.getHomeRoute()) if self.router.getRoute()[0] is ""
      , ->
        console.log "seed fail"
    , ->
      console.log "init fs fail"

  initialize: ->
    self=@

    # helpers
    self.helpers.android_loading  = AndroidLoadingHelper
    self.helpers.config           = ConfigHelper
    self.helpers.countdown        = CountdownHelper
    self.helpers.db               = DbHelper
    self.helpers.fs               = FileSystemHelper
    self.helpers.downloader       = DownloadHelper
    self.helpers.image_downloader = ImageDownloadHelper
    self.helpers.positioner       = PositionHelper
    self.helpers.formater         = FormatHelper
    self.helpers.preloader        = PreloadHelper
    self.helpers.polygoner        = PolygonHelper
    self.helpers.retina           = RetinaHelper
    self.helpers.event            = EventHelper
    self.helpers.seeder           = SeedHelper
    self.helpers.collision        = CollisionHelper
    self.helpers.template         = TemplateHelper
    self.helpers.locale           = LocaleHelper

    self.helpers.locale.setConfig(self.helpers.config.getLocales())
      .setLocale(self.helpers.device.getLocalization()) # override default locale by user localization setting

    if self.helpers.device.isMobile()
      activateFastClicks()
      self.helpers.event.disableScroll()

    self.helpers.model_downloader = ModelDownloadHelper

    # wait for database
    self.helpers.db.createPASHDatabase -> self.onDatabaseReady()

window.app = new exports.Application()
