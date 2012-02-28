class exports.HomeView extends View
	attributes:
		id: 'home-view'
	template: require 'templates/home'

	render: ->
		$(@el).html TemplateHelper.generate @template
		@