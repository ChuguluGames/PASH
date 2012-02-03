class exports.SpotsEngine
  score            : 0
  time             : 0
  timeSinceLastSpot: 0
  clueCount        : 0
  errorCount       : 0
  comboCount       : 0
  differenceCount  : 0
  differences      : []
  mode             : null
  delegate         : null
  config           : {}

  constructor: (@mode, @delegate, json) ->
    if json?
      @fromJSON(json)
    else
      @reset()
    @reloadConfigForCurrentMode()

  reloadConfigForCurrentMode: ->
    @config = require('config/spots_engine_config').config[@mode]

  # reset counters while keeping the same game mode (ex: restart the game in the same mode)
  reset: ->
    @time              = 0
    @score             = 0
    @clueCount         = 0
    @comboCount        = 0
    @errorCount        = 0
    @differences       = []
    @differenceCount   = 0
    @timeSinceLastSpot = 0

  # scheduled method (each second)
  tick: ->
    @time-- if @time > 0
    @timeSinceLastSpot++ if @errorCount < 1

  # unschedule timers
  pause: ->

  # reschedule timers
  resume: ->

  # differences
  useClue: ->
    @timeSinceLastSpot = 0
    @comboCount        = 0
    if @clueCount > 0 and @differenceCount > 0
      @clueCount--
      @differenceCount--
      for difference in @differences # get the first unfound difference
        if not difference.isFound and not difference.isClued
          difference.isClued = true
          @delegateDidUseClue(difference)
          break

  findDifference: (spotCircle) ->
    for difference in @differences
      if not difference.isFound and not difference.isClued
        if app.helpers.collision.circleCollisionToPolygon(spotCircle, difference.differencePointsArray)
          return @didFindDifference(difference)
    @didNotFindDifference(spotCircle)

  didFindDifference: (difference) ->
    @errorCount        = 0
    difference.isFound = true
    @delegateDidFindDifference(difference)
    @differenceCount-- if @differenceCount > 0
    @itemFinished() if @differenceCount < 1

  didNotFindDifference: (spotCircle) ->
    @errorCount++
    @comboCount        = 0
    @timeSinceLastSpot = 0
    @delegateDidNotFindDifference(spotCircle)

  # item
  itemStarted: (differences) ->
    @clueCount         = 0
    @comboCount        = 0
    @errorCount        = 0
    @timeSinceLastSpot = 0
    for difference in differences
      difference.isFound = false
      difference.isClued = false
      app.helpers.polygoner.orderPoints(difference.differencePointsArray)
    @differences       = differences
    @differenceCount   = differences.length

  itemFinished: ->
    @delegateDidFinishItem()

  # delegate
  ## time
  delegateTimeDidChange: ->
    @delegate.timeDidChange @time if @delegate? and @delegate.timeDidChange?

  delegateTimeBonus: (bonus) ->
    @delegate.timeBonus(bonus, @time) if @delegate? and @delegate.timeBonus?

  delegateTimePenalty: (penalty) ->
    @delegate.timePenalty(penalty, @time) if @delegate? and @delegate.timePenalty?

  ## score
  delegateScoreDidChange: ->
    @delegate.scoreDidChange @score if @delegate? and @delegate.scoreDidChange?

  delegateScoreBonus: (bonus) ->
    @delegate.scoreBonus(bonus, @score) if @delegate? and @delegate.scoreBonus?

  delegateScorePenalty: (penalty) ->
    @delegate.scorePenalty(penalty, @score) if @delegate? and @delegate.scorePenalty?

  ## clues
  delegateDidUseClue: (difference) ->
    @delegate.didUseClue(difference, @clueCount, @differenceCount) if @delegate? and @delegate.didUseClue?

  ## difference
  delegateDidFindDifference: (difference) ->
    @delegate.didFindDifference(difference, @differenceCount) if @delegate? and @delegate.didFindDifference?

  delegateDidNotFindDifference: (spotCircle) ->
    @delegate.didNotFindDifference(spotCircle) if @delegate? and @delegate.didNotFindDifference?

  ## game over
  delegateDidFinishItem: ->
    @delegate.didFinishItem() if @delegate? and @delegate.didFinishItem?

  delegateTimeOut: ->
    @delegate.timeOut() if @delegate? and @delegate.timeOut?

  # config helper method
  getClosestObjectInConfig: (config, someValue) ->
    closestObject = null
    difference = -1

    console.log config
    console.log someValue

    for value, object of config
      if value <= someValue or difference < 0
        tmpDifference = someValue - value
        if tmpDifference < difference or difference < 0
          difference    = tmpDifference
          closestObject = object
    closestObject

  # json
  fromJSON: (json) ->
    object = JSON.parse json
    for prop, val of object
      @[prop] = val

  filterObject: (object) ->
    # todo: filter proto properties (ie: hasOwnProperty)
    filtered = {}
    for prop, val of object
      console.log prop
      if typeof val is 'object'
        filtered[prop] = @filterObject(val)
      else if typeof val isnt 'function'
         filtered[prop] = val
    filtered

  toJSON: ->
    filteredObject = @filterObject(@)
    JSON.stringify filteredObject
