class exports.OptionsController extends Controller
	show: ->
		self=@
		$("body").html self.view.render().el
		self.delegateEvents()
		self