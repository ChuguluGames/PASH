# table definition
ImageDefinition = persistence.define 'image',
  url:  "TEXT"
  path: "TEXT"

# relations

# custom methods
# ItemDefinition.fetchSelected = ->
# ItemDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

ImageDefinition.prototype.getSrc = ->
  self=@
  (if LocalFileSystem? then self.path else self.url)

# making it visible outside as Model
exports.ImageModel = ImageDefinition
