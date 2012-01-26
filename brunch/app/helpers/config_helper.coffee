class exports.ConfigHelper
  self=@

  self.getBaseUrl = ->
    app.config[window.env].base_url

  self.getAssetsBaseUrl = ->
    self.getBaseUrl()

  self.getTagsUrl = ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/tags.js'

  self.getPacksUrl = ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/packs.js'

  self.getItemsUrlForPackIdentity = (packIdentity) ->
    locale = app.helpers.locale.getLocale()
    self.getBaseUrl() + '/' + locale + '/packs/' + packIdentity + '/items.js'

  self.getItemsUrlForPack = (pack) ->
    self.getItemsUrlForPackIdentity pack.identity

  self.getDatabaseName = ->
    app.config[window.env].database