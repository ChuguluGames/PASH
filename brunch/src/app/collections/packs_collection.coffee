app.models.PackModel = require('models/pack_model').PackModel

class exports.PacksCollection extends Backbone.Collection
	model: app.models.PackModel
