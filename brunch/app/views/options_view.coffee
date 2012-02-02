class exports.OptionsView extends View
	id      : 'options-view'
	template: require 'templates/options'

	render: ->
		self=@
		$(self.el).html app.helpers.template.generate self.template
		self