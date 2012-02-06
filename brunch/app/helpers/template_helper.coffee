class exports.TemplateHelper
	self=@

	self.generate = (template, data) ->
		templateVars = {
			routes : app.router.getRoutes()
			strings: app.helpers.locale.getStrings()
		}

		data = if typeof data isnt "undefined" then $.extend(templateVars, data) else templateVars

		template data
