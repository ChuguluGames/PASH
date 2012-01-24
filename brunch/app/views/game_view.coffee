class exports.GameView extends View
	id            : 'game-view'
	template      : require 'templates/game'
	hideErrorAfter: 1000 # hide after xx milliseconds
	elements      : {}

	render: (data) ->
		self=@

		$(self.el).html self.template

		self.elements.firstImage        = $(".first-image", self.el)
		self.elements.secondImage       = $(".second-image", self.el)
		self.elements.differencesStatus = $(".differences-status ul", self.el)
		self.elements.scoreValue        = $(".score-value", self.el)
		self.elements.nextItemLink      = $(".button-next-item a", self.el)
		self.elements.loading           = $(".item-loading", self.el)

		self.update data

		self

	update: (data) ->
		self=@
		self.updateItem(data.item) if data.item?
		self.updateNext(data.next) if data.next?
		self.updateScore(data.score) if data.score?
		self

	updateNext: (nextRoute) ->
		self=@
		console.log "updateNext"
		self.elements.nextItemLink.attr("href", nextRoute).parent().show()

	updateScore: (score) ->
		self=@
		console.log "updateScore"
		self.elements.scoreValue.html score

	updateItem: (item) ->
		self=@
		console.log "updateItem"
		# update the images
		self.elements.firstImage.css(backgroundImage: "url(" + item.first_image.getSrc() + ")")
		self.elements.secondImage.css(backgroundImage: "url(" + item.second_image.getSrc() + ")")
		# update the differences
		self.elements.differencesStatus.empty()
		self.elements.differencesStatus.append("<li></li>") for difference in item.differencesArray

	reset: ->
		self=@
		self.resetDifferencesFoundIndicator()
		self.removeDifferenceElements()

	resetDifferencesFoundIndicator: ->
		self=@
		self.elements.differencesStatus.empty()

	showDifferencesFound: (differencesFoundNumber) ->
		self=@
		# activate the indicator with an index inferior at the number
		$("li:lt(" + differencesFoundNumber + ")", self.elements.differencesStatus).addClass("found")

	showDifference: (difference) ->
		self=@
		differenceElement = $("<div />").addClass("difference").css(
			left  : difference.position.x + "px"
			top   : difference.position.y + "px"
			width : difference.dimensions.width + "px"
			height: difference.dimensions.height + "px"
		)
		differenceElementClone = differenceElement.clone()
		self.elements.firstImage.append(differenceElement)
		self.elements.secondImage.append(differenceElementClone)

	removeDifferenceElements: ->
		self=@
		self.elements.firstImage.empty()
		self.elements.secondImage.empty()

	showError: (error)->
		self=@
		errorElement = $("<div />").addClass("error").css(
			left  : error.position.x + "px"
			top   : error.position.y + "px"
			width : error.dimensions.width + "px"
			height: error.dimensions.height + "px"
		)
		errorElementClone = errorElement.clone()
		self.elements.firstImage.append(errorElement)
		self.elements.secondImage.append(errorElementClone)

		errorElement.add(errorElementClone).fadeOut self.hideErrorAfter, ->
			$(@this).remove()

	hideLoading: ->
		self=@
		self.elements.loading.hide()

	showLoading: ->
		self=@
		self.elements.loading.show()