app.models.DifferencePointModel = require('models/difference_point_model').DifferencePointModel

class exports.DifferencePointCollection extends Backbone.Collection
	model: app.models.DifferencePointModel
