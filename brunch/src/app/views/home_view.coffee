homeTemplate = require('templates/home')
ItemModel 				= require('models/item_model').ItemModel
DifferenceModel 				= require('models/difference_model').DifferenceModel
DifferencesCollection 				= require('collections/differences_collection').DifferencesCollection

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate()

		item = new ItemModel({
			first_image_url: "lolo1.jpg"
			second_image_url: "lolo2.jpg"
			differences: new DifferencesCollection()
		})

		difference = new DifferenceModel(item: item)

		difference.set({item: item});
		item.get("differences").add(difference)

		item.save (item) ->
			console.log item
		, null, true

		item.set({first_image_url: "heho"});

		item.save()
		@