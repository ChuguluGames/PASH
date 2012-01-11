app.models.ItemModel = require('models/item_model').ItemModel

class exports.ItemsCollection extends Backbone.Collection
	model: app.models.ItemModel
