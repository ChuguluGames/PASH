SequentialDownloader = ->
SequentialDownloader.tag     = "SequentialDownloader"
SequentialDownloader.queue   = []

SequentialDownloader.downloadNextFile = ->
	return if SequentialDownloader.queue.length < 1
	return if !(nextFile = SequentialDownloader.queue.pop())?
	fileTransfer = new FileTransfer()
	fileTransfer.download nextFile.url, nextFile.path,
			(entry) ->
				nextFile.success nextFile.url, entry.fullPath if nextFile.success?
				SequentialDownloader.downloadNextFile()
		, nextFile.fail


# when static download method is used the downloads are queued (LIFO stack)
# and launched one after another (sequential download)
SequentialDownloader.download = (url, path, success, fail) ->
	return (success(url, path) if success?) if !FileTransfer?
	SequentialDownloader.queue.push {url: url, path: path, success: success, fail: fail}
	SequentialDownloader.downloadNextFile() if SequentialDownloader.queue.length == 1

# when new instance is created the download is launched immediatly
class exports.DownloadHelper extends SequentialDownloader
	constructor: (url, path, success, fail) ->
		SequentialDownloader.download url, path, success, fail
		self=@
