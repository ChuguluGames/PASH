# table definition
TagDefinition = persistence.define 'tag',
  identity: "INT"
  position: "INT"
  name:     "TEXT"

TagDefinition.index ['identity'], {unique: true}

# relations
# TagDefinition.hasMany('packs', PackModel, 'tags')

# custom methods
# TagDefinition.fetchSelected = ->
# TagDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# custom mapping
TagDefinition.fromJSON = (json) ->
  new TagDefinition((if json.tag? then json.tag else json))

# making it visible outside as Model
exports.TagModel = TagDefinition
