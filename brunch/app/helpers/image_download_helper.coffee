class exports.ImageDownloadHelper
  constructor: (imgUrl, object, imgName, callback) ->
    ImageDownloader.download imgUrl, object, imgName, callback
  # dependencies: LogHelper, ConfigHelper, DbHelper, DownloadHelper

  # -- static --
  @tag = "ImageDownloadHelper"

  @getImageExtension = (imgUrl) ->
    matches = /\.[a-zA-Z0-9]{1-5}$/.exec(imgUrl)
    if matches?
      return matches[0]
    '.jpg'

  @getLocalImagePath = (object, imgUrl, imgName) ->
    object._type + '/' + object.identity + '/' + imgName + @getImageExtension(imgUrl)

  @getRemoteImageUrl = (imgUrl) ->
    ConfigHelper.getAssetsBaseUrl() + '/' + imgUrl

  @download = (imgUrl, object, imgName, callback, pretend) ->
    return (callback(null) if callback?) if !imgUrl?
    pathMethod = 'getContentDownloadPath'
    pathMethod = 'getSeedImagesPath' if pretend?
    FileSystemHelper[pathMethod] (contentEntry) =>
      url  = @getRemoteImageUrl(imgUrl)
      path = contentEntry.fullPath + '/' + @getLocalImagePath(object, imgUrl, imgName)
      if pretend?
        LogHelper.info "pretending to download", @tag

        object[imgName] = new ImageModel({url: url, path: path})
        DbHelper.save object, ->
          callback(object[imgName]) if callback?
      else
        LogHelper.info "downloading for real", @tag

        DownloadHelper.download url, path
        , ->
          object[imgName] = new ImageModel({url: url, path: path})
          DbHelper.save object, ->
            callback(object[imgName]) if callback?
        , ->
            callback(null) if callback?
    , ->
      callback(null) if callback?

  # -- static --