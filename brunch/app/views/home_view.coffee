class exports.HomeView extends View
	id      : 'home-view'
	template: require 'templates/home'

	render: ->
		self=@

		console.log app.helpers.template.generate

		$(self.el).html app.helpers.template.generate self.template, {
			gameRoute: app.router.getGameRoute
		}
		$('#seed-btn', self.el).on 'click', (evt) ->
				btn=@
				btn.textContent = 'seeding...'
				btn.disabled = true
				app.helpers.model_downloader.getAll ->
						btn.textContent = 'seeded!'
		self