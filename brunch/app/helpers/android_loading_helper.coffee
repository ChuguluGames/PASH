class exports.AndroidLoadingHelper
	self=@

	self.elements =
		loading: null
		points : null

	self.currentPoints       = 3
	self.maxPoints           = 3
	self.timer               = null
	self.frequence           = 200
	self.pointFadeInDuration = 200

	self.animationsActivated = false

	self.setLoading = (loading) ->
		self=@
		self.elements =
			loading: loading.addClass("android")
			points : loading.find(".points")

	self.start = ->
		self=@

		self.stop().reset(self.update)

	self.update = ->
		self.timer = setTimeout ->
			if self.currentPoints < self.maxPoints then self.addPoint(self.update) else self.reset(self.update, true)
		, self.frequence

	self.reset = (callback, fadeOut) ->
		self=@
		if fadeOut? and fadeOut and self.animationsActivated
			self.elements.points.fadeOut(self.frequence, -> self.reset(callback))
		else
			self.elements.points.empty().show()
			self.currentPoints = 0
			callback()

	self.addPoint = (callback) ->
		self=@
		point = $("<span />").html(".")
		self.elements.points.append(point)

		if self.animationsActivated
			point.animate
				opacity: 1
			, {
				duration: self.pointFadeInDuration
				complete: ->
					callback()
			}

		else
			point.css("opacity", 1)
			callback()

		self.currentPoints++

	self.stop = ->
		self=@
		clearTimeout self.timer if self.timer?
		self