# table definition
ItemDefinition = persistence.define 'item',
	identity        :	"INT"
	first_image_url :	"TEXT"
	second_image_url: "TEXT"

# indexes
ItemDefinition.index ['identity'], {unique: true}

# relations
# ItemDefinition.hasMany('differences', DifferenceModel, 'item')
# ItemDefinition.hasOne('first_image', ImageModel, null)
# ItemDefinition.hasOne('second_image', ImageModel, null)

ItemDefinition::differencesArray = null

ItemDefinition::fetchAll = (callback) ->
	self=@
	self.fetch 'first_image', (firstImage) ->
			self.fetch 'second_image', (secondImage) ->
					self.differences.list (differences) ->
						pointFetchCount = differences.length
						alert "no differences for item " + self.identity if pointFetchCount == 0
						callback(self) if callback? and pointFetchCount == 0
						self.differencesArray = []
						for difference in differences
							do (difference) ->
								difference.fetchPoints (points) ->
									self.differencesArray.push difference.getSimpleObject()
									if (--pointFetchCount == 0)
										callback(self) if callback?

# custom methods
ItemDefinition.fetchFullItemForIdentity = (identity, callback) ->
	ItemDefinition.findBy 'identity', identity, (item) ->
		item.fetchAll callback

ItemDefinition.fetchSelected = (callback) ->
	PackModel.fetchSelected().list (packs) ->
		packIds = []
		packIds.push pack.id for pack in packs
		ItemDefinition.all().filter("pack", 'in', packIds).list callback

ItemDefinition.fetchSelectedIdentities = (callback) ->
	PackModel.fetchSelected().list (packs) ->
		packIds = []
		packIds.push pack.id for pack in packs
		ItemDefinition.all().filter("pack", 'in', packIds).list (items) ->
			itemIdentities = []
			itemIdentities.push item.identity for item in items
			callback(itemIdentities) if callback?

# custom mapping
ItemDefinition.fromJSON = (json) ->
	json = (if json.item? then json.item else json)
	itemData =
		identity        : json.identity
		first_image_url : json.first_image_url
		second_image_url: json.second_image_url
	item = new ItemDefinition(itemData)
	item.differences.add(DifferenceModel.fromJSON(diff)) for diff in json.differences
	item

# making it visible outside as Model
exports.ItemModel = ItemDefinition