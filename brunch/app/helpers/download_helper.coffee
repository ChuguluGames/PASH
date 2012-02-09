class SequentialDownloader
	@tag     = "SequentialDownloader"
	@queue   = []

	@downloadNextFile = ->
		return if @queue.length < 1
		return if !(nextFile = @queue.pop())?
		fileTransfer = new FileTransfer()
		fileTransfer.download nextFile.url, nextFile.path,
				(entry) =>
					nextFile.success nextFile.url, entry.fullPath if nextFile.success?
					@downloadNextFile()
			, nextFile.fail

	# when static download method is used the downloads are queued (LIFO stack)
	# and launched one after another (sequential download)
	@download = (url, path, success, fail) ->
		return (success(url, path) if success?) if !FileTransfer?
		@queue.push {url: url, path: path, success: success, fail: fail}
		@downloadNextFile() if SequentialDownloader.queue.length == 1

# when new instance is created the download is launched immediatly
class exports.DownloadHelper extends SequentialDownloader
	constructor: (url, path, success, fail) ->
		SequentialDownloader.download url, path, success, fail
