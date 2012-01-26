class exports.EventHelper
	self=@

	self.disableScroll = ->
		document.ontouchstart = (e) -> e.preventDefault()
