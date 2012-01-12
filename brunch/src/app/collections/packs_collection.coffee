app.models.PackModel = require('models/pack_model').PackModel

class exports.PacksCollection extends Backbone.Collection
	model: app.models.PackModel
	store: localDatabase.getInstance("pash").getTable("pack", [
      '"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT',
      '"name" INTEGER NOT NULL"'
    ]),