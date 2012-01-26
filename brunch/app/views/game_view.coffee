class exports.GameView extends View
	id            : 'game-view'
	template      : require 'templates/game'
	hideErrorAfter: 1000 # hide after xx milliseconds
	elements      : {}
	differencesIndicator:
		fadeInSpeed: 700
		delayBetweenAppearance: 300

	render: (data) ->
		self=@

		$(self.el).html self.template

		self.elements.links                     = $(".topbar .back a, .topbar .button-next-item a", self.el)
		self.elements.firstImage                = $(".first-image", self.el)
		self.elements.secondImage               = $(".second-image", self.el)
		self.elements.differencesFoundIndicator = $(".differences-status ul", self.el)
		self.elements.scoreValue                = $(".score-value", self.el)
		self.elements.nextItemLink              = $(".button-next-item a", self.el)
		self.elements.loading                   = $(".item-loading", self.el)

		self.update data

		self

	update: (data) ->
		self=@
		self.updateItem(data.item) if data.item?
		self.updateNext(data.next) if data.next?
		self.updateScore(data.score) if data.score?
		self.updateDifferencesFoundIndicator(data.differencesFoundNumber) if data.differencesFoundNumber?
		self

	updateNext: (nextRoute) ->
		self=@
		self.elements.nextItemLink.attr("href", nextRoute).parent().show()

	updateScore: (score) ->
		self=@
		self.elements.scoreValue.html score

	updateItem: (item) ->
		self=@
		console.log item.first_image.getSrc()
		# update the images
		self.elements.firstImage.css(backgroundImage: "url(" + item.first_image.getSrc() + ")")
		self.elements.secondImage.css(backgroundImage: "url(" + item.second_image.getSrc() + ")")

	reset: ->
		self=@
		self.resetDifferencesFoundIndicator()
		self.removeDifferencesElements()
		self

	initializeDifferencesFoundIndicator: (differences, activatedNumber) ->
		self=@
		indicator = self.elements.differencesFoundIndicator.empty() # empty the indicator container

		for n in [0..differences.length - 1]
			li = $("<li />").appendTo(indicator)
			li.addClass("found") if n < activatedNumber
			li.delay(n * self.differencesIndicator.delayBetweenAppearance)
				.fadeIn(self.differencesIndicator.fadeInSpeed)

	updateDifferencesFoundIndicator: (differencesFoundNumber) ->
		self=@
		# activate the indicator with an index inferior at the number
		$("li:lt(" + differencesFoundNumber + ")", self.elements.differencesFoundIndicator).addClass("found")
		self

	resetDifferencesFoundIndicator: ->
		self=@
		self.elements.differencesFoundIndicator.empty()

	showDifference: (differenceRectangle) ->
		self=@
		differenceElement = $("<div />").addClass("difference").css(
			left  : differenceRectangle.position.x + "px"
			top   : differenceRectangle.position.y + "px"
			width : differenceRectangle.dimensions.width + "px"
			height: differenceRectangle.dimensions.height + "px"
		)
		differenceElementClone = differenceElement.clone()
		self.elements.firstImage.append(differenceElement)
		self.elements.secondImage.append(differenceElementClone)
		self

	removeDifferencesElements: ->
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

	disableLinks: ->
		self=@
		self.elements.links.add(self.elements.links.parent()).addClass("disabled")
		self

	enableLinks: ->
		self=@
		self.elements.links.add(self.elements.links.parent()).removeClass("disabled")
		self

	hideLoading: ->
		self=@
		self.elements.loading.hide()
		self

	showLoading: ->
		self=@
		self.elements.loading.show()
		self