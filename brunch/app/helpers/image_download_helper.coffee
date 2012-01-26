ImageDownloader = ->
ImageDownloader.tag = "ImageDownloader"

ImageDownloader.getImageExtension = (imgUrl) ->
  matches = /\.[a-zA-Z0-9]{1-5}$/.exec(imgUrl)
  if matches?
    return matches[0]
  '.jpg'

ImageDownloader.getLocalImagePath = (object, imgUrl, imgName) ->
  object._type + '/' + object.identity + '/' + imgName + ImageDownloader.getImageExtension(imgUrl)

ImageDownloader.getRemoteImageUrl = (imgUrl) ->
  app.helpers.config.getAssetsBaseUrl() + '/' + imgUrl

ImageDownloader.download = (imgUrl, object, imgName, callback, pretend) ->
  return (callback(null) if callback?) if !imgUrl?
  app.helpers.fs.getContentDownloadPath (contentEntry) ->
    url  = ImageDownloader.getRemoteImageUrl(imgUrl)
    path = contentEntry.fullPath + '/' + ImageDownloader.getLocalImagePath(object, imgUrl, imgName)
    if pretend?
      console.log "pretending"
      object[imgName] = new ImageModel({url: url, path: path})
      app.helpers.db.save object, ->
          callback(object[imgName]) if callback?
    else
      console.log "downloading fo real"
      app.helpers.downloader.download url, path
      , ->
        object[imgName] = new ImageModel({url: url, path: path})
        app.helpers.db.save object, ->
            callback(object[imgName]) if callback?
      , ->
          callback(null) if callback?
  , ->
    callback(null) if callback?

class exports.ImageDownloadHelper extends ImageDownloader
  constructor: (imgUrl, object, imgName, callback) ->
    ImageDownloader.download imgUrl, object, imgName, callback
    self=@