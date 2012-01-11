class exports.PackModel extends Backbone.Model
	defaults:
		position:			0
		name:				""
		description_text:	""
		preview_image_url:	""
		cover_image_url:	""
		state:				1
		tags:				[]

	initialize: (attributes) ->
		@