class exports.HomeView extends View
	id: 			'home-view'
	template: require 'templates/home'

	render: ->
		self=@
		$(self.el).html "<img src='file:///data/data/com.phonegap.pash/images/truct/test/zizi/image.png'/>"
		self