class exports.ChallengeGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new ChallengeSpotsEngine(self, lastGame)

	## delegate
	timeDidChange: (time) -> console.log "timeDidChange"

	timeBonus: (bonus, time) -> console.log "timeBonus"

	timePenalty: (penalty, time) -> console.log "timePenalty"

	## score
	scoreDidChange: (score) -> console.log "scoreDidChange"

	scoreBonus: (bonus, score) -> console.log "scoreBonus"

	scorePenalty: (penalty, score) -> console.log "scorePenalty"

	didFindAllDifferences: ->
		console.log "found everything, a winner is you, kthx"

	timeOut: -> console.log "timeOut"
	## delegate