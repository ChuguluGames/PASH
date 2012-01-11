app.models.DifferenceModel = require('models/difference_model').DifferenceModel

class exports.DifferencesCollection extends Backbone.Collection
	model: app.models.DifferenceModel
