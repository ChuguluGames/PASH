class exports.GameView extends View
	id: 						'game-view'
	template: 			require 'templates/game'
	hideErrorAfter: 1000 # hide after xx milliseconds
	firstImage: 		null
	secondImage: 		null

	render: (data) ->
		self=@

		$(self.el).html self.template
			item: 			data.item
			next: 			data.nextItem
			mode: 			data.mode
			score: 			data.score
		self

	addItemImages: (item) ->
		@firstImage = $(".first-image", self.el).css(backgroundImage: "url(" + item.first_image_url + ")")
		@secondImage = $(".second-image", self.el).css(backgroundImage: "url(" + item.second_image_url + ")")

	showDifference: (difference)->
		self=@
		differenceElement = $("<div />").addClass("difference").css(
			left: difference.position.x + "px"
			top: difference.position.y + "px"
			width: difference.dimensions.width + "px"
			height: difference.dimensions.height + "px"
		)
		differenceElementClone = differenceElement.clone()
		@firstImage.append(differenceElement)
		@secondImage.append(differenceElementClone)

	showError: (error)->
		self=@
		errorElement = $("<div />").addClass("error").css(
			left: error.position.x + "px"
			top: error.position.y + "px"
			width: error.dimensions.width + "px"
			height: error.dimensions.height + "px"
		)
		errorElementClone = errorElement.clone()
		@firstImage.append(errorElement)
		@secondImage.append(errorElementClone)

		errorElement.add(errorElementClone).fadeOut self.hideErrorAfter, ->
			$(@this).remove()

	hideLoading: ->
		self=@
		$(".item-loading", self.el).hide()

	showLoading: ->
		self=@
		$(".item-loading", self.el).show()