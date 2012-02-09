class exports.EventHelper
	@tag = "EventHelper"

	@disableScroll = ->
		document.ontouchstart = (e) -> e.preventDefault()
