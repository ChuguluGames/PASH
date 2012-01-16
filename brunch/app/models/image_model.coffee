# table definition
ImageDefinition = persistence.define 'image',
  url:  "TEXT"
  path: "TEXT"

# relations

# custom methods
# ItemDefinition.fetchSelected = ->
# ItemDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# making it visible outside as Model
exports.ImageModel = ImageDefinition
