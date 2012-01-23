helper = {}

helper.getBaseUrl = ->
  app.config[window.env].base_url

helper.getAssetsBaseUrl = ->
  helper.getBaseUrl()

helper.getTagsUrl = ->
  locale = app.helpers.locale.getLocale()
  helper.getBaseUrl() + '/' + locale + '/tags.js'

helper.getPacksUrl = ->
  locale = app.helpers.locale.getLocale()
  helper.getBaseUrl() + '/' + locale + '/packs.js'

helper.getItemsUrlForPackIdentity = (packIdentity) ->
  locale = app.helpers.locale.getLocale()
  helper.getBaseUrl() + '/' + locale + '/packs/' + packIdentity + '/items.js'

helper.getItemsUrlForPack = (pack) ->
  helper.getItemsUrlForPackIdentity pack.identity

helper.getDatabaseName = ->
  app.config[window.env].database

exports.ConfigHelper = helper
