class exports.HomeController extends Controller
	events:
		"click a": "onClickLink"

	show: ->
		$("body").html @view.render().el
		@delegateEvents()
		@