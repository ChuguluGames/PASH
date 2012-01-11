class exports.ItemModel extends Backbone.Model
	defaults:
		first_image_url:	""
		second_image_url:	""
		differences:		[]

	initialize: (attributes) ->
		@