class exports.LocaleHelper
	@tag     = "LocaleHelper"
	@locales = null
	@locale  = null
	@strings = {}

	@setConfig = (config) ->
		@setLocales(config.accepted)
		@setLocale(config.default)
		@

	@setLocales = (locales) ->
		@locales = locales

	@setLocale = (locale) ->
		if @locale isnt locale and $.inArray(locale, @locales) isnt -1
			@locale = locale
			@strings = ConfigHelper.getLocaleStrings(locale)

		@locale

	@getLocale = ->
	  @locale

	@getStrings = ->
		@strings