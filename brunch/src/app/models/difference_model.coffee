class exports.DifferenceModel extends Backbone.Model
	name: "difference"

	defaults:
		point_diffs:	[]
		item: null

	table: {}

	initialize: (attributes) ->
		@