class exports.OptionsController extends Controller
	show: ->
		$("body").html @view.render().el
		@delegateEvents()
		@