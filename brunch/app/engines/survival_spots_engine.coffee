class exports.SurvivalSpotsEngine extends SpotsEngine
  level : 0

  constructor: (delegate, json) ->
    console.log delegate
    #@timer = new app.helpers.countdown @time, @tick, @delegateTimeOut
    super(app.helpers.config.getSpotsModes().SURVIVAL, delegate, json)

  reset: ->
    super
    @time  = 0
    @level = 0
    @timer.reset()

  pause: ->
    super

  resume: ->
    super

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
    @timer.setTimeLeft(@time)
    #@delegateTimeOut() if @time < 1

  itemStarted: (differences) ->
    super
    @level++
    limit      = @getClosestObjectInConfig @config.difficulty_per_item, @level
    @clueCount = limit.clues
    @time      = limit.time
    @timer.setTimeLeft @time
    @timer.resume()

  itemFinished: ->
    @timer.pause()
    bonus  = @config.final_score_clues_left_multiplier * @clueCount + @config.final_score_time_left_multiplier * @time
    @score += bonus
    @delegateScoreDidChange()
    super
