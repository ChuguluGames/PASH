homeTemplate = require('templates/home')

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate()

		window.plugins.Downloader.downloadPack pack: 1
		, (response) ->
			$(self.el).append '<img src="' + response.path + '" />'
		, (error) ->
			alert "error"

		self