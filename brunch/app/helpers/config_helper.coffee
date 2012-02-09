class exports.ConfigHelper
  # dependencies: LocaleHelper

  @tag = "ConfigHelper"

  @getBaseUrl = ->
    app.config[window.env].base_url

  @getLocales = ->
    app.config.locales

  @getLocaleStrings = (locale) ->
    require "config/locales/" + locale

  @getAssetsBaseUrl = ->
    @getBaseUrl()

  @getDynamicScreen = ->
    app.config.dynamic_screen

  @getTagsUrl = ->
    locale = LocaleHelper.getLocale()
    @getBaseUrl() + '/' + locale + '/tags.js'

  @getTagsLocalSeedUrl = ->
    locale = LocaleHelper.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/tags.json'

  @getPacksUrl = ->
    locale = LocaleHelper.getLocale()
    @getBaseUrl() + '/' + locale + '/packs.js'

  @getPacksLocalSeedUrl = ->
    locale = LocaleHelper.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/packs.json'

  @getItemsUrlForPackIdentity = (packIdentity) ->
    locale = LocaleHelper.getLocale()
    @getBaseUrl() + '/' + locale + '/packs/' + packIdentity + '/items.js'

  @getItemsUrlForPack = (pack) ->
    @getItemsUrlForPackIdentity pack.identity

  @getItemsLocalSeedUrlForPackIdentity = (packIdentity) ->
    locale = LocaleHelper.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/packs/' + packIdentity + '/items.json'

  @getItemsLocalSeedUrlForPack = (pack) ->
    @getItemsLocalSeedUrlForPackIdentity pack.identity

  @getDatabaseName = ->
    app.config[window.env].database

  @getBasePackIds = ->
    app.config[window.env].base_pack_ids

  @getSpotsModes = ->
    app.config.spots_modes