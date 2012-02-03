class exports.SurvivalSpotsEngine extends SpotsEngine
  level : 0

  constructor: (delegate, json) ->
    super(app.helpers.config.getSpotsModes().SURVIVAL, delegate, json)

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
    if @time >= penalty
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
