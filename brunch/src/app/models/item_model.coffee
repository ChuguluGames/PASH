# table definition
ItemDefinition = persistence.define 'item',
	identity:					"INT"
	first_image_url:	"TEXT"
	second_image_url: "TEXT"

# relations
#ItemDefinition.hasMany('differences', DifferenceModel, 'item')
#ItemDefinition.hasOne('first_image', ImageModel, null)
#ItemDefinition.hasOne('second_image', ImageModel, null)

# custom methods
#ItemDefinition.fetchSelected = ->
#	ItemDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# making it visible outside as Model
exports.ItemModel = ItemDefinition