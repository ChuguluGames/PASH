homeTemplate = require('templates/home')
ItemModel 				= require('models/item_model').ItemModel
DifferenceModel 				= require('models/difference_model').DifferenceModel
DifferencesCollection 				= require('collections/differences_collection').DifferencesCollection

class exports.HomeView extends Backbone.View
	id: 'home-view'

	render: ->
		self=@
		$(self.el).html homeTemplate()

<<<<<<< Updated upstream
		item = new ItemModel({
			first_image_url: "lolo1.jpg"
			second_image_url: "lolo2.jpg"
			differences: new DifferenceCollection()
		})

		difference = new DifferenceModel(item: item)

		difference.set({item: item});
		item.get("differences").add(difference)

		item.save (item) ->
			console.log item
		, null, true

		item.set({first_image_url: "heho"});

		item.save()
		@
=======
		# "sdcard/external_sd/pash/patate.jpg"

		app.helpers.downloader.download({
			url: "http://static.skynetblogs.be/media/77706/dyn004_original_353_449_jpeg_2630690_3efd8d11723aaa3f7ba2f2712d59e33f.jpg"
			path: "data/data/com.phonegap.pash/images/patate.jpg"
			onDownload: (file) ->
				console.log "downloaded"
				$(self.el).append "<img src='file:///data/data/com.phonegap.pash/images/patate.jpg' />"
			onError: (error) ->
				console.log "download error source " + error.source
				console.log "download error target " + error.target
				console.log "upload error code" + error.code
		})
		self

	onFileSystemSuccess: (fileSystem) ->
		console.log fileSystem.name
		console.log fileSystem.root.name

	fail: (error) ->
		console.log "patate"
		console.log error.code

		# ce quon a besoin c'est decouter le pack donc de savoir loersque toutes les images sont downloadees
		# vu qu'a chaque download, on peut avoir un event, on peut aussi par exemple bindé le model du pack
		# il faut donc que les image soient linkée avecun pack et sauvegardée et md5

		# download une image
		# secure it => text files encoded or sqlite db
		#
>>>>>>> Stashed changes
