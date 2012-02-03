class exports.ZenSpotsEngine extends SpotsEngine
  constructor: (delegate, json) ->
    super(app.helpers.config.getSpotsModes().ZEN, delegate, json)