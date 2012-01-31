class exports.LocaleHelper
	self=@

	self.locales = [
		'en'
		'fr'
	]

	self.locale = 'en'

	self.config = {}

	self.setLocale = (locale) ->
		if $.inArray locale, self.locales isnt -1
			self.locale = locale
		self.locale

	self.getLocale = ->
	  self.locale

	self.getLocaleConfig = ->
		locale = self.getLocale()
		if not self.config[locale]?
			self.config[locale] = require "config/locales/" + locale

		self.config[locale]