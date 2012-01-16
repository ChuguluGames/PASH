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

# relations
#PackDefinition.hasMany('tags', TagModel, 'packs')
#PackDefinition.hasMany('players', PlayerModel, 'packs')
#PackDefinition.hasOne('preview_image', ImageModel, null)
#PackDefinition.hasOne('cover_image', ImageModel, null)

# custom methods/vars
PackDefinition.STATE_AVAILABLE     = 0
PackDefinition.STATE_INCOMPLETE    = 3
PackDefinition.STATE_READY_TO_PLAY = 4
PackDefinition.STATE_SELECTED      = 5

PackDefinition.fetchSelected = ->
  PackDefinition.all().filter("state", '=', PackDefinition.STATE_SELECTED)

# making it visible outside as Model
exports.PackModel = PackDefinition
