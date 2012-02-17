# table definition
ImageDefinition = persistence.define 'image',
	url:  "TEXT"
	path: "TEXT"

ImageDefinition::getSrc = ->
  encodeURI(if LocalFileSystem? then @path else @url)

exports.ImageModel = ImageDefinition