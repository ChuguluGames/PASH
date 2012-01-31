class exports.SpotsEngine
  score : 0
  time  : 0
  mode  : null
  config: {}

  constructor: ->
    self=@

  # reset counters while keeping the same game mode (ex: restart the game in the same mode)
  reset: ->
    self=@
    self.score = 0
    self.time  = 0

  setMode: (mode) ->
    self=@
    self.mode   = mode
    self.config = app.spots_config[mode]

  # restart the game with different mode
  configureForMode: (mode) ->
    self=@
    self.setMode(mode)
    self.reset()

