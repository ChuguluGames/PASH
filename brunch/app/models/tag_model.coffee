# table definition
TagDefinition = persistence.define 'tag',
	identity: "INT"
	position: "INT"
	name:     "TEXT"

TagDefinition.index ['identity'], {unique: true}

# custom mapping
TagDefinition.fromJSON = (json) ->
  new TagDefinition((if json.tag? then json.tag else json))

exports.TagModel = TagDefinition