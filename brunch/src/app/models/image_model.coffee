class exports.ImageModel extends Backbone.Model
	onDownload: (file) ->
		console.log "on download"

	onError: (error) ->
		console.log "download error source " + error.source
		console.log "download error target " + error.target
		console.log "upload error code" + error.code