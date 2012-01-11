app.models.TagModel = require('models/tag_model').TagModel

class exports.TagsCollection extends Backbone.Collection
	model: app.models.TagModel
