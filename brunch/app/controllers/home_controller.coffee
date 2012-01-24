class exports.HomeController extends Controller
	events:
		"click a": "onClickLink"

	show: ->
		self=@
		$("body").html self.view.render().el
		self.delegateEvents()
		self