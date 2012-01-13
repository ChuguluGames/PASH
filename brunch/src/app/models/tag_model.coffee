# table definition
TagDefinition = persistence.define 'tag',
  identity: "INT"
  position: "INT"
  name:     "TEXT"

# relations
#TagDefinition.hasMany('packs', PackModel, 'tags')

# custom methods
#TagDefinition.fetchSelected = ->
#  TagDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# making it visible outside as Model
exports.TagModel = TagDefinition
