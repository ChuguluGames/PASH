class exports.HomeController extends Controller
	show: ->
		self=@
		$("body").html self.view.render().el