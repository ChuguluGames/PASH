ImageDownloader = ->

ImageDownloader.tag = "ImageDownloader"
ImageDownloader.baseUrl = null

ImageDownloader.setBaseUrl = (newUrl) ->
  ImageDownloader.baseUrl = newUrl

ImageDownloader.getImageExtension = (teh_url) ->
  matches = /\.[a-zA-Z0-9]{1-5}$/.exec(teh_url)
  if matches?
    return matches[0]
  '.jpg'

ImageDownloader.download = (teh_url, object, img_name, callback) ->
  return if !ImageDownloader.baseUrl?
  app.helpers.downloader.download ImageDownloader.baseUrl + teh_url, object._type + '/' + object.identity + '/' + img_name + ImageDownloader.getImageExtension(teh_url)
    , (url, fullPath) ->
      newimage = null
# does not work as expected (prefetching problem for some objects)
#      if object[img_name]?
#        newimage             = object[img_name]
#        fileEntry            = new FileEntry()
#        fileEntry.fullPath   = newimage.path
#        fileEntry.filesystem = app.helpers.downloader.filesystem
#        console.log "removing " + fileEntry.fullPath
#        fileEntry.remove ->
#            console.log "remove ok"
#          , ->
#            console.log "remove fail"
      if !newimage?
        newimage = new ImageModel()
      newimage.url     = url
      newimage.path    = fullPath
      object[img_name] = newimage
      callback(object) if callback?
      app.helpers.db.save object, -> console.log "saved " + object._type + ' #' + object.identity

class exports.ImageDownloadHelper extends ImageDownloader
  constructor: (teh_url, object, img_name, callback) ->
    ImageDownloader.download teh_url, object, img_name, callback
    self=@