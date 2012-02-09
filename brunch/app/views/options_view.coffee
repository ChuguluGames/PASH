class exports.OptionsView extends View
	id      : 'options-view'
	template: require 'templates/options'

	render: ->
		$(@el).html TemplateHelper.generate @template
		@