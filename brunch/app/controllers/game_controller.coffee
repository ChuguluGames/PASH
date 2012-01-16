class exports.GameController extends Controller
	loadItem: (item) ->
		@show()

	show: ->
		$("body").html @view.render().el