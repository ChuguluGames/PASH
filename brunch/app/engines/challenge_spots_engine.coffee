class exports.ChallengeSpotsEngine extends SpotsEngine
  totalDifferencesToFind : 0

  constructor: (delegate, json) ->
    #@timer = new app.helpers.countdown @time, @tick, @delegateTimeOut
    super(app.helpers.config.getSpotsModes().CHALLENGE, delegate, json)

  reset: ->
    super
    @time                   = @config.time_limit
    @totalDifferencesToFind = @config.differences_to_find
    @timer.setTimeLeft @time

  pause: ->
    super

  resume: ->
    super

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
    @timer.setTimeLeft @time
    #@delegateTimeOut() if @time < 1

  itemStarted: (differences) ->
    super
    @timer.resume()
    @clueCount = differences.length

  itemFinished: ->
    @timer.pause()
    bonusObject = @getClosestObjectInConfig @config.bonus_per_unused_clue, @clueCount
    scoreBonus  = bonusObject.points
    if @totalDifferencesToFind < 1 # did finish the game
      scoreBonus += @config.final_score_time_left_multiplier * @time
    @score += scoreBonus
    @time  += bonusObject.time
    @timer.setTimeLeft @time
    @delegateTimeDidChange()
    @delegateScoreDidChange()
    if @totalDifferencesToFind < 1
      @delegateDidFindAllDifferences()
    else
      super # if game is not over, call parent method which notifies delegate about finished item

  delegateDidFindAllDifferences: ->
    @delegate.didFindAllDifferences() if @delegate? and @delegate.didFindAllDifferences?