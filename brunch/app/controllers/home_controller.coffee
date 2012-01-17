class exports.HomeController extends Controller
	show: ->
		$("body").html @view.render().el