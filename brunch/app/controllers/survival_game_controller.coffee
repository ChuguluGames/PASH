class exports.SurvivalGameController extends GameController

	initializeEngine: (lastGame) ->
		self=@
		self.engine = new SurvivalSpotsEngine(self, lastGame)

	## delegate
	timeDidChange: (time) -> console.log "timeDidChange"

	timeBonus: (bonus, time) -> console.log "timeBonus"

	timePenalty: (penalty, time) -> console.log "timePenalty"

	## score
	scoreDidChange: (score) -> console.log "scoreDidChange"

	scoreBonus: (bonus, score) -> console.log "scoreBonus"

	scorePenalty: (penalty, score) -> console.log "scorePenalty"

	## clues
	didUseClue: (difference, clueCount, differenceCount) -> console.log "didUseClue"

	timeOut: -> console.log "timeOut"
	## delegate