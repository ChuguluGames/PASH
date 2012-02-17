# table definition
PlayerDefinition = persistence.define 'player',
  identity: "INT"

PlayerDefinition.index ['identity'], {unique: true}

PlayerDefinition.getPlayer = ->
	new PlayerDefinition(identity: 450)

exports.PlayerModel = PlayerDefinition