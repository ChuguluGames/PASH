window.requireModule = (type, name) ->
  typePluralized = type.pluralize()
  splittedName = name.split "."
  moduleFileName = splittedName[0] + "_" + type
  modulePath = typePluralized + "/" + moduleFileName
  moduleClass = (splittedName.join("_") + "_" + type).toPascalCase()
  window[moduleClass] = require(modulePath)[moduleClass]

window.app = {}

class exports.Application
  modules:
    factories: [
      'popup'
      'popup.tuto'
      'popup.timeout'
      'popup.pause'
      'popup.finish'
    ]
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
      'popup'
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
      'pack'
      'item'
      'image'
      'difference'
      'difference_point'
      'player'
      'tag'
    ]
    engines: [
      'spots'
      'scoring_spots'
      'challenge_spots'
      'survival_spots'
      'zen_spots'
    ]

  verbose:
    Application        : true
    MainRouter         : true
    DeviceHelper       : true
    DbHelper           : true
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
  router     : null

  constructor: ->
    @loadModules()
    @loadModelsRelationships()

    LogHelper.verbose = @verbose
    @router = MainRouter

    @waitForDeviceReadyEvent()

  loadModules: ->
    for type, list of @modules
      typeSingularized = type.singularize()

      for name in list
        requireModule typeSingularized, name

  loadModelsRelationships: ->
    require('models/relationships')
    @

  waitForDeviceReadyEvent: ->
    $(window).load =>
      # device ready already fired
      if PhoneGap? and PhoneGap.onDeviceReady? && PhoneGap.onDeviceReady.fired == true
        LogHelper.info "device ready already fired", @tag
        @onDeviceReady()
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

  initialize: ->
    LocaleHelper.setConfig(ConfigHelper.getLocales())
      .setLocale(DeviceHelper.getLocalization()) # override default locale by user localization setting
    DynamicScreenHelper.initialize ConfigHelper.getDynamicScreen()

    if DeviceHelper.isMobile()
      activateFastClicks()
      EventHelper.disableScroll()

    DeviceHelper.getAnimationGrade (grade) =>

      LogHelper.info "animation grade received: " +  grade, @tag

      # wait for database
      DbHelper.createPASHDatabase => @onDatabaseReady()

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

window.app = new exports.Application()
