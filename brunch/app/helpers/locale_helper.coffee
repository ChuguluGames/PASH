class exports.LocaleHelper
	self=@

	self.locales = null
	self.locale = null
	self.strings = {}

	self.setConfig = (config) ->
		self.setLocales(config.accepted)
		self.setLocale(config.default)
		self

	self.setLocales = (locales) ->
		self.locales = locales

	self.setLocale = (locale) ->
		if self.locale isnt locale and $.inArray(locale, self.locales) isnt -1
			self.locale = locale
			self.strings = app.helpers.config.getLocaleStrings(locale)

		self.locale

	self.getLocale = ->
	  self.locale

	self.getStrings = ->
		self.strings