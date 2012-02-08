class exports.SurvivalSpotsEngine extends ScoringSpotsEngine
  level : 0

  constructor: (delegate, json) ->
    super(app.helpers.config.getSpotsModes().SURVIVAL, delegate, json)

  reset: ->
    super
    @time  = 0
    @level = 0
    @timer.reset()

  didFindDifference: (difference) ->
    super
    if @timeSinceLastSpot <= @config.spot_speed_bonus_time_delta
      @comboCount++
      @timeSinceLastSpot = 0
    else
      @comboCount = 0
    bonus  = SurvivalSpotsEngine.getClosestObjectInConfig @config.spot_speed_bonus_multiplier, @comboCount
    bonus  *= @config.points_per_difference
    @score += bonus
    @delegateScoreBonus(bonus)

  didNotFindDifference: ->
    super
    penalty = SurvivalSpotsEngine.getClosestObjectInConfig @config.time_penalty_per_error, @errorCount
    if @time >= penalty
      @time -= penalty
      @delegateTimePenalty(penalty)
    else
      @time = 0
    @timer.setTimeLeft @time

  itemStarted: (differences) ->
    super
    @level++
    limit      = SurvivalSpotsEngine.getClosestObjectInConfig @config.difficulty_per_item, @level
    @clueCount = limit.clues
    @time      = limit.time
    @timer.setTimeLeft @time
    @delegateTimeDidChange()
    @timer.resume()

  itemFinished: ->
    @timer.pause()
    bonus  = @config.final_score_clues_left_multiplier * @clueCount + @config.final_score_time_left_multiplier * @time
    @score += bonus
    @delegateScoreDidChange()
    super
