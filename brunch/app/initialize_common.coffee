window.app = {}

modules = {
  helpers: [
    'benchmark'
    'config'
    'countdown'
    'dynamic_screen'
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
    'model_download'
    'event'
    'collision'
    'scale'
    'seed'
    'template'
  ]
  routers: [
    'main'
  ]
  controllers: [
    'home'
    'game'
    'scoring_game'
    'challenge_game'
    'survival_game'
    'zen_game'
    'options'
  ]
  views: [
    'home'
    'game'
    'game_item'
    'game_score'
    'game_timer'
    'game_topbar'
    'challenge_game'
    'popup'
    'survival_game'
    'zen_game'
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
  engines: [
    'spots'
    'scoring_spots'
    'challenge_spots'
    'survival_spots'
    'zen_spots'
  ]
}

# executes window.SomeType = require('types/some_type').SomeType for each class
for type, list of modules
  typePath = type + "/"
  typeOdd = type.slice(0, -1)
  for name in list
    moduleFileName = name + "_" + typeOdd
    modulePath = typePath + moduleFileName
    moduleClass = moduleFileName.toPascalCase()
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
    EventHelper        : true
    GameController     : true
    SeedHelper         : true
    BenchmarkHelper    : true

  tag        : "Application"
  config     : require('config/config').config
  router     : MainRouter

  constructor: ->
    LogHelper.verbose = @verbose
    @waitForDeviceReadyEvent()

  waitForDeviceReadyEvent: ->
    $(window).load =>
      # device ready already fired
      if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
        LogHelper.info "device ready already fired", @tag
        @initialize()
      else
        LogHelper.info "waiting for device response", @tag
        document.addEventListener "deviceready", =>
          @onDeviceReady()
        , false

  onDeviceReady: ->
    LogHelper.info "on device ready", @tag
    $ =>
      LogHelper.info "on dom ready", @tag
      @initialize()

  onDatabaseReady: ->
    if window.onDatabaseReady?
      return window.onDatabaseReady()

    LogHelper.info "on database ready", @tag

    FileSystemHelper.init =>
      LogHelper.info "on filesystem init success", @tag

      SeedHelper.seed (seeded) =>
        message = if seeded then "on seed complete" else "didn't need to seed"
        LogHelper.info(message, @tag)

        # temp workaround for dismissing splash once the home is loaded
        if navigator? and navigator.splashscreen?
          @router.onFirstRoute = =>
            setTimeout =>
              LogHelper.info "hide splashscreen", @tag
              navigator.splashscreen.hide()
            , 2000

        LogHelper.info "initialize router", @tag

        # router
        @router.init()
        # fix for .init("/home") ("#/home" fired twice)\
        @router.setRoute(@router.getHomeRoute()) if @router.getRoute()[0] is ""
      , =>
        LogHelper.info "on seed fail", @tag
    , ->
      LogHelper.info "on filesystem init fail", @tag

  initialize: ->
    LocaleHelper.setConfig(ConfigHelper.getLocales())
      .setLocale(DeviceHelper.getLocalization()) # override default locale by user localization setting

    DynamicScreenHelper.initialize ConfigHelper.getDynamicScreen()

    if DeviceHelper.isMobile()
      activateFastClicks()
      EventHelper.disableScroll()

    DeviceHelper.getAnimationGrade =>

      # wait for database
      DbHelper.createPASHDatabase => @onDatabaseReady()

window.app = new exports.Application()
