class exports.TemplateHelper
	# dependencies: LocaleHelper
	@tag = "SeedHelper"

	@generate = (template, data) ->
		templateVars = {
			routes : app.router.getRoutes()
			strings: LocaleHelper.getStrings()
		}

		data = if typeof data isnt "undefined" then $.extend(templateVars, data) else templateVars

		template data
