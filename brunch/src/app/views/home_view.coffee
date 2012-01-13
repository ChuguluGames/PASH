homeTemplate = require('templates/home')

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate()
		item = new ItemModel({
			identity        : 42
			first_image_url : "lolo42.jpg"
			second_image_url: "lolo2.jpg"
		})
		image = new ImageModel
			url : "http://google.com/proute.jpg"
			path: "/root/proute"

		app.helpers.db.save item, -> console.log "bsdsdfdsf"
		item = null
		ItemModel.all().limit(1).one null, (o) ->
			return if !o?
			console.log o.first_image_url
			o.first_image  = image
			o.second_image = image
			app.helpers.db.save o, -> console.log "flushed"

#		some_diff = new DifferenceModel()
#		other_diff = new DifferenceModel()
#		item.differences.add(some_diff)
#		item.differences.add(other_diff)
		@
