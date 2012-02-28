class exports.OptionsView extends View
	attributes:
		id: 'options-view'
	template: require 'templates/options'

	render: ->
		$(@el).html TemplateHelper.generate @template
		@