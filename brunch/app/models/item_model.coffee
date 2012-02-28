# table definition
ItemDefinition = persistence.define 'item',
	identity        :	"INT"
	first_image_url :	"TEXT"
	second_image_url: "TEXT"

# indexes
ItemDefinition.index ['identity'], {unique: true}

# custom methods
ItemDefinition.fetchFullItemForIdentity = (identity, fetchDifferences, callback) ->
	@findBy 'identity', identity, (item) ->
		# prefetch images
		item.selectJSON ['first_image.*', 'second_image.*'], ->
			if fetchDifferences
				item.fetchDifferences callback
			else callback item

ItemDefinition.fetchSelected = (callback) ->
	PackModel.fetchSelected().list (packs) ->
		@all().filter("pack", 'in', packs).list callback

ItemDefinition.fetchSelectedIdentities = (callback) ->
	PackModel.fetchSelected().list (packs) =>
		@all().filter("pack", 'in', packs).list (items) ->
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

ItemDefinition::differencesArray = null

ItemDefinition::fetchDifferences = (callback) ->
	@differences.list (differences) =>
		differencesCount = differences.length
		return alert("no differences for item " + @identity) if differencesCount == 0

		@differencesArray = []
		for difference in differences
			do (difference) => # keep difference context
				difference.fetchPoints (points) =>
					@differencesArray.push difference.getSimpleObject()
					if (--differencesCount == 0)
						callback @ if callback?

exports.ItemModel = ItemDefinition