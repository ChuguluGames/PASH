helper = {}

helper.shouldSeed = (callback) ->
  TagModel.all().count (tagCount) ->
    return callback(false) if tagCount > 0
    PackModel.all().count (packCount) ->
      return callback(false) if packCount > 0
      callback(true)

helper.moveImages = (success, fail) ->
  app.helpers.fs.getContentDownloadPath (destinationEntry) ->
    return (success() if success?) if destinationEntry.fullPath == ''
    app.helpers.fs.getSeedItemImagesPath (itemEntry) ->
      itemEntry.copyTo destinationEntry, null, ->
        app.helpers.fs.getSeedPackImagesPath (packEntry) ->
          packEntry.copyTo destinationEntry, null, ->
            success() if success?
          , fail #packEntry.copyTo
        , fail #getSeedPackImagesPath
      , fail #itemEntry.copyTo
    , fail #getSeedItemImagesPath
  , fail #getContentDownloadPath

helper.seed = (success, fail) ->
  helper.shouldSeed (should) ->
    return success() if not should
    app.helpers.model_downloader.getLocalAll ->
      helper.moveImages success, fail

exports.SeedHelper = helper
