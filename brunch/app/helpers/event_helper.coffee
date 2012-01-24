helper = {}

helper.disableScroll = ->
  document.ontouchstart = (e) -> e.preventDefault()

exports.EventHelper = helper
