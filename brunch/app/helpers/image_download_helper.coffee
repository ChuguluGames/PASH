ImageDownloader = ->
ImageDownloader.tag = "ImageDownloader"
ImageDownloader.baseUrl = "https://playboy-preprod.chugulu.com"

ImageDownloader.setBaseUrl = (newUrl) ->
  ImageDownloader.baseUrl = newUrl

ImageDownloader.getImageExtension = (imgUrl) ->
  matches = /\.[a-zA-Z0-9]{1-5}$/.exec(imgUrl)
  if matches?
    return matches[0]
  '.jpg'

ImageDownloader.download = (imgUrl, object, imgName, callback) ->
  return (callback(null) if callback?) if !ImageDownloader.baseUrl? or !imgUrl?
  app.helpers.downloader.download ImageDownloader.baseUrl + '/' + imgUrl, object._type + '/' + object.identity + '/' + imgName + ImageDownloader.getImageExtension(imgUrl)
    , (url, fullPath) ->
      console.log "proute 2"
      newimage = null
# does not work as expected (prefetching problem for some objects)
#      if object[imgName]?
#        newimage             = object[imgName]
#        fileEntry            = new FileEntry()
#        fileEntry.fullPath   = newimage.path
#        fileEntry.filesystem = app.helpers.downloader.filesystem
#        console.log "removing " + fileEntry.fullPath
#        fileEntry.remove ->
#            console.log "remove ok"
#          , ->
#            console.log "remove fail"
      newimage        = new ImageModel() if !newimage?
      newimage.url    = url
      newimage.path   = fullPath
      object[imgName] = newimage
      app.helpers.db.save object, ->
          callback(newimage) if callback?
    , ->
        console.log "proute 1"
        callback(null) if callback?

class exports.ImageDownloadHelper extends ImageDownloader
  constructor: (imgUrl, object, imgName, callback) ->
    ImageDownloader.download imgUrl, object, imgName, callback
    self=@