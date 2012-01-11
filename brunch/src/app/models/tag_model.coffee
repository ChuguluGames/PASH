class exports.TagModel extends Backbone.Model
	defaults:
		position: 	0
		name: 		"some tag"
		packs: 		[]

	initialize: (attributes) ->
		@