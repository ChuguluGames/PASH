# table definition
PlayerDefinition = persistence.define 'player',
  identity: "INT"

PlayerDefinition.index ['identity'], {unique: true}

# relations
# PlayerDefinition.hasMany('packs', PackModel, 'players')

# custom methods
# ItemDefinition.fetchSelected = ->
# ItemDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# making it visible outside as Model
exports.PlayerModel = PlayerDefinition