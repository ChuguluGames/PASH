class exports.HomeController extends Controller
	show: ->
		self=@
		# $("body").html self.view.render().el
		self.download (file) ->
			for prop, value of file
				do (prop, value) ->
					console.log prop + ":" + value
			$("body").html self.view.render().el

		reader = new DirectoryReader("data/data/com.phonegap.pash/");
		reader.readEntries((entries)->
			for entry in entries
				do (entry) ->
					console.log entry.name + " " + entry.isDirectory
					console.log entry.fullPath

		,(e)-> console.log e)

		return

	datadir: null
	knownfiles: []
	base: "images/"

	onFSSuccess: (fileSystem) ->
		self = @

		for prop, value of fileSystem
			do (prop, value) ->
				console.log prop + ":" + value

		for prop, value of fileSystem.root
			do (prop, value) ->
				console.log prop + ":" + value


		fileSystem.root.getDirectory self.base, {create: true}, (directory) ->
			self.datadir = directory
			reader = directory.createReader()

			for prop, value of directory
				do (prop, value) ->
					console.log prop + ":" + value

			console.log directory

			reader.readEntries (d) ->
				self.gotFiles(d)

			, (error) ->
				console.log(JSON.stringify(e))

			, (error) ->
				console.log(JSON.stringify(e))

	gotFiles: (entries) ->
		console.log("The dir has "+entries.length+" entries.")
		for entry in entries
			do (entry) ->
				console.log entry.name + " " + entry.isDirectory
				console.log entry.fullPath

		self.download()

	download: (callback) ->
		ft = new FileTransfer()
		ft.download "http://www.google.fr/images/srpr/logo3w.png", "data/data/com.phonegap.pash/images/truct/test/zizi/image.png", callback, () -> console.log "fail"

# fileSystem.root.getDirectory("data", {create: true});

#     ft.download("http://www.raymondcamden.com/demos/2012/jan/17/" + escape(res[i]), dlPath, function(){
#         renderPicture(dlPath);
#         console.log("Successful download");
#     }, onError);