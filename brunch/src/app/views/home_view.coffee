homeTemplate = require('templates/home')
brol = false # TODO: remove me (prevents double execution)

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate()
		return @ if brol
		brol = true
		console.log "brol"
#		item = new ItemModel({
#			identity        : 556
#			first_image_url : "assets/items/149/original.jpg"
#			second_image_url: "assets/items/150/original.jpg"
#		})
#
#
#		pack = new PackModel({
#			identity         : 452
#			name             : "test pack"
#			description_text : "descripcheune"
#			preview_image_url: "assets/items/303/preview.png"
#			cover_image_url  : "assets/items/302/cover.jpg"
#			state            : PackModel.STATE_INCOMPLETE
#		})
#
#		pack.items.add(item)
#		app.helpers.db.save item, -> console.log "saved item"
#		app.helpers.db.save pack, -> console.log "saved pack"


#		image = new ImageModel
#			url : "http://google.com/proute.jpg"
#			path: "/root/proute"
#
#		app.helpers.db.save item, -> console.log "bsdsdfdsf"
#		item = null
#		ItemModel.all().limit(1).one null, (o) ->
#			return if !o?
#			console.log o.first_image_url
#			o.first_image  = image
#			o.second_image = image
#			app.helpers.db.save o, -> console.log "flushed"



		console.log "WTF 1"
		packImageDownloaded = (packobj) ->
			console.log "WTF 2-2"
			if (packobj.preview_image? && packobj.cover_image?)
				packobj.state = PackModel.STATE_READY_TO_PLAY

		console.log "WTF 3"
		ItemModel.all().filter('identity', '=', 556).prefetch('pack').prefetch('first_image').prefetch('second_image').one null, (item) ->
				console.log "WTF 3-1"
				return if !item?
				console.log "WTF 3-2"
				app.helpers.image_downloader(item.pack.preview_image_url, item.pack, 'preview_image', packImageDownloaded)
				app.helpers.image_downloader(item.pack.cover_image_url, item.pack, 'cover_image', packImageDownloaded)
				app.helpers.image_downloader(item.first_image_url, item, 'first_image', null)
				app.helpers.image_downloader(item.second_image_url, item, 'second_image', null)


#		some_diff = new DifferenceModel()
#		other_diff = new DifferenceModel()
#		item.differences.add(some_diff)
#		item.differences.add(other_diff)
		@
