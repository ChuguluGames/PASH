SpotsMode =
  ZEN       : 'zen'
  CHALLENGE : 'challenge'
  SURVIVAL  : 'survival'

class SpotsEngine
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
    @didNotFindDifference()

  didFindDifference: (difference) ->
    @errorCount        = 0
    difference.isFound = true
    @delegateDidFindDifference(difference)
    @differenceCount-- if @differenceCount > 0
    @itemFinished() if @differenceCount < 1

  didNotFindDifference: ->
    @errorCount++
    @comboCount        = 0
    @timeSinceLastSpot = 0

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
    console.log(@delegate)
    @delegate.didFindDifference(difference, @differenceCount) if @delegate? and @delegate.didFindDifference?

  ## game over
  delegateDidFinishItem: ->
    @delegate.didFinishItem() if @delegate? and @delegate.didFinishItem?

  delegateTimeOut: ->
    @delegate.timeOut() if @delegate? and @delegate.timeOut?

  # config helper method
  getClosestObjectInConfig: (config, someValue) ->
    closestObject = null
    difference = -1
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

class exports.ZenSpotsEngine extends SpotsEngine
  constructor: (delegate, json) ->
    super(SpotsMode.ZEN, delegate, json)

class exports.SurvivalSpotsEngine extends SpotsEngine
  level : 0

  constructor: (delegate, json) ->
    super(SpotsMode.SURVIVAL, delegate, json)

  reset: ->
    super
    @time  = 0
    @level = 0

  pause: ->
    super

  resume: ->
    super

  tick: ->
    super
    @delegateTimeOut() if @time < 1

  useClue: ->
    super

  didFindDifference: (difference) ->
    super
    if @timeSinceLastSpot <= @config.spot_speed_bonus_time_delta
      @comboCount++
      @timeSinceLastSpot = 0
    else
      @comboCount = 0
    bonus  = @getClosestObjectInConfig @config.spot_speed_bonus_multiplier, @comboCount
    bonus  *= @config.points_per_difference
    @score += bonus
    @delegateScoreBonus(bonus)

  didNotFindDifference: ->
    super
    penalty = @getClosestObjectInConfig @config.time_penalty_per_error, @errorCount
    if @time > penalty
      @time -= penalty
      @delegateTimePenalty(penalty)
    else
      @time = 0
    #@delegateTimeOut() if @time < 1

  itemStarted: (differences) ->
    super
    @level++
    limit      = @getClosestObjectInConfig @config.difficulty_per_item, @level
    @clueCount = limit.clues
    @time      = limit.time

  itemFinished: ->
    bonus  = @config.final_score_clues_left_multiplier * @clueCount + @config.final_score_time_left_multiplier * @time
    @score += bonus
    @delegateScoreDidChange()
    super



class exports.ChallengeSpotsEngine extends SpotsEngine
  totalDifferencesToFind : 0

  constructor: (delegate, json) ->
    super(SpotsMode.CHALLENGE, delegate, json)

  reset: ->
    super
    @time                   = @config.time_limit
    @totalDifferencesToFind = @config.differences_to_find

  pause: ->
    super

  resume: ->
    super

  tick: ->
    super
    @delegateTimeOut() if @time < 1

  useClue: ->
    super
    penalty = @config.clue_penalty_points
    if penalty < @score
      @score -= penalty
      @delegateScorePenalty(penalty)
    else
      @score = 0

  didFindDifference: (difference) ->
    super
    @totalDifferencesToFind-- if @totalDifferencesToFind > 0
    if @timeSinceLastSpot <= @config.spot_speed_bonus_time_delta
      @comboCount++
      @timeSinceLastSpot = 0
    else
      @comboCount = 0
    bonus  = @getClosestObjectInConfig @config.spot_speed_bonus_multiplier, @comboCount
    bonus  *= @config.points_per_difference
    @score += bonus
    @delegateScoreBonus(bonus)

  didNotFindDifference: ->
    super
    penalty = @getClosestObjectInConfig @config.time_penalty_per_error, @errorCount
    if @time > penalty
      @time -= penalty
      @delegateTimePenalty(penalty)
    else
      @time = 0
    #@delegateTimeOut() if @time < 1

  itemStarted: (differences) ->
    super
    @clueCount = differences.length

  itemFinished: ->
    bonusObject = @getClosestObjectInConfig @config.bonus_per_unused_clue, @clueCount
    scoreBonus  = bonusObject.points
    if @totalDifferencesToFind < 1 # did finish the game
      scoreBonus += @config.final_score_time_left_multiplier * @time
    @score += scoreBonus
    @time  += bonusObject.time
    @delegateTimeDidChange()
    @delegateScoreDidChange()
    if @totalDifferencesToFind < 1
      @delegateDidFindAllDifferences()
    else
      super # if game is not over, call parent method which notifies delegate about finished item

  delegateDidFindAllDifferences: ->
    @delegate.didFindAllDifferences() if @delegate? and @delegate.didFindAllDifferences?


