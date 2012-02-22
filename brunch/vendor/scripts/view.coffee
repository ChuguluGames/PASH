root = exports ? this

class root.View extends root.Observable
	attributes: {}
	el        : null
	autoMake  : true
	tag       : "div"

	constructor: (attributes) ->
		super # call observable constructor

		@[property] = attributes[property] for property of attributes
		@make() if @autoMake
		@initialize(attributes)

	make: ->
		@el = document.createElement(@tag)
		$(@el).attr(@attributes)

	initialize: ->

	render: ->

	destroy: ->
		$(this.el).remove()