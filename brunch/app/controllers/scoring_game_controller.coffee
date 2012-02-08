class exports.ScoringGameController extends GameController

	## delegate
	## time
	timeDidChange: (time) -> @view.topbar.timer.update(timeLeft: time)

	timeBonus: (bonus, time) -> @view.topbar.timer.update(timeLeft: time)

	timePenalty: (penalty, time) -> @view.topbar.timer.update(timeLeft: time)

	## score
	scoreDidChange: (score) -> @view.topbar.score.update(scoreValue: score)

	scoreBonus: (bonus, score) -> @view.topbar.score.update(scoreValue: score, scoreEvent: bonus)

	scorePenalty: (penalty, score) -> @view.topbar.score.update(scoreValue: score, scoreEvent: penalty)


	## game over
	timeOut: -> console.log "timeOut"
	## delegate