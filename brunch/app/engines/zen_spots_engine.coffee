class exports.ZenSpotsEngine extends SpotsEngine
  constructor: (delegate, json) ->
    super(ConfigHelper.getSpotsModes().ZEN, delegate, json)