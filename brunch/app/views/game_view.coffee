class exports.GameView extends View
	id            : 'game-view'
	template      : require 'templates/game'
	elements      : {}

	differenceElement:
		initialRatio  : 7
		effectDuration: 5000

	errorElement:
		hideAfter: 500
		hideIn   : 500

	differencesIndicator:
		fadeInSpeed: 400
		delayBetweenAppearance: 200

	render: (data) ->
		self=@

		$(self.el).html self.template

		self.elements.links                     = $(".topbar .back a, .topbar .button-next-item a", self.el)
		self.elements.item                      = $(".item", self.el)
		self.elements.firstImage                = $(".first-image", self.el)
		self.elements.secondImage               = $(".second-image", self.el)
		self.elements.differencesFoundIndicator = $(".differences-status ul", self.el)
		self.elements.scoreValue                = $(".score-value div", self.el)
		self.elements.nextItemLink              = $(".button-next-item a", self.el)
		self.elements.loading                   = $(".item-loading", self.el)

		self.setLoadingAndroid() if app.helpers.device.isAndroid()

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

		initialWidth = differenceRectangle.dimensions.width * self.differenceElement.initialRatio
		initialheight = differenceRectangle.dimensions.height * self.differenceElement.initialRatio
		initialLeft = differenceRectangle.position.x + differenceRectangle.dimensions.width / 2 - initialWidth / 2
		initialTop = differenceRectangle.position.y + differenceRectangle.dimensions.height / 2 - initialheight / 2

		console.log initialWidth
		console.log initialTop

		# make the
		differenceElement = $("<div />").addClass("difference").css(
			left  : initialLeft + "px"
			top   : initialTop + "px"
			width : initialWidth + "px"
			height: initialheight + "px"
			"-webkit-transition": "opacity 5000ms ease"
		).appendTo(self.elements.firstImage)

		differenceElementClone = differenceElement.clone().appendTo(self.elements.secondImage)

		differenceElement.add(differenceElementClone).animate {
			opacity: 1
			left   : differenceRectangle.position.x + "px"
			top    : differenceRectangle.position.y + "px"
			width  : differenceRectangle.dimensions.width + "px"
			height : differenceRectangle.dimensions.height + "px"
		}, {
			duration: self.differenceElement.effectDuration
		}

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

		errorElements = errorElement.add(errorElementClone)

		setTimeout(->
			errorElements.animate {
				opacity: "0"
			}, {
				duration: self.errorElement.hideIn
				complete: ->
					# put the left the errors
					errorElements.css({left: -error.dimensions.width + "px"})
					# remove them after a little while...
					setTimeout(->
						errorElements.remove()
					, 10)
			}
		, self.errorElement.hideAfter)

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
		self.stopLoadingAndroid() if app.helpers.device.isAndroid()
		self.elements.loading.hide()
		self.elements.item.show()
		self

	showLoading: ->
		self=@
		self.startLoadingAndroid() if app.helpers.device.isAndroid()
		self.elements.loading.show()
		self.elements.item.hide()
		self

	startLoadingAndroid: ->
		self=@

		self.stopLoadingAndroid()
		self.elements.loadingPoints.html "..."
		self.loadingAndroidCurrentPoints = 3

		self.loadingAndroidTimer = setInterval ->
			console.log self.loadingAndroidCurrentPoints
			if self.loadingAndroidCurrentPoints == 3
				self.elements.loadingPoints.empty()
				self.loadingAndroidCurrentPoints = 0
			else
				self.elements.loadingPoints.append $("<span />").html(".").fadeIn(200)
				self.loadingAndroidCurrentPoints++
		, 250

	stopLoadingAndroid: ->
		self=@
		console.log "stoped"
		clearInterval self.loadingAndroidTimer if self.loadingAndroidTimer?
		self

	setLoadingAndroid: ->
		self=@
		self.elements.loadingPoints = self.elements.loading.find(".points")
		self.elements.loading.addClass("android")
		self