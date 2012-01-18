SequentialDownloader = ->
SequentialDownloader.tag 								= "SequentialDownloader"
SequentialDownloader.filesystem_fetching = false
SequentialDownloader.filesystem          = null
SequentialDownloader.queue               = new Array()

SequentialDownloader.initFilesystem = (success, fail) ->
	return if SequentialDownloader.filesystem_fetching
	SequentialDownloader.filesystem_fetching = true
	window.requestFileSystem LocalFileSystem.PERSISTENT, 0
	, (fs) ->
		console.log fs.name
		SequentialDownloader.filesystem = fs
		success() if success?
		SequentialDownloader.filesystem_fetching = false
		SequentialDownloader.downloadNextFile()
	, (evt) ->
		console.log evt
		fail(evt) if fail?
		SequentialDownloader.filesystem_fetching = false

SequentialDownloader.downloadNextFile = ->
	return if SequentialDownloader.queue.length < 1
	return if !(nextFile = SequentialDownloader.queue.pop())?
	fileTransfer = new FileTransfer()
	fileTransfer.download nextFile.url, SequentialDownloader.filesystem.root.fullPath + '/' + nextFile.path,
			(entry) ->
				console.log nextFile.url
				console.log entry.fullPath
				nextFile.success nextFile.url, entry.fullPath if nextFile.success?
				SequentialDownloader.downloadNextFile()
		,
			(error) ->
				console.log error
				nextFile.fail(error) if nextFile.fail?


# when static download method is used the downloads are queued (LIFO stack)
# and launched one after another (sequential download)
SequentialDownloader.download = (url, path, success, fail) ->
	SequentialDownloader.queue.push {url: url, path: path, success: success, fail: fail}
	if SequentialDownloader.filesystem?
		SequentialDownloader.downloadNextFile()
	else if !SequentialDownloader.filesystem_fetching
		SequentialDownloader.initFilesystem(null, null)

# when new instance is created the download is launched immediatly
class exports.DownloadHelper extends SequentialDownloader
	constructor: (url, path, success, fail) ->
		SequentialDownloader.download url, path, success, fail
		self=@

#	checkInternalMemory: ->
#		self=@
#
#		PhoneGap.exec((size) ->
#			alert(size)
#		, -> alert "ok"
#		, "File", "getFreeDeviceSpace", [])
