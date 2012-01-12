class exports.ItemModel extends Backbone.Model
	name: "item"

	defaults:
		first_image_url:	""
		second_image_url:	""
		differences:			[]

	table:
		first_image_url: "TEXT"
		second_image_url: "TEXT"

	has_many:	["differences"]

	initialize: (attributes) ->
		@