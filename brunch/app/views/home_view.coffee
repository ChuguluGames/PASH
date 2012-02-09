class exports.HomeView extends View
	id      : 'home-view'
	template: require 'templates/home'

	render: ->
		$(@el).html TemplateHelper.generate @template
		@