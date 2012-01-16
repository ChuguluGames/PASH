class exports.DownloadHelper
	constructor: ->
		self=@
		self.fileTransfer = new FileTransfer()

	download: (options) ->
		self=@

		# self.checkInternalMemory()

		self.fileTransfer.download options.url, options.path,
			(file) -> options.onDownload file,
			(error) -> options.onError error

		request = (num) ->
			console.log num
			window.requestFileSystem num, 0,
				(fileSystem) ->
					console.log "success"
					console.log fileSystem.name
				,(evt) ->
					console.log "error"
					console.log evt.code

		for num in [0..3]
			request num

		# request range...

	checkInternalMemory: ->
		self=@

		PhoneGap.exec((size) ->
			alert(size)
		, -> alert "ok"
		, "File", "getFreeDeviceSpace", [])
