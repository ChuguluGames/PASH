# table definition
PackDefinition = persistence.define 'pack',
  identity: "INT"
  position: "INT"
  state:    "INT"
  name:     "TEXT"
  description_text:   "TEXT"
  cover_image_url:    "TEXT"
  preview_image_url:  "TEXT"
  purchase_date:      "DATE"

PackDefinition.index ['identity'], {unique: true}

# relations
# PackDefinition.hasMany('tags', TagModel, 'packs')
# PackDefinition.hasMany('players', PlayerModel, 'packs')
# PackDefinition.hasOne('preview_image', ImageModel, null)
# PackDefinition.hasOne('cover_image', ImageModel, null)

# custom mapping
PackDefinition.fromJSON = (json, callback) ->
  json = (if json.pack? then json.pack else json)
  pack_data =
    identity         : json.identity
    position         : json.position
    name             : json.name
    description_text : json.description_text
    cover_image_url  : json.cover_image_url
    preview_image_url: json.preview_image_url
    state            : json.state
    purchase_date    : json.purchased_date
  pack = new PackModel(pack_data)
  tagIds = []
  tagIds.push tag.identity for tag in json.tags
  if tagIds.length > 0
    TagModel.all().filter('identity', 'in', tagIds).list null, (tag_list) ->
      pack.tags.add tag for tag in tag_list
      callback(pack) if callback?
  pack

# custom methods/vars
PackDefinition.STATE_AVAILABLE     = 0
PackDefinition.STATE_INCOMPLETE    = 3
PackDefinition.STATE_READY_TO_PLAY = 4
PackDefinition.STATE_SELECTED      = 5

PackDefinition.fetchSelected = ->
  PackDefinition.all().filter("state", '=', PackDefinition.STATE_SELECTED)

# making it visible outside as Model
exports.PackModel = PackDefinition
