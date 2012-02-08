class exports.ConfigHelper
  self=@

  self.getBaseUrl = ->
    app.config[window.env].base_url

  self.getLocales = ->
    app.config.locales

  self.getLocaleStrings = (locale) ->
    require "config/locales/" + locale

  self.getAssetsBaseUrl = ->
    self.getBaseUrl()

  self.getDynamicScreen = ->
    app.config.dynamic_screen

  self.getTagsUrl = ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/tags.js'

  self.getTagsLocalSeedUrl = ->
    locale = app.helpers.locale.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/tags.json'

  self.getPacksUrl = ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/packs.js'

  self.getPacksLocalSeedUrl = ->
    locale = app.helpers.locale.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/packs.json'

  self.getItemsUrlForPackIdentity = (packIdentity) ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/packs/' + packIdentity + '/items.js'

  self.getItemsUrlForPack = (pack) ->
    self.getItemsUrlForPackIdentity pack.identity

  self.getItemsLocalSeedUrlForPackIdentity = (packIdentity) ->
    locale = app.helpers.locale.getLocale()
    locale = 'en'
    'seed/json/' + locale + '/packs/' + packIdentity + '/items.json'

  self.getItemsLocalSeedUrlForPack = (pack) ->
    self.getItemsLocalSeedUrlForPackIdentity pack.identity

  self.getDatabaseName = ->
    app.config[window.env].database

  self.getBasePackIds = ->
    app.config[window.env].base_pack_ids

  self.getSpotsModes = ->
    app.config.spots_modes