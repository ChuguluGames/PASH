String::toCamelCase = ->
	@replace /([A-Z]+)/g, (m, l) ->
		l.substr(0, 1).toUpperCase() + l.toLowerCase().substr(1, l.length)
	@replace /[\-_\s](.)/g, (m, l) ->
		l.toUpperCase()